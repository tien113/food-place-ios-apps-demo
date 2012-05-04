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
    
    static UIManagedDocument *document = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                             inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Food Place Database"]; // set the document's name
        document = [[UIManagedDocument alloc] initWithFileURL:url]; // init document
    });
    return document;
}

// singleton init location manager
+ (CLLocationManager *)sharedLocationManager {
    
    static CLLocationManager *locationManager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        locationManager = [[CLLocationManager alloc] init]; // init location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set accuracy for the GPS
        locationManager.distanceFilter = 80.0f;
    });
    return locationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
