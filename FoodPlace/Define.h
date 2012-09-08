//
//  Define.h
//  FoodPlace
//
//  Created by vo on 8/3/12.
//
//

// Host URL
#define kHostURL @"http://91.156.195.133:3000"

// JSON URL
#define kPlacesJSON  @"places.json"
#define kFoodsJSON   @"foods.json"
#define kOrdersJSON  @"orders.json"

// Food Place Web Service
#define kFoodPlacePlacesURL [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHostURL, kPlacesJSON]]
#define kFoodPlaceFoodsURL  [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHostURL, kFoodsJSON]]
#define kFoodPlaceOrdersURL [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kHostURL, kOrdersJSON]]

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

// http status code
#define kHTTPRequestOK          200
#define kHTTPRequestCreated     201
#define kHTTPRequestUpdated     204

// Order Web Service
#define ORDER                      @"order"
#define ORDER_UUID                 @"order_uuid"
#define ORDER_TOTAL                @"order_total"
#define ORDER_DATE                 @"order_date"
#define ORDER_DONE                 @"order_done"
#define ORDER_DETAILS_ATTRIBUTES   @"order_details_attributes"

#define FOOD_NAME    @"food_name"
#define FOOD_COUNT   @"food_count"
#define FOOD_PRICE   @"food_price"
#define FOOD_PLACE   @"food_place"

// network activity indicator
#define ShowNetworkActivityIndicator() UIApplication.sharedApplication.networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() UIApplication.sharedApplication.networkActivityIndicatorVisible = NO

// spinner view
#define showSpinnerView() self.spinner = [SpinnerView loadSpinnerIntoView:self.tabBarController.view]
#define hideSpinnerView() [self.spinner removeSpinner]

// map view controller
#define LATITUDE            63.097458
#define LONGITUDE           21.61903

#define LATITUDE_DELTA      0.0175
#define LONGITUDE_DELTA     0.0175

#define MY_PIN              @"MyPin"
#define MY_PIN_IMAGE        @"map-pin.png"

// Cart+Food.h
#define CART_COUNT          @"count"

// prepareOrder
#define FALSE_VALUE         @"0"




