//
//  FoodPlaceAppDelegate.h
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FoodPlaceAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (UIManagedDocument *)sharedDocument;
+ (CLLocationManager *)sharedLocationManager;

@end
