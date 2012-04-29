//
//  FoodPlaceFetcher.m
//  JSONCoreData2
//
//  Created by vo on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodPlaceFetcher.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"

@implementation FoodPlaceFetcher

+ (NSArray *)getPlaces {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_PLACE]];
    [request startSynchronous];
    
    // reading HTTP status code
    int statusCode = [request responseStatusCode];
    NSString *statusMessage = [request responseStatusMessage];
    NSLog(@"%d, %@", statusCode, statusMessage);
    //
    
    NSError *error = [request error];
    if (!error) {
        NSString *responseString = [request responseString];
        // NSLog(@"%@", responseString);
        return [parser objectWithString:responseString error:nil];
    }
    return nil;
}

+ (NSArray *)getFoods {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_FOOD]];
    [request startSynchronous];
    
    // reading HTTP status code
    int statusCode = [request responseStatusCode];
    NSString *statusMessage = [request responseStatusMessage];
    NSLog(@"%d, %@", statusCode, statusMessage);
    //
    
    NSError *error = [request error];
    if (!error) {
        NSString *responseString = [request responseString];
        // NSLog(@"%@", responseString);
        return [parser objectWithString:responseString error:nil];
    }
    return nil;
}

@end
