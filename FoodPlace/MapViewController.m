//
//  MapViewController.m
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FoodPlaceAppDelegate.h"
#import "FoodPlaceFetcher.h"
#import "PlaceAnnotationView.h"

@interface MapViewController () 

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize buttonBarSegmentedControl = _buttonBarSegmentedControl;
@synthesize annotations = _annotations;
@synthesize places = _places;

#pragma mark - Add Annotaions to Places

- (NSArray *)mapAnnotations {
    
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.places count]];
    [self.places enumerateObjectsUsingBlock:^(NSDictionary *place, NSUInteger idx, BOOL *stop) {
        [annotations addObject:[PlaceAnnotationView annotationForPlace:place]];
    }]; 
    return annotations;
}

#pragma mark - Fetch Places from Web Service

- (void)fetchPlaces {
    
    dispatch_queue_t downloadQ = dispatch_queue_create("Place downloader", NULL);
    dispatch_async(downloadQ, ^{
        self.places = [FoodPlaceFetcher getPlaces];
    });
    dispatch_release(downloadQ);
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self fetchPlaces];
}

- (void)setPlaces:(NSArray *)places {
    
    if (_places != places) {
        _places = places;
    }
}

#pragma mark - Synchronize Model and View

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    if (_mapView != mapView) {
        _mapView = mapView;
        [self updateMapView];
    }    
}

- (void)setAnnotations:(NSArray *)annotations
{
    if (_annotations != annotations) {
        _annotations = annotations;
        [self updateMapView];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation 
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    } 
    
    if ([annotation isKindOfClass:[PlaceAnnotationView class]]) {
        
        MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:MY_PIN];
        if (!aView) {
            aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MY_PIN];
            aView.canShowCallout = YES;  
            aView.calloutOffset = CGPointMake(0, 0);
            aView.image = [UIImage imageNamed:MY_PIN_IMAGE];
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [aView setSelected:YES];
        }
        
        aView.annotation = annotation;
        [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
        
        return aView;
    }
    
    return nil;    
}

- (UIImage *)image:(id)sender imageForAnnotation:(id <MKAnnotation>)annotation {

    PlaceAnnotationView *pav = (PlaceAnnotationView *)annotation;
    NSURL *url = [FoodPlaceFetcher urlForPlace:pav.place];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
} 

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView {
       
    UIImage *image = [self image:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateSpan span = MKCoordinateSpanMake(LATITUDE_DELTA, LONGITUDE_DELTA);
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"Latitude: %f, Longitude: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
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

#pragma mark - Segmented Control

- (void)setupSegmentedControl
{
    [self.buttonBarSegmentedControl addTarget:self action:@selector(toggleToolBarChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.buttonBarSegmentedControl];
}

- (void)toggleToolBarChange:(id)sender
{
    UISegmentedControl *segControl = sender;
    
    switch (segControl.selectedSegmentIndex) {
        case 0:
        {
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        }
        case 1:
        {
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        }
        case 2:
        {
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        }
    }
}

#pragma mark - 

- (void)displayMap {
    
    CLLocationCoordinate2D coords;
    coords.latitude = LATITUDE;
    coords.longitude = LONGITUDE;
    MKCoordinateSpan span = MKCoordinateSpanMake(LATITUDE_DELTA, LONGITUDE_DELTA);
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, span);
    [self.mapView setRegion:region animated:YES];
    
    [self.mapView addAnnotations:[self mapAnnotations]];
    
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    
    [NSThread detachNewThreadSelector:@selector(displayMap) toTarget:self withObject:nil];
    
    [self setupSegmentedControl]; 
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setButtonBarSegmentedControl:nil];
    [self setAnnotations:nil];
    [self setPlaces:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
}

#pragma mark - IBOutlet

- (IBAction)showLocation:(id)sender {
    
    CLLocationManager *locationManager = [FoodPlaceAppDelegate sharedLocationManager];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = TRUE;
}

@end
