//
//  LocationTableViewController.m
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationTableViewController.h"
#import "Place.h"
#import "FoodPlaceAppDelegate.h"

@interface LocationTableViewController ()

@end

@implementation LocationTableViewController

@synthesize document = _document;

#pragma mark - Initialize Data

- (void)setupFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

- (void)useDocument {

    if (self.document.documentState == UIDocumentStateClosed) {
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
    
    self.title = @"Location";
    
    self.document = [FoodPlaceAppDelegate sharedDocument];
    
    CLLocationManager *locationManager = [FoodPlaceAppDelegate sharedLocationManager];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)viewDidUnload {
    
    [self setDocument:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - CLLocationManagerDelegate

- (void)sortPlacesByDistanceFrom:(CLLocation *)location {
    
    __block CLLocation *placeLocation;
    NSMutableArray *places = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    [places enumerateObjectsUsingBlock:^(Place *place, NSUInteger idx, BOOL *stop) {
        placeLocation = [[CLLocation alloc] initWithLatitude:[place.lat doubleValue] longitude:[place.log doubleValue]];
        place.distance = [NSNumber numberWithDouble:[placeLocation distanceFromLocation:location] / 1000];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocatio
{
    [self sortPlacesByDistanceFrom:newLocation];
    [self.tableView reloadData];
    [manager stopUpdatingLocation];  
}

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
    
    float place_distance = [place.distance floatValue];
    
    if (place_distance && place.name) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", place.name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f km", place_distance];
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
    if ([segue.destinationViewController respondsToSelector:@selector(setPlace:)]) {
        [segue.destinationViewController performSelector:@selector(setPlace:) withObject:place];
    }
    if ([segue.destinationViewController respondsToSelector:@selector(setDocument:)]) {
        [segue.destinationViewController performSelector:@selector(setDocument:) withObject:self.document];
    }
}

@end
