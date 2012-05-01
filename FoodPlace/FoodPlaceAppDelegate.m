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

+ (UIManagedDocument *)sharedDocument {
    
    static UIManagedDocument *document = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                             inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Default Food Place Database"];
        document = [[UIManagedDocument alloc] initWithFileURL:url];
    });
    return document;
}

+ (CLLocationManager *)sharedLocationManager {
    
    static CLLocationManager *locationManager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 80.0f;
    });
    return locationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

@end
