//
//  WebsiteViewController.m
//  FoodPlace
//
//  Created by vo on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebsiteViewController.h"
#import "Helpers.h"

@interface WebsiteViewController () 

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebsiteViewController

@synthesize webView = _webView;

- (void)loadData {
    
    self.title = @"Website";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:kFoodPlaceWebSiteURL];
    [self.webView loadRequest:request]; // web loading with url
    
    // NSTimer for network activity indicator
    [NSTimer scheduledTimerWithTimeInterval:(1.0f/2.0f) 
                                     target:self 
                                   selector:@selector(tick)
                                   userInfo:nil 
                                    repeats:YES];
}

#pragma mark - Check WebView Loading

- (void)tick {
    
    // check web loading or not
    if (self.webView.loading) 
        ShowNetworkActivityIndicator(); // show network activity indicator
    else 
        HideNetworkActivityIndicator(); // hide network activity indicator
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
