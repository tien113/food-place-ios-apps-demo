//
//  Food+Create.m
//  FoodPlace
//
//  Created by vo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Food+Create.h"
#import "FoodPlaceFetcher.h"
#import "Place+Create.h"

@implementation Food (Create)

+ (Food *)foodWithWebService:(NSDictionary *)webService inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Food *food = nil;
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [webService objectForKey:FOOD_ID]];
    // sort with name
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[ sortDescriptor ];
    // request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error]; // fetch all foods from Core Data
    
    if (!matches || [matches count] > 1) {
        // error  
    } else if ([matches count] == 0) {
        // insert data to Core Data
        food = [NSEntityDescription insertNewObjectForEntityForName:@"Food" inManagedObjectContext:context];
        food.unique = webService[FOOD_ID];
        food.name = webService[FOOD_NAME];
        food.price = [NSDecimalNumber decimalNumberWithString:webService[FOOD_PRICE]];
        food.ingredient = webService[FOOD_INGREDIENT];
        food.image_url = webService[FOOD_IMAGE_URL];
        food.place = [Place placeWithWebService:webService[PLACE] inManagedObjectContext:context];
        
        /*
        food.unique = [webService objectForKey:FOOD_ID];
        food.name = [webService valueForKey:FOOD_NAME];
        food.price = [NSDecimalNumber decimalNumberWithString:[webService valueForKey:FOOD_PRICE]]; // convert string to decimal number
        food.ingredient = [webService valueForKey:FOOD_INGREDIENT];
        food.image_url = [webService valueForKey:FOOD_IMAGE_URL];
        food.place = [Place placeWithWebService:[webService objectForKey:PLACE] inManagedObjectContext:context];
        */
        
        NSLog(@"%@", food);
    } else {
        food = matches.lastObject;
    }
    return food;
}

@end
