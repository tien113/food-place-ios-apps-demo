//
//  ImageDownloader2.m
//  FoodPlace
//
//  Created by vo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LazyImageDownloader.h"
#import "Helpers.h"

@implementation LazyImageDownloader

@synthesize food = _food;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize delegate = _delegate;

#pragma mark - NSURLConnection Asynchronous

- (void)startDownload {
    
    // init food image url
    NSURL *url = [NSURL URLWithString:self.food.image_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0f];
    NSOperationQueue *queue = [NSOperationQueue currentQueue]; // init NSOperationQueue
    
    // show network activity indicator
    ShowNetworkActivityIndicator();
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         
         // reading http status code
         [self readHttpStatusCodeFromResponse:response];
         
         // check data and error
         if ([data length] > 0 && error == nil) {
             [self imageWithData:data];
         } else if ([data length] == 0 && error == nil) {
             [self emptyReply];
         } else if (error != nil && error.code == NSURLErrorTimedOut) {
             [self timeOut];
         } else if (error != nil) {
             [self downloadError:error];
         }
         
     }]; 
    
    // load image with indexPathInTableView
    [self.delegate imageDidLoad:self.indexPathInTableView];
}

#pragma mark - Reading Code and Load Image

- (void)readHttpStatusCodeFromResponse:(NSURLResponse *)response {
    
    // check response is NSHTTPURLResponse class
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        // get status code
        int responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"%d", responseCode); // log code
    }
}

- (void)imageWithData:(NSData *)data {
    
    // init image with data
    UIImage *image = [[UIImage alloc] initWithData:data];       
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // hide network activity indicator
        HideNetworkActivityIndicator();
        
        self.food.image = image;            
    });
}

#pragma mark - Error Log

- (void)emptyReply {
    
    NSLog(@"NO DATA!!!");
}

- (void)timeOut {
    
    NSLog(@"Time Out!!!");
}

- (void)downloadError:(NSError *)error {
    
    NSLog(@"%@", error.localizedDescription);
}

@end
