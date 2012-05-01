//
//  Cart+Food.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cart.h"
#import "Food.h"

@interface Cart (Food)

+ (Cart *)cartWithFood:(Food *)food inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeFromCart:(Cart *)cart inManagedObjectContext:(NSManagedObjectContext *)context;

@end
