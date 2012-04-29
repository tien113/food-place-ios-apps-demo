//
//  FoodPlaceFetcher.h
//  JSONCoreData2
//
//  Created by vo on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL_PLACE @"http://localhost:3000/places.json"
#define URL_FOOD @"http://localhost:3000/foods.json"

#define PLACE_ID @"id"
#define PLACE_NAME @"place_name"
#define PLACE_LAT @"place_lat"
#define PLACE_LOG @"place_log"
#define PLACE_IMAGE_URL @"place_image_url"

#define FOOD_NAME @"food_name"
#define FOOD_PRICE @"food_price"
#define FOOD_IMAGE_URL @"food_image_url"
#define FOOD_ID @"id"
#define PLACE @"place"

@interface FoodPlaceFetcher : NSObject

+ (NSArray *)getPlaces;
+ (NSArray *)getFoods;

@end
