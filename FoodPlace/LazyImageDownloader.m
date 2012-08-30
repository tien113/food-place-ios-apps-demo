//
//  ImageDownloader2.m
//  FoodPlace
//
//  Created by vo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LazyImageDownloader.h"
#import "Define.h"
#import "Helpers.h"

@implementation LazyImageDownloader

@synthesize food = _food;
@synthesize indexPathInTableView = _indexPathInTableView;
@synthesize delegate = _delegate;

- (id)initWithObject:(Food *)food delegate:(id)delegate atIndexPathInTableView:(NSIndexPath *)indexPath {
    
    if (self = [super init]) {
        self.food = food;
        self.delegate = delegate;
        self.indexPathInTableView = indexPath;
    }
    return self;
}

#pragma mark - NSURLConnection Asynchronous

- (void)startDownload {
 
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", kHostURL, self.food.image_url];
    
    // init food image url
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0f];
    NSOperationQueue *queue = NSOperationQueue.currentQueue; // init NSOperationQueue
    
    // show network activity indicator
    ShowNetworkActivityIndicator();
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         // reading http status code
         NSUInteger responseCode = [Helpers readHttpStatusCodeFromResponse:response];
         NSLog(@"%d", responseCode);
         
         // check data and error
         if ([data length] > 0 && nil == error) {
             [self imageWithData:data];
             NSLog(@"image data length: %d", [data length]);
         } else if (0 == [data length] && nil == error) {
             [self emptyReply];
         } else if (nil != error && NSURLErrorTimedOut == error.code) {
             [self timeOut];
         } else if (nil != error) {
             [self downloadError:error];
         }
         
     }]; 
    
    // load image with indexPathInTableView
    [self.delegate imageDidLoad:self.indexPathInTableView];
}

#pragma mark - Load Image

- (void)imageWithData:(NSData *)data {
    
    // init image with data
    UIImage *image = [UIImage imageWithData:data];
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
