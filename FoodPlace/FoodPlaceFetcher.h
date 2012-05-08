

#import <Foundation/Foundation.h>

// Food Place Web Service
#define kFoodPlacePlacesURL [NSURL URLWithString:@"http://91.156.195.133:3000/places.json"]
#define kFoodPlaceFoodsURL [NSURL URLWithString:@"http://91.156.195.133:3000/foods.json"]

// Core Data
#define PLACE_ID                @"id"
#define PLACE_NAME              @"place_name"
#define PLACE_LAT               @"place_lat"
#define PLACE_LOG               @"place_log"
#define PLACE_ADDRESS           @"place_address"
#define PLACE_OPENING_TIME_1    @"place_opening_time_1"
#define PLACE_OPENING_TIME_2    @"place_opening_time_2"
#define PLACE_OPENING_TIME_3    @"place_opening_time_3"
#define PLACE_OPENING_TIME_4    @"place_opening_time_4"
#define PLACE_IMAGE_URL         @"place_image_url"
#define PLACE_PHONE_NUMBER      @"place_phone_number"
#define PLACE_EMAIL             @"place_email"

#define FOOD_NAME           @"food_name"
#define FOOD_PRICE          @"food_price"
#define FOOD_INGREDIENT     @"food_ingredient"
#define FOOD_IMAGE_URL      @"food_image_url"
#define FOOD_ID             @"id"
#define PLACE               @"place"

// EURO Symbol and Total order format
#define EURO @"€"
#define _TOTAL_ @"Total = %@%0.2f"

// http status code
#define kHTTPRequestOK 200
#define kHTTPRequestCreated 201
#define kHTTPRequestUpdated 204

// Order Web Service
#define kFoodPlaceOrdersURL [NSURL URLWithString:@"http://91.156.195.133:3000/orders.json"]

#define ORDER                    @"order"
#define ORDER_UUID               @"order_uuid"
#define ORDER_TOTAL              @"order_total"
#define ORDER_DATE               @"order_date"
#define ORDER_DONE               @"order_done"
#define ORDER_DETAILS_ATTRIBUTES @"order_details_attributes"

#define FOOD_NAME  @"food_name"
#define FOOD_COUNT @"food_count"
#define FOOD_PRICE @"food_price"
#define FOOD_PLACE @"food_place"

@interface FoodPlaceFetcher : NSObject

+ (NSArray *)getPlaces;
+ (NSArray *)getFoods;

+ (NSString *)urlStringForPlace:(NSDictionary *)place;
+ (NSURL *)urlForPlace:(NSDictionary *)place;

@end
