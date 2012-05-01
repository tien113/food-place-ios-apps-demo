//
//  LocationTableViewController.h
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationTableViewController : CoreDataTableViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) UIManagedDocument *document;

@end
