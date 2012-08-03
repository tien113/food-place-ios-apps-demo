

#import <Foundation/Foundation.h>

@interface FoodPlaceFetcher : NSObject

+ (NSArray *)getPlaces;
+ (NSArray *)getFoods;

+ (NSString *)urlStringForPlace:(NSDictionary *)place;
+ (NSURL *)urlForPlace:(NSDictionary *)place;

@end
