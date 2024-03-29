//
//  BadgeValue.h
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BadgeValueDelegate <NSObject>

@end

@interface BadgeValue : NSObject

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, weak) id <BadgeValueDelegate> delegate;

- (void)startSetBadgeValue;
- (id)initWithDocument:(UIManagedDocument *)document delegate:(id)delegate tabBarController:(UITabBarController *)tabBarController;

@end
