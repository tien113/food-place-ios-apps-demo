//
//  FoodTableViewController.h
//  FoodPlace
//
//  Created by vo on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FoodTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end
