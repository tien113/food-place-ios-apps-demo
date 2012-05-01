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

#pragma mark - Check WebView Loading

- (void)tick {
    
    if (self.webView.loading) 
        ShowNetworkActivityIndicator();
    else 
        HideNetworkActivityIndicator();
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Website";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:kFoodPlaceWebSiteURL];
    [self.webView loadRequest:request];
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0f/2.0f) 
                                     target:self 
                                   selector:@selector(tick)
                                   userInfo:nil 
                                    repeats:YES];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
