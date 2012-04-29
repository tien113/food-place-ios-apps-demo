//
//  Place.h
//  FoodPlace
//
//  Created by vo on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSDecimalNumber * lat;
@property (nonatomic, retain) NSDecimalNumber * log;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * opening_time_1;
@property (nonatomic, retain) NSString * opening_time_2;
@property (nonatomic, retain) NSString * opening_time_3;
@property (nonatomic, retain) NSString * opening_time_4;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSSet *foods;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addFoodsObject:(Food *)value;
- (void)removeFoodsObject:(Food *)value;
- (void)addFoods:(NSSet *)values;
- (void)removeFoods:(NSSet *)values;

@end
