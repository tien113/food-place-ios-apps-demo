//
//  IdentificationViewController.m
//  FoodPlace
//
//  Created by vo on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IdentificationViewController.h"
#import "Cryptography.h"

@interface IdentificationViewController ()

@end

@implementation IdentificationViewController

@synthesize idLabel = _idLabel;

- (void)showAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help" 
                                                        message:@"You should use this ID to identify your order." 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    });
}

- (void)loadData {
    
    self.title = @"Identification";
    
    NSString *macAddress = [MacAddress getMacAddress];
    self.idLabel.text = [macAddress toSHA1];
    [self.idLabel sizeToFit];
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewDidUnload
{
    [self setIdLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - outlet

- (IBAction)help:(id)sender {
    
    [self showAlert];
}
@end
