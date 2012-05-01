//
//  FoodCell.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientButton : UIButton

@property (nonatomic, strong) CAGradientLayer *shineLayer;
@property (nonatomic, strong) CALayer *highlightLayer;

@end
