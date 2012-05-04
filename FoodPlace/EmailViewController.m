//
//  EmailViewController.m
//  FoodPlace
//
//  Created by vo on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailViewController.h"

@interface EmailViewController () 
@end

@implementation EmailViewController

// show alert
- (void)showAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Email Account" 
                                                        message:@"You need to setup an email account to send an email." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    });
}

// remove email view controller
- (void)dismissEmailViewController {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"OK"]) {
        [self dismissEmailViewController];
        NSLog(@"OK was selected.");
    }
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showAlert];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
