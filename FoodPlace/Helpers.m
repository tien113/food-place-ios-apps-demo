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
  
    float fNumberA = [numberA floatValue]; // convert NSDecimalNumber to float
    int fNumberB = [numberB intValue]; // convert NSNumber to int
        
    // time int and fload number (block way)
    float (^add)(float, int) = ^(float numA, int numB) {
        return numA * numB;
    };

    return add(fNumberA, fNumberB);
}

@end
