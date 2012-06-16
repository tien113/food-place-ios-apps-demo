//
//  SpinnerView.m
//  FoodPlace
//
//  Created by vo on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpinnerView

#pragma mark - SpinnerView

// init SpinnerView 
+ (SpinnerView *)loadSpinnerIntoView:(UIView *)superView {
    
    SpinnerView *spinnerView = [[SpinnerView alloc] initWithFrame:superView.bounds];
    if (!spinnerView) {
        return nil;
    }
    UIImageView *background = [[UIImageView alloc] initWithImage:spinnerView.addBackground];
    background.alpha = 0.7f;
    [spinnerView addSubview:background];
    
    // init indicator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    // set indicator in center
    indicator.center = superView.center;
    [spinnerView addSubview:indicator];
    [indicator startAnimating];
   
    [superView addSubview:spinnerView];
    
    // transition
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[superView layer] addAnimation:animation forKey:@"layerAnimation"];
    
    return spinnerView;
}

// remove spinner
- (void)removeSpinner {
    
    // transition
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[[self superview] layer] addAnimation:animation forKey:@"layerAnimation"];
    
    [super removeFromSuperview];
}

// add background to SpinnerView
- (UIImage *)addBackground {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1);
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.4, 0.4, 0.4, 0.8, 
                              0.1, 0.1, 0.1, 0.5 };
    
    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, num_locations);
    
    float myRadius = (self.bounds.size.width * 0.8) / 2;
    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), myGradient, self.center, 0, 
                                self.center, myRadius,kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGColorSpaceRelease(myColorSpace);
    CGGradientRelease(myGradient);
    UIGraphicsEndImageContext();
    
    return image;
}

@end
