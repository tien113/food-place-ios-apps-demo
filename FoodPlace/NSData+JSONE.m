//
//  NSData+JSONE.m
//  FoodPlace
//
//  Created by vo on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+JSONE.h"

@implementation NSData (JSONE)

- (NSDictionary *)fromJSON {
    
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self 
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error != nil) return nil;
    return result;
}

@end
