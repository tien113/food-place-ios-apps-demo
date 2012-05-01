//
//  Place+Create.h
//  FoodPlace
//
//  Created by vo on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+ (Place *)placeWithWebService:(NSDictionary *)webService inManagedObjectContext:(NSManagedObjectContext *)context;

@end
