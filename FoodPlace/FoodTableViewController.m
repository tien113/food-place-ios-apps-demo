//
//  FoodTableViewController.m
//  FoodPlace
//
//  Created by vo on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodTableViewController.h"
#import "FoodPlaceFetcher.h"
#import "Food+Create.h"
#import "FoodCell.h"
#import "Place.h"
#import "FoodPlaceAppDelegate.h"
#import "SpinnerView.h"

#define showSpinnerView() self.spinner = [SpinnerView loadSpinnerIntoView:self.tabBarController.view]
#define hideSpinnerView() [self.spinner removeSpinner]

@interface FoodTableViewController ()

@property (nonatomic, strong) SpinnerView *spinner;

@end

@implementation FoodTableViewController

@synthesize spinner =_spinner;
@synthesize document = _document;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;

#pragma mark - Initialize Data

// setup fetched result controller
- (void)setupFetchedResultsController {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    // [request setFetchBatchSize:5];
    // [request setFetchLimit:7];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" 
                                                                                     ascending:YES 
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.document.managedObjectContext
                                                                          sectionNameKeyPath:nil 
                                                                                  cacheName:nil];
}

// fetch data from Web Service into Core Data
- (void)fetchWebServiceIntoDatabase:(UIManagedDocument *)document {
    
    // create queue for Food Fetcher
    dispatch_queue_t fetchQ = dispatch_queue_create("Food Place Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *foods = [FoodPlaceFetcher getFoods]; // get foods from Web Service to NSArray
        [document.managedObjectContext performBlock:^{
            [foods enumerateObjectsUsingBlock:^(NSDictionary *food, NSUInteger idx, BOOL *stop) {
                [Food foodWithWebService:food inManagedObjectContext:document.managedObjectContext]; // add foods to Core Data
            }];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL]; // save to document
        }];
    });
    dispatch_release(fetchQ); // release fetchQ
}

// use document
- (void)useDocument {
    
    // check document exists or not
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController]; // fetch data
            [self fetchWebServiceIntoDatabase:self.document]; // fetch data to Document
        }];
        // if document state is closed, open and using it
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
        // if document state is normal, use it
    } else if (self.document.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setDocument:(UIManagedDocument *)document {
    
    if (_document != document) {
        _document = document;
        [self useDocument]; // use document
    }
}

// load document and indicator
- (void)loadData {
    
    // show network activity indicator
    showSpinnerView();
    
    // load document
    self.document = [FoodPlaceAppDelegate sharedDocument];
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewDidUnload {
    
    [self setDocument:nil];
    [self setImageDownloadsInProgress:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

// set rotation 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hide network activity indicator
    hideSpinnerView();
    
    // FoodCell 
    FoodCell *cell = (FoodCell *)[sender dequeueReusableCellWithIdentifier:@"Food Cell"];

    Food *food = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.foodNameLabel.text = [NSString stringWithFormat:@"%@", food.name];
    cell.placeNameLabel.text = [NSString stringWithFormat:@"%@", food.place.name];
    cell.priceNameLabel.text = [NSString stringWithFormat:@"%@%@", EURO, [food.price stringValue]];
 
    // only load cached images; defer new downloads until scrolling ends
    if (!food.image) 
    {   
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) 
        {
            [self startImageDownload:food forIndexPath:indexPath];
        }
        // if a download is deffered or in progress, return empty image
        cell.foodImageView.image = nil;
        
    } else {
    
        cell.foodImageView.image = food.image;
    }
  
    return cell; 
    
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath =[self.tableView indexPathForCell:sender];
    Food *food = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // copy food object to next ViewController
    if ([segue.destinationViewController respondsToSelector:@selector(setFood:)]) {
        [segue.destinationViewController performSelector:@selector(setFood:) 
                                              withObject:food];
    }
    
    // copy document object to next ViewController
    if ([segue.destinationViewController respondsToSelector:@selector(setDocument:)]) {
        [segue.destinationViewController performSelector:@selector(setDocument:) 
                                              withObject:self.document];
    }
}

#pragma mark - Lazy Image Downloader support

// start download image
- (void)startImageDownload:(Food *)food forIndexPath:(NSIndexPath *)indexPath {
    
    LazyImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    
    if (imageDownloader == nil){
        imageDownloader = [[LazyImageDownloader alloc] init];
        imageDownloader.food = food;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
    }
}

// called by our LazyImageDownloader when an image is ready to be displayed
- (void)imageDidLoad:(NSIndexPath *)indexPath {
    
    LazyImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil) 
    {
        FoodCell *cell = (FoodCell *)[self.tableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // display the newly loaded image
        cell.foodImageView.image = imageDownloader.food.image;
    }
}

// this method is used in case the user scrolled into a set of cells that dont have their image yet
- (void)loadImagesForOnScreenRows
{
    int count = [[self.fetchedResultsController fetchedObjects] count];    
    // NSLog(@"%d", count);
    if (count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        [visiblePaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            Food *food = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            if (!food.image) // avoid the image download if the image has already
            {
                [self startImageDownload:food forIndexPath:indexPath];
            }
        }];
    }
}

#pragma mark - UIScrollViewDelegate

// load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnScreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnScreenRows];
}

@end
