//
//  LocationTableViewController.m
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationTableViewController.h"
#import "Place+Create.h"
#import "FoodPlaceAppDelegate.h"

@interface LocationTableViewController ()

@end

@implementation LocationTableViewController

@synthesize document = _document;

#pragma mark - Initialize Data

// setup fetched result controller
- (void)setupFetchedResultsController {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"distance" 
                                                                                     ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

// use document
- (void)useDocument {

    // open document
    if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController]; // fetch data
        }];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController]; // fetch data
    }
}

- (void)setDocument:(UIManagedDocument *)document {
    
    if (_document != document) {
        _document = document;
        [self useDocument];
    }
}

// load data
- (void)loadData {
    
    self.title = @"Location";
    
    // load document
    self.document = FoodPlaceAppDelegate.sharedDocument;
    
    // load location manager
    CLLocationManager *locationManager = FoodPlaceAppDelegate.sharedLocationManager;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation]; // start updating location
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // load data
    [self loadData];
}

- (void)viewDidUnload {
    
    [self setDocument:nil];
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocationManagerDelegate

// distance from places
- (void)sortPlacesByDistanceFrom:(CLLocation *)location {
    
    // define placeLocation (block way)
    __block CLLocation *placeLocation;
    // get places to NSMutableArray
    NSArray *places = [self.fetchedResultsController fetchedObjects];
    [places enumerateObjectsUsingBlock:^(Place *place, NSUInteger idx, BOOL *stop) {
        // init place with latitude and longitude
        placeLocation = [[CLLocation alloc] initWithLatitude:[place.lat doubleValue] 
                                                   longitude:[place.log doubleValue]];
        // calculate distance from places
        place.distance = [NSNumber numberWithDouble:[placeLocation distanceFromLocation:location] / 1000]; 
    }];
}

// update location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocatio
{
    [self sortPlacesByDistanceFrom:newLocation]; // distance from places
    [self.tableView reloadData]; // reload data tableView
    [manager stopUpdatingLocation]; // stop updating location  
}

// error with alert
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Error obtaining location."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    UITableViewCell *cell = [sender dequeueReusableCellWithIdentifier:@"Place Cell"];
    
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // convert NSNumber to float
    float placeDistance = [place.distance floatValue]; 
    
    // check plade distance and place name exist
    if (placeDistance && place.name) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", place.name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f km", placeDistance];
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // copy place object to next ViewController
    if ([segue.destinationViewController respondsToSelector:@selector(setPlace:)]) {
        [segue.destinationViewController performSelector:@selector(setPlace:) withObject:place];
    }
  
    // copy document object to next ViewController
    if ([segue.destinationViewController respondsToSelector:@selector(setDocument:)]) {
        [segue.destinationViewController performSelector:@selector(setDocument:) withObject:self.document];
    }
}

@end
