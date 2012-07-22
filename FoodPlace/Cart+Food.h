//
//  Cart+Food.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cart.h"
#import "Food.h"

#define CART_COUNT @"count"

typedef unsigned int cartInt; // convert to short type name cartInt

@interface Cart (Food)

+ (Cart *)cartWithFood:(Food *)food inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeFromCart:(Cart *)cart inManagedObjectContext:(NSManagedObjectContext *)context;

@end
