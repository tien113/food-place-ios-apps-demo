//
//  Cart+Food.m
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cart+Food.h"
#import "Define.h"

@implementation Cart (Food)

// add food to cart
+ (Cart *)cartWithFood:(Food *)food inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Cart *cart = nil;
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", food.unique];
    // sort with name
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"unique"
                                                                     ascending:YES];
    request.sortDescriptors = @[ sortDescriptor ];
    
    NSError *error = nil;
    NSArray *carts = [context executeFetchRequest:request
                                            error:&error]; // fetch all carts from Core Data
    
    if (!carts || 1 == carts.count) {
        cart = carts.lastObject; // get cart from carts
        NSUInteger cartCount = [[cart valueForKey:CART_COUNT] intValue];
        // check if cart count = 5, show alert
        if (5 == cartCount)
            [self showAlert]; // show alert
        else
            cart.count = [self plus1:cartCount]; // count + 1
        
        NSLog(@"%@", cart);
    } else if (0 == cart.count) {
        // insert data to Core Data
        cart            = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
        cart.food       = food;
        cart.count      = @1;
        cart.unique     = food.unique;
        cart.created_at = NSDate.date;
        
        NSLog(@"%@", cart);
    } else {
        cart = carts.lastObject;
    }
    return cart;
}

+ (void)removeFromCart:(Cart *)cart inManagedObjectContext:(NSManagedObjectContext *)context {
    
    [context deleteObject:cart]; // delete object
}

+ (void)showAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Max order is 5, Don't make monkey business, please !!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

+ (NSNumber *)plus1:(NSUInteger)number {
    
    // plus int and int number (block way)
    int (^plus)(int, int) = ^(int numA, int numB) {
        return numA + numB;
    };
    
    return @( plus(1,number) );
}

@end
