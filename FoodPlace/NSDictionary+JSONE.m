//
//  NSDictionary+JSONE.m
//  FoodPlace
//
//  Created by vo on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+JSONE.h"

@implementation NSDictionary (JSONE)

// convert Data to JSON
- (NSData *)toJSON {
    
    NSError *error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions
                                                  error:&error];
    if (nil != error) {
        NSLog(@"JSONE Error: %@", error.localizedDescription);
        return nil;
    }
    
    NSLog(@"JSONE toJSON: %@", result);
    return result;
}

@end
