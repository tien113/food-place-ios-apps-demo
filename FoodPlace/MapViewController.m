//
//  MapViewController.m
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "FoodPlaceAppDelegate.h"
#import "FoodPlaceFetcher.h"
#import "PlaceAnnotationView.h"
#import "UIAlertViewE.h"
#import "Define.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize buttonBarSegmentedControl = _buttonBarSegmentedControl;
@synthesize annotations = _annotations;
@synthesize places = _places;

#pragma mark - Add Annotaions to Places

// return NSArray Annotation
- (NSArray *)mapAnnotations {
    
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:self.places.count];
    [self.places enumerateObjectsUsingBlock:^(NSDictionary *place, NSUInteger idx, BOOL *stop) {
        [annotations addObject:[PlaceAnnotationView annotationForPlace:place]]; // add annotation to places
    }]; 
    return annotations;
}

#pragma mark - Fetch Places from Web Service

// fetch Places from Web Service
- (NSArray *)places {
    
    if (!_places) {
        dispatch_queue_t downloadQ = dispatch_queue_create("Place downloader", NULL);
        dispatch_async(downloadQ, ^{
            _places = FoodPlaceFetcher.getPlaces; // get Places and return NSArray
        });
        dispatch_release(downloadQ);
    }
    
    return _places;
}

// init data
- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self places];
}

- (void)setPlaces:(NSArray *)places {
    
    if (_places != places) {
        _places = places;
    }
}

#pragma mark - Synchronize Model and View

- (void)updateMapView
{
    // remove annotation if they exist
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    
    // add annotation if they dont exist
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    if (_mapView != mapView) {
        _mapView = mapView;
        [self updateMapView]; // update MapView
    }    
}

- (void)setAnnotations:(NSArray *)annotations
{
    if (_annotations != annotations) {
        _annotations = annotations;
        [self updateMapView]; // update MapView
    }
}

#pragma mark - MKMapViewDelegate

// view for annotation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation 
{
    // check annotation is MKUserLocation class
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
       return nil; // return nil if its
    } 
    
    // check annotation is PlaceAnnotation class
    if ([annotation isKindOfClass:[PlaceAnnotationView class]]) 
    {
        MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:MY_PIN]; // set name MKAnnotationView
        if (!aView) {
            aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MY_PIN];
            aView.canShowCallout = YES; // set call out  
            aView.calloutOffset = CGPointMake(0, 0); // set position call out off set
            aView.image = [UIImage imageNamed:MY_PIN_IMAGE]; // set place's image for pin
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)]; // set frame for pin's image
            aView.selected = YES; // set selected
        }
        
        aView.annotation = annotation;
        [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
        
        return aView;
    }
    
    return nil;    
}

// image for annotation
- (UIImage *)image:(id)sender imageForAnnotation:(id <MKAnnotation>)annotation {

    PlaceAnnotationView *pav = (PlaceAnnotationView *)annotation;
    // get image's url
    NSURL *url = [FoodPlaceFetcher urlForPlace:pav.place]; 
    // get data from url
    NSData *data = [NSData dataWithContentsOfURL:url]; 
    // return image
    return data ? [UIImage imageWithData:data] : nil;
} 

// load image when selecting
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView {
       
    UIImage *image = [self image:self imageForAnnotation:aView.annotation];
    // load annotation's image
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

#pragma mark - CLLocationManagerDelegate

// update location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // set span use latitude and longitude
    MKCoordinateSpan span = MKCoordinateSpanMake(LATITUDE_DELTA, LONGITUDE_DELTA);
    // set region use coordinate and span
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
    // set region to mapView
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"Latitude: %f, Longitude: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    [manager stopUpdatingLocation]; // stop updating location
}

// error and show alert
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIAlertView showWithError:error];
    });
}

#pragma mark - Segmented Control

// setup Segmented Control
- (void)setupSegmentedControl
{
    // action for segmented control
    [self.buttonBarSegmentedControl addTarget:self 
                                       action:@selector(toggleToolBarChange:) 
                             forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.buttonBarSegmentedControl]; // add segmented control to mapView
}

- (void)toggleToolBarChange:(id)sender
{
    UISegmentedControl *segControl = sender;
    
    switch (segControl.selectedSegmentIndex) {
        case 0:
        {
            [self.mapView setMapType:MKMapTypeStandard]; // set mapView to Standard
            break;
        }
        case 1:
        {
            [self.mapView setMapType:MKMapTypeSatellite]; // set mapView to Satellite
            break;
        }
        case 2:
        {
            [self.mapView setMapType:MKMapTypeHybrid]; // set mapView to Hybrid
            break;
        }
    }
}

#pragma mark - 

- (void)displayMap {
    
    // load latitude and longitude
    CLLocationCoordinate2D coords;
    coords.latitude = LATITUDE;
    coords.longitude = LONGITUDE;
    
    // set span use latitude and longitude
    MKCoordinateSpan span = MKCoordinateSpanMake(LATITUDE_DELTA, LONGITUDE_DELTA);
    // set region use coordinate and span
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, span);
    [self.mapView setRegion:region animated:YES]; // set region to mapView
    
    [self.mapView addAnnotations:[self mapAnnotations]]; // set annotations to mapView
    
}

// load data
- (void)loadData {
    
    self.mapView.delegate = self; // set delegate to self
    self.mapView.mapType = MKMapTypeStandard; // set map type to standard
    
    // run another thread to displayMap
    [NSThread detachNewThreadSelector:@selector(displayMap) 
                             toTarget:self 
                           withObject:nil];
    
    // setup segmented control
    [self setupSegmentedControl]; 
}

// show user location
- (void)showUserLocation {
    
    // load location manager
    CLLocationManager *locationManager = FoodPlaceAppDelegate.sharedLocationManager;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation]; // start updating location
    
    self.mapView.showsUserLocation = TRUE; // set show userlocation to TRUE
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    [self loadData]; // load data
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setButtonBarSegmentedControl:nil];
    [self setAnnotations:nil];
    [self setPlaces:nil];
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
}

#pragma mark - Action

- (IBAction)showLocation:(id)sender {
    
    // show user location
    [self showUserLocation];
}

@end
