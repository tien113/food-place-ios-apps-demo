//
//  CartCell.h
//  FoodPlace
//
//  Created by vo on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *foodNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;

@end
