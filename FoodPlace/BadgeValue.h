//
//  BadgeValue.h
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef unsigned int cartInt; // convert to short type name cartInt

@protocol BadgeValueDelegate

@end

@interface BadgeValue : NSObject

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) id <BadgeValueDelegate> delegate;

- (void)startSetBadgeValue;

@end
