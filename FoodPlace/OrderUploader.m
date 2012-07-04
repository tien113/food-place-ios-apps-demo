//
//  OrderUploader.m
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrderUploader.h"
#import "FoodPlaceFetcher.h"

@implementation OrderUploader

@synthesize orderData = _orderData;
@synthesize delegate = _delegate;

- (void)startUpload {
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kFoodPlaceOrdersURL]; // fetch request with url
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; // set content-type
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // set accepting JSON
    request.HTTPMethod = @"POST"; // set method to POST
    request.HTTPBody = self.orderData; // set data to JSON
    
    // log JSON 
    NSLog(@"%@", [[NSString alloc] initWithData:self.orderData encoding:NSUTF8StringEncoding]);
    NSOperationQueue *queue = NSOperationQueue.currentQueue;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) 
     {
         int responseCode = [self readHttpStatusCodeFromResponse:response];
         NSLog(@"%d", responseCode);
         
         // check response code is OK (201)
         if (responseCode == kHTTPRequestCreated) {
             [self showAlertDone];
         } else if (error != nil && error.code == NSURLErrorTimedOut) {
             [self timeOut];
         } else if (error != nil) {
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
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

- (void)timeOut {
    
    NSLog(@"Time Out!!!");
}

- (void)uploadError:(NSError *)error {
    
    NSLog(@"%@", error.localizedDescription);
}

@end
