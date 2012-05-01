//
//  CartTableViewController.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface CartTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkOutBarButtonItem;
@property (nonatomic, weak) IBOutlet UILabel *totalOrderLabel;

- (IBAction)CheckOut:(id)sender;

@end
