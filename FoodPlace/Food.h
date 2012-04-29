//
//  Food.h
//  FoodPlace
//
//  Created by vo on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cart, Place;

@interface Food : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSString * ingredient;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) Cart *cart;
@property (nonatomic, retain) Place *place;

@end
