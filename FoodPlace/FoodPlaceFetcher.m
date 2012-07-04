

#import "FoodPlaceFetcher.h"
#import "JSONE.h"

@implementation FoodPlaceFetcher

#pragma mark - Get Data from Web Service

+ (NSArray *)getFoods {
    
    // init request with url
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:kFoodPlaceFoodsURL];
    
    // get data from request
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response 
                                                             error:&error];
    // if error, show alert
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
    
    // return nil if error happen
    if (responseCode != kHTTPRequestOK || responseData.length == 0) {
        NSLog(@"Error!!!");
        return nil;
    }
    
    // get foods from JSON
    // id foods = responseData.fromJSON;
    NSLog(@"Getting foods...");
    NSLog(@"%d", responseData.length);
    return responseData ? (id)responseData.fromJSON : nil;
}

+ (NSArray *)getPlaces {
    
    // init request with url
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:kFoodPlacePlacesURL];
    
    // get data from request
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response 
                                                             error:&error];
    // if error, show alert
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
    
    // return nil if error happen
    if (responseCode != kHTTPRequestOK || responseData.length == 0) {
        NSLog(@"Error!!!");
        return nil;
    }
    
    // get places from JSON
    // id places = responseData.fromJSON;
    NSLog(@"Getting places...");    
    NSLog(@"%d", responseData.length);
    return responseData ? (id)responseData.fromJSON : nil;
}

#pragma mark - MKAnnotation Image

+ (NSString *)urlStringForPlace:(NSDictionary *)place {
    
    return [place objectForKey:PLACE_IMAGE_URL]; 
}

+ (NSURL *)urlForPlace:(NSDictionary *)place {
    
    // get url string of place
    NSString *urlString = [self urlStringForPlace:place];
    // NSURL *url = [NSURL URLWithString:urlString];
    return urlString ? [NSURL URLWithString:urlString] : nil;
}

@end
