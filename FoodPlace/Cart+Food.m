//
//  Cart+Food.m
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cart+Food.h"

@implementation Cart (Food)

+ (Cart *)cartWithFood:(Food *)food inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Cart *cart = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", food.unique];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *carts = [context executeFetchRequest:request error:&error];
    
    if (!carts || [carts count] == 1) {
        
        cart = [carts lastObject];
        int cartCount = [[cart valueForKey:@"count"] intValue];
        if (cartCount == 5) {
            
            cart.count = [NSNumber numberWithInt:5];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                message:@"Max order is 5, Don't make monkey business, please !!!" 
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            });
                       
        } else {
            cart.count = [NSNumber numberWithInt:(1 + cartCount)];
        }
        NSLog(@"%@", cart);
        
    } else if ([carts count] == 0) { 
        
        cart = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
        cart.food = food;
        cart.count = [NSNumber numberWithInt:1];
        cart.unique = food.unique;
        cart.created_at = [NSDate date];
        
        NSLog(@"%@", cart);
        
    } else {
        
        cart = [carts lastObject];
        
    }
    
    return cart;   
}

+ (void)removeFromCart:(Cart *)cart inManagedObjectContext:(NSManagedObjectContext *)context {
    
    [context deleteObject:cart];
}

@end
