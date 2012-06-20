//
//  FoodPlaceAppDelegate.m
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodPlaceAppDelegate.h"

@implementation FoodPlaceAppDelegate

@synthesize window = _window;

// singleton init document
+ (UIManagedDocument *)sharedDocument {
    
    static UIManagedDocument *_document = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                             inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Food Place Database"]; // set the document's name
        _document = [[UIManagedDocument alloc] initWithFileURL:url]; // init document
    });
    return _document;
}

// singleton init location manager
+ (CLLocationManager *)sharedLocationManager {
    
    static CLLocationManager *_locationManager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _locationManager = [[CLLocationManager alloc] init]; // init location manager
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set accuracy for the GPS
        _locationManager.distanceFilter = 80.0f;
    });
    return _locationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
