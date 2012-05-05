//
//  NSDate+FormattedStrings.h
//  ASIHTTPRequest
//
//  Created by vo on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FormattedStrings)

- (NSString *)toString;
- (NSString *)dateStringWithStyle:(NSDateFormatterStyle)style;

@end
