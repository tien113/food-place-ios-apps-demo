//
//  PrepareOrderData.m
//  FoodPlace
//
//  Created by vo on 9/2/12.
//
//

#import "PrepareOrderData.h"
#import "Cryptography.h"
#import "NSDateE.h"
#import "Define.h"
#import "Helpers.h"

@implementation PrepareOrderData

- (NSString *)orderUuid {
    
    return [MacAddress getMacAddress].toSHA1;
}

- (NSString *)orderDate {
    
    return [[NSDate date] toString];
}

- (NSString *)orderDone {
    
    return FALSE_VALUE;
}

- (NSString *)orderTotal:(float)totalOrder {
    
    return [NSString stringWithFormat:@"%.2f", totalOrder];
}

- (NSString *)foodName:(Cart *)cart {
    
    return cart.food.name;
}

- (NSString *)foodCount:(Cart *)cart {
    
    return [cart.count stringValue];
}

- (NSString *)foodPlace:(Cart *)cart {
    
    return cart.food.place.name;
}

- (NSString *)foodPrice:(Cart *)cart {
    
    return [NSString stringWithFormat:@"%0.2f", [Helpers timeNSDecimalNumber:cart.food.price andNumber:cart.count]];
}

@end
