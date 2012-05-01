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

- (void)setupFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    // [request setFetchBatchSize:5];
    // [request setFetchLimit:7];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.document.managedObjectContext
                                                                          sectionNameKeyPath:nil 
                                                                                  cacheName:nil];
}

- (void)fetchWebServiceIntoDatabase:(UIManagedDocument *)document {
    
    dispatch_queue_t fetchQ = dispatch_queue_create("Food Place Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *foods = [FoodPlaceFetcher getFoods];
        [document.managedObjectContext performBlock:^{
            [foods enumerateObjectsUsingBlock:^(NSDictionary *food, NSUInteger idx, BOOL *stop) {
                [Food foodWithWebService:food inManagedObjectContext:document.managedObjectContext];
            }];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        }];
    });
    dispatch_release(fetchQ);
}

- (void)useDocument {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self fetchWebServiceIntoDatabase:self.document];
        }];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setDocument:(UIManagedDocument *)document {
    
    if (_document != document) {
        _document = document;
        [self useDocument];
    }
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    showSpinnerView();
    
    self.document = [FoodPlaceAppDelegate sharedDocument];  
    // self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void)viewDidUnload {
    
    [self setDocument:nil];
    [self setImageDownloadsInProgress:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    hideSpinnerView();
    
    FoodCell *cell = (FoodCell *)[sender dequeueReusableCellWithIdentifier:@"Food Cell"];

    Food *food = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.foodNameLabel.text = [NSString stringWithFormat:@"%@", food.name];
    cell.placeNameLabel.text = [NSString stringWithFormat:@"%@", food.place.name];
    cell.priceNameLabel.text = [NSString stringWithFormat:@"%@%@", EURO, [food.price stringValue]];
 
    if (!food.image) 
    {   
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) 
        {
            [self startImageDownload:food forIndexPath:indexPath];
        }
        
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
    if ([segue.destinationViewController respondsToSelector:@selector(setFood:)]) {
        [segue.destinationViewController performSelector:@selector(setFood:) 
                                              withObject:food];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setDocument:)]) {
        [segue.destinationViewController performSelector:@selector(setDocument:) 
                                              withObject:self.document];
    }
}

#pragma mark - Lazy Image Downloader support

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

- (void)imageDidLoad:(NSIndexPath *)indexPath {
    
    LazyImageDownloader *imageDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil) 
    {
        FoodCell *cell = (FoodCell *)[self.tableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        cell.foodImageView.image = imageDownloader.food.image;
    }
}

- (void)loadImagesForOnScreenRows
{
    int count = [[self.fetchedResultsController fetchedObjects] count];    
    NSLog(@"%d", count);
    if (count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        [visiblePaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            Food *food = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if (!food.image) 
            {
                [self startImageDownload:food forIndexPath:indexPath];
            }
        }];
    }
}

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
