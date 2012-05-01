//
//  PlaceAnnotation.h
//  FoodPlace
//
//  Created by vo on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotationView : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *place;

+ (PlaceAnnotationView *)annotationForPlace:(NSDictionary *)place;

@end
