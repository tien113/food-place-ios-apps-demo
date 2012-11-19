//
//  PlaceAnnotation.m
//  FoodPlace
//
//  Created by vo on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotationView.h"
#import "FoodPlaceFetcher.h"
#import "Define.h"

@implementation PlaceAnnotationView

@synthesize place = _place;

+ (PlaceAnnotationView *)annotationForPlace:(NSDictionary *)place {
    
    PlaceAnnotationView *annotation = [[PlaceAnnotationView alloc] init];
    annotation.place = place;
    return annotation;
}

#pragma mark - MKAnnotation

// title of MKAnnotation
- (NSString *)title {

    return _place[PLACE_NAME];
}

// subtitle of MKAnnotation
- (NSString *)subtitle {

    return _place[PLACE_ADDRESS];
}

// coordinate of MKAnnotation
- (CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_place[PLACE_LAT] doubleValue];
    coordinate.longitude = [_place[PLACE_LOG] doubleValue];
    return coordinate;
}

@end
