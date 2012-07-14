//
//  UIAlertView+NSError.m
//  FoodPlace
//
//  Created by vo on 7/14/12.
//
//

#import "UIAlertView+NSError.h"

@implementation UIAlertView (NSError)

+ (UIAlertView *)showWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                    message:error.localizedRecoverySuggestion
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}

@end
