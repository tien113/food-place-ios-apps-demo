//
//  OrderUploader.m
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderUploader.h"
#import "Define.h"

@implementation OrderUploader

@synthesize url = _url;
@synthesize orderData = _orderData;
@synthesize delegate = _delegate;

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
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         int responseCode = [self readHttpStatusCodeFromResponse:response];
         NSLog(@"%d", responseCode);
         
         // check response code is OK (201)
         if (kHTTPRequestCreated == responseCode) {
             [self showAlertDone]; // can use with delegate = self.delegate
         } else if (504 == responseCode) {
             [self error504];
         } else if (nil != error && NSURLErrorTimedOut == error.code) {
             [self timeOut];
         } else if (nil != error) {
             [self uploadError:error];
         }
     }];
}

- (int)readHttpStatusCodeFromResponse:(NSURLResponse *)response {
    
    int responseCode = 0;
    // check response is NSHTTPURLResponse class
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        // get status code
        responseCode = [(NSHTTPURLResponse *)response statusCode];
    }
    return responseCode;
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
