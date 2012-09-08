//
//  Helpers.m
//  FoodPlace
//
//  Created by vo on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+ (float)timeNSDecimalNumber:(NSDecimalNumber *)numberA andNumber:(NSNumber *)numberB {
  
    float _numberA = [numberA floatValue]; // convert NSDecimalNumber to float
    int   _numberB = [numberB intValue]; // convert NSNumber to int
        
    // time int and fload number (block way)
    float (^add)(float, int) = ^(float numA, int numB) {
        return numA * numB;
    };
    
    return add(_numberA, _numberB);
}

+ (NSUInteger)readHttpStatusCodeFromResponse:(NSURLResponse *)response {
    
    NSUInteger responseCode = 0;
    // check response is NSHTTPURLResponse class
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        // get status code
        responseCode = [(NSHTTPURLResponse *)response statusCode];
    }
    return responseCode;
}

+ (void)changeBackBarButton:(UINavigationItem *)navigationItem {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    navigationItem.backBarButtonItem = backButton;
}

@end
