//
//  Cart.h
//  FoodPlace
//
//  Created by vo on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface Cart : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) Food *food;

@end
