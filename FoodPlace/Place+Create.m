//
//  Place+Create.m
//  FoodPlace
//
//  Created by vo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place+Create.h"
#import "FoodPlaceFetcher.h"

@implementation Place (Create)

+ (Place *)placeWithWebService:(NSDictionary *)webService inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [webService objectForKey:PLACE_NAME]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    
    if (!places || [places count] > 1) {
        // error
    } else if (![places count]) {
        
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = [webService objectForKey:PLACE_NAME];
        place.lat = [webService valueForKey:PLACE_LAT];
        place.log = [webService valueForKey:PLACE_LOG];
        place.address = [webService valueForKey:PLACE_ADDRESS];
        place.opening_time_1 = [webService valueForKey:PLACE_OPENING_TIME_1];
        place.opening_time_2 = [webService valueForKey:PLACE_OPENING_TIME_2];
        place.opening_time_3 = [webService valueForKey:PLACE_OPENING_TIME_3];
        place.opening_time_4 = [webService valueForKey:PLACE_OPENING_TIME_4];
        place.phone_number = [webService valueForKey:PLACE_PHONE_NUMBER];
        place.email = [webService valueForKey:PLACE_EMAIL];
        place.image_url = [webService valueForKey:PLACE_IMAGE_URL];
        
        NSLog(@"%@", place);
        
    } else {
        place = [places lastObject];
    }
    return place;
}

@end
