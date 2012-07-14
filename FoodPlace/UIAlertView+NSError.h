//
//  UIAlertView+NSError.h
//  FoodPlace
//
//  Created by vo on 7/14/12.
//
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NSError)

+ (UIAlertView *)showWithError:(NSError *)error;

@end
