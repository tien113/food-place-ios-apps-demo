//
//  Helpers.h
//  FoodPlace
//
//  Created by vo on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+ (float)timeNSDecimalNumber:(NSDecimalNumber *)numberA andNumber:(NSNumber *)numberB;
+ (NSUInteger)readHttpStatusCodeFromResponse:(NSURLResponse *)response;
+ (void)changeBackBarButton:(UINavigationItem *)navigationItem;

@end
