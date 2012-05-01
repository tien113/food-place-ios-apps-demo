//
//  ImageDownloader2.m
//  FoodPlace
//
//  Created by vo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LazyImageDownloader.h"

@implementation LazyImageDownloader

@synthesize food = _food;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize delegate = _delegate;

#pragma mark - NSURLConnection Asynchronous

- (void)startDownload {
    
    NSURL *url = [NSURL URLWithString:self.food.image_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0f];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
    
    ShowNetworkActivityIndicator();
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         
         // reading http status code
         [self readHttpStatusCodeFromResponse:response];
         
         // check data
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
    [self.delegate imageDidLoad:self.indexPathInTableView];
}

#pragma mark -

- (void)readHttpStatusCodeFromResponse:(NSURLResponse *)response {
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        int code = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"%d", code);
    }
}

- (void)imageWithData:(NSData *)data {
    
    UIImage *image = [[UIImage alloc] initWithData:data];       
    dispatch_async(dispatch_get_main_queue(), ^{
        
        HideNetworkActivityIndicator();
        
        self.food.image = image;            
    });
}

#pragma mark -

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
