//
//  PlaceAnnotation.m
//  FoodPlace
//
//  Created by vo on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotationView.h"
#import "FoodPlaceFetcher.h"

@implementation PlaceAnnotationView

@synthesize place = _place;

+ (PlaceAnnotationView *)annotationForPlace:(NSDictionary *)place {
    
    PlaceAnnotationView *annotation = [[PlaceAnnotationView alloc] init];
    annotation.place = place;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title {
    
    return [self.place objectForKey:PLACE_NAME];
}

- (NSString *)subtitle {
    
    return [self.place valueForKeyPath:PLACE_ADDRESS];
}

- (CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:PLACE_LAT] doubleValue];
    coordinate.longitude = [[self.place objectForKey:PLACE_LOG] doubleValue];
    return coordinate;
}

@end
