

#import "FoodPlaceFetcher.h"
#import "JSONE.h"

@implementation FoodPlaceFetcher

#pragma mark - Get Data from Web Service

+ (NSArray *)getFoods {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:kFoodPlaceFoodsURL];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response 
                                                             error:&error];
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"There was an error talking to Web Service. Please try again later." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
        });
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    
    // reading http status code
    int responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"%d", responseCode);
    
    if (responseCode != kHTTPRequestOK || [responseData length] == 0) {
        NSLog(@"Error!!!");
        return nil;
    }
    
    id foods = [responseData fromJSON];
    NSLog(@"Getting foods...");
    return foods;
}

+ (NSArray *)getPlaces {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:kFoodPlacePlacesURL];
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response 
                                                             error:&error];
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                            message:@"There was an error talking to Web Service. Please try again later." 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
        });
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    
    // reading http status code
    int responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"%d", responseCode);
    
    if (responseCode != kHTTPRequestOK || [responseData length] == 0) {
        NSLog(@"Error!!!");
        return nil;
    }
    
    id places = [responseData fromJSON];
    NSLog(@"Getting places...");
    return places;
}

#pragma mark - MKAnnotation Image

+ (NSString *)urlStringForPlace:(NSDictionary *)place {
    
    return [place objectForKey:PLACE_IMAGE_URL]; 
}

+ (NSURL *)urlForPlace:(NSDictionary *)place {
    
    NSString *urlString = [self urlStringForPlace:place];
    return [NSURL URLWithString:urlString];
}

@end
