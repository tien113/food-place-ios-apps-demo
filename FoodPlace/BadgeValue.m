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

// replace init with the fast way
- (id)initWithDocument:(UIManagedDocument *)document delegate:(id)delegate tabBarController:(UITabBarController *)controller {
    
    if (self = [super init]) {
        self.document = document;
        self.delegate = delegate;
        self.tabBarController = controller;
    }
    return self;
}

// check badge value nil
- (void)checkSetBadgeValue:(NSUInteger)count {
    
    if (0 == count)
        // [(self.tabBarController.tabBar.items)[3] setBadgeValue:nil]; // nil
        [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    else {
        NSString *countStr = [NSString stringWithFormat:@"%d", count];
        // [(self.tabBarController.tabBar.items)[3] setBadgeValue:countStr]; // number
        [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:countStr];
    }
}

// set badge value
- (void)startSetBadgeValue {
    
    [self checkSetBadgeValue:[self cartCount]];
    NSLog(@"%d", [self cartCount]);
}

- (NSUInteger)cartCount {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    
    NSError *error = nil;
    NSArray *carts = [self.document.managedObjectContext executeFetchRequest:request
                                                                       error:&error];
    __block NSUInteger cartCount = 0;
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        cartCount += [cart.count intValue];
    }];
    
    return cartCount;
}

@end
