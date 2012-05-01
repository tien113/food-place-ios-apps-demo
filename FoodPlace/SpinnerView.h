//
//  SpinnerView.h
//  FoodPlace
//
//  Created by vo on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

+ (SpinnerView *)loadSpinnerIntoView:(UIView *)superView;

- (void)removeSpinner;
- (UIImage *)addBackground;

@end
