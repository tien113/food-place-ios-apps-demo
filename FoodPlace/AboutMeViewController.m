//
//  AboutMeViewController.m
//  FoodPlace
//
//  Created by vo on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *aboutMeTextView;

@end

@implementation AboutMeViewController

@synthesize aboutMeTextView=_aboutMeTextView;

- (void)loadData {
    
    self.title = @"About Me";
    self.aboutMeTextView.text = @"This is my application.";
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load data
    [self loadData];
}

- (void)viewDidUnload {

    [self setAboutMeTextView:nil];
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
