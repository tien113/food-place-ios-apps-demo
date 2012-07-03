//
//  FoodDetailTableViewController.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cart+Food.h"
#import "BadgeValue.h"

@interface FoodDetailTableViewController : UITableViewController <BadgeValueDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *foodIngredientTextView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) Food *food;

- (IBAction)AddToCart:(id)sender;

@end
