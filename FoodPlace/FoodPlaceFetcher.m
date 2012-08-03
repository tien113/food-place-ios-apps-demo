

#import "FoodPlaceFetcher.h"
#import "JSONE.h"
#import "UIAlertViewE.h"
#import "Define.h"

@implementation FoodPlaceFetcher

#pragma mark - Get Data from Web Service

+ (NSArray *)getFoods {
    
    // init request with url
    NSURLRequest *request = [NSURLRequest requestWithURL:kFoodPlaceFoodsURL];
    
    // get data from request
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response 
                                                             error:&error];
    // if error, show alert
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView showWithError:error];
        });
        NSLog(@"getFoods' Error: %@", error.localizedDescription);
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
    NSURLRequest *request = [NSURLRequest requestWithURL:kFoodPlacePlacesURL];
    
    // get data from request
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request 
                                                 returningResponse:&response 
                                                             error:&error];
    // if error, show alert
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertView showWithError:error];
        });
        NSLog(@"getPlaces' Error: %@", error.localizedDescription);
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
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kHostURL, place[PLACE_IMAGE_URL]];
    
    return urlStr;
}

+ (NSURL *)urlForPlace:(NSDictionary *)place {
    
    // get url string of place
    NSString *urlStr = [self urlStringForPlace:place];
    // NSURL *url = [NSURL URLWithString:urlString];
    return urlStr ? [NSURL URLWithString:urlStr] : nil;
}

@end
