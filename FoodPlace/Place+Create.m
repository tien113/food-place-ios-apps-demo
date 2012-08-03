//
//  Place+Create.m
//  FoodPlace
//
//  Created by vo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place+Create.h"
#import "FoodPlaceFetcher.h"
#import "Define.h"

@implementation Place (Create)

+ (Place *)placeWithWebService:(NSDictionary *)webService inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Place *place = nil;
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", webService[PLACE_NAME]];
    // sort with name
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[ sortDescriptor ];
    // request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *places = [context executeFetchRequest:request error:&error]; // fetch all places from Core Data
    
    if (!places || [places count] > 1) {
        // error
    } else if (![places count]) {
        // insert data to Core Data
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = webService[PLACE_NAME];
        place.lat = [NSDecimalNumber decimalNumberWithString:webService[PLACE_LAT]];
        place.log = [NSDecimalNumber decimalNumberWithString:webService[PLACE_LOG]];
        place.address = webService[PLACE_ADDRESS];
        place.opening_time_1 = webService[PLACE_OPENING_TIME_1];
        place.opening_time_2 = webService[PLACE_OPENING_TIME_2];
        place.opening_time_3 = webService[PLACE_OPENING_TIME_3];
        place.opening_time_4 = webService[PLACE_OPENING_TIME_4];
        place.phone_number = webService[PLACE_PHONE_NUMBER];
        place.email = webService[PLACE_EMAIL];
        place.image_url = webService[PLACE_IMAGE_URL];
        
        // [webService objectForKey:PLACE_NAME];
        // place.lat = [NSDecimalNumber decimalNumberWithString:[webService valueForKey:PLACE_LAT]]; // convert string to decimal number
        // place.log = [NSDecimalNumber decimalNumberWithString:[webService valueForKey:PLACE_LOG]]; // convert string to decimal number
        // place.address = [webService valueForKey:PLACE_ADDRESS];
        // place.opening_time_1 = [webService valueForKey:PLACE_OPENING_TIME_1];
        // place.opening_time_2 = [webService valueForKey:PLACE_OPENING_TIME_2];
        // place.opening_time_3 = [webService valueForKey:PLACE_OPENING_TIME_3];
        // place.opening_time_4 = [webService valueForKey:PLACE_OPENING_TIME_4];
        // place.phone_number = [webService valueForKey:PLACE_PHONE_NUMBER];
        // place.email = [webService valueForKey:PLACE_EMAIL];
        // place.image_url = [webService valueForKey:PLACE_IMAGE_URL];
        
        NSLog(@"%@", place);
    } else {
        place = places.lastObject;
    }
    return place;
}

@end
