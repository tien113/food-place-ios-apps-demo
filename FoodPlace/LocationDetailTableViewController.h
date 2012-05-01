//
//  LocationDetailTableViewController.h
//  FoodPlace
//
//  Created by vo on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface LocationDetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;
@property (weak, nonatomic) IBOutlet UITextView *phoneNumberTextView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingTime1Label;
@property (weak, nonatomic) IBOutlet UILabel *openingTime2Label;
@property (weak, nonatomic) IBOutlet UILabel *openingTime3Label;
@property (weak, nonatomic) IBOutlet UILabel *openingTime4Label;

@property (nonatomic, strong) Place *place;

@end
