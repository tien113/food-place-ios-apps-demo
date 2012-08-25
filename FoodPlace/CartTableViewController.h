//
//  CartTableViewController.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "OrderUploader.h"
#import "BadgeValue.h"

@interface CartTableViewController : CoreDataTableViewController <UIAlertViewDelegate, UIActionSheetDelegate, OrderUploaderDelegate, BadgeValueDelegate>

@property (nonatomic, strong) UIManagedDocument *document;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *placeOrderBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *emptyCartBarButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *totalOrderLabel;

- (IBAction)PlaceOrder:(id)sender;
- (IBAction)EmptyCart:(id)sender;

@end
