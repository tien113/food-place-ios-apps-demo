//
//  MapViewController.h
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define LATITUDE 63.097458
#define LONGITUDE 21.61903

#define LATITUDE_DELTA 0.0175
#define LONGITUDE_DELTA 0.0175

#define MY_PIN @"MyPin"
#define MY_PIN_IMAGE @"map-pin.png"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *buttonBarSegmentedControl;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSArray *places;

- (IBAction)showLocation:(id)sender;

@end
