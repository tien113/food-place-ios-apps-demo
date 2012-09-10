//
//  OrderUploader.m
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderUploader.h"
#import "Define.h"
#import "Helpers.h"

@implementation OrderUploader

@synthesize url = _url;
@synthesize orderData = _orderData;
@synthesize delegate = _delegate;

- (id)initWithURL:(NSURL *)url
         delegate:(id)delegate
        orderData:(NSData *)data {
    
    if (self = [super init]) {
        self.url = url;
        self.delegate = delegate;
        self.orderData = data;
    }
    return self;
}

- (void)startUpload {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url]; // fetch request with url
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; // set content-type
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // set accepting JSON
    request.HTTPMethod = @"POST"; // set method to POST
    request.HTTPBody = self.orderData; // set data to HTTPBody
    
    // log JSON 
    NSLog(@"%@", [[NSString alloc] initWithData:self.orderData encoding:NSUTF8StringEncoding]);
    NSLog(@"order data length: %d", [self.orderData length]);
    
    NSOperationQueue *queue = NSOperationQueue.currentQueue;
    
    // show network activity indicator
    ShowNetworkActivityIndicator();
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         NSUInteger responseCode = [Helpers readHttpStatusCodeFromResponse:response];
         NSLog(@"%d", responseCode);
         
         // check response code is OK (201)
         if (kHTTPRequestCreated == responseCode) {
             [self showAlertDone]; // can use with delegate = self.delegate
         } else if (504 == responseCode) {
             [self error504];
         } else if (nil != error && error.code == NSURLErrorTimedOut) {
             [self timeOut];
         } else if (nil != error) {
             [self uploadError:error];
         }
         
         // hide network activity indicator
         HideNetworkActivityIndicator();
     }];
}

// show Alert
- (void)showAlertDone {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" 
                                                        message:@"Your Order is reserved." 
                                                       delegate:nil // set self to crash, must be self.delegate or nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

- (void)error504 {
    
    NSLog(@"web service is dead!!!");
}

- (void)timeOut {
    
    NSLog(@"Time Out!!!");
}

- (void)uploadError:(NSError *)error {
    
    NSLog(@"startUpload Error: %@", error.localizedDescription);
}

@end
