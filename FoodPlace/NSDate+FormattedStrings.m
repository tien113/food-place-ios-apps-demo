//
//  NSDate+FormattedStrings.m
//  ASIHTTPRequest
//
//  Created by vo on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+FormattedStrings.h"

@implementation NSDate (FormattedStrings)

// convert NSDate to NSString (yyyy-MM-dd'T'hh:mm:ss'Z')
- (NSString *)toString {
    
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:dateFormat];
    
    NSString *result = [dateFormatter stringFromDate:self];
    
    return result;
}

// convert NSDate to NSString with different style
- (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:style];
    
    NSString *result = [dateFormatter stringFromDate:self];
    
    return result;
}

@end
