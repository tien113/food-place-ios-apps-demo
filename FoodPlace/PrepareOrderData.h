//
//  PrepareOrderData.h
//  FoodPlace
//
//  Created by vo on 9/2/12.
//
//

#import <Foundation/Foundation.h>
#import "Cart.h"
#import "Food.h"
#import "Place.h"

@interface PrepareOrderData : NSObject

@property (nonatomic, assign) NSString *orderUuid;
@property (nonatomic, assign) NSString *orderDate;
@property (nonatomic, assign) NSString *orderDone;

- (NSString *)orderTotal:(float)totalOrder;

- (NSString *)foodPlace:(Cart *)cart;
- (NSString *)foodCount:(Cart *)cart;
- (NSString *)foodName:(Cart *)cart;
- (NSString *)foodPrice:(Cart *)cart;

@end
