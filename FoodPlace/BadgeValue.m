//
//  BadgeValue.m
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadgeValue.h"
#import "CoreDataTableViewController.h"
#import "Cart+Food.h"

@implementation BadgeValue

@synthesize document = _document;
@synthesize delegate = _delegate;
@synthesize tabBarController = _tabBarController;

// check badge value nil
- (void)checkSetBadgeValue:(unsigned int)cartCount {
    
    if (cartCount == 0)
        [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil]; // nil
    else 
        [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%d", cartCount]]; // number
}

// set badge value
- (void)startSetBadgeValue {
    
    unsigned cartCount = [self cartCount];
    
    [self checkSetBadgeValue:cartCount];
    NSLog(@"%d", cartCount);
}

- (unsigned int)cartCount {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    
    NSError *error = nil;
    NSArray *carts = [self.document.managedObjectContext executeFetchRequest:request
                                                                       error:&error];
    __block int cartCount = 0;
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        cartCount += [cart.count intValue];
    }];
    
    return cartCount;
}

@end
