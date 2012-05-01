//
//  Helpers.h
//  FoodPlace
//
//  Created by vo on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@interface Helpers : NSObject

+ (float)timeNSDecimalNumber:(NSDecimalNumber *)numberA andNumber:(NSNumber *)numberB;

@end
