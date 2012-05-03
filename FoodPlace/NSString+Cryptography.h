//
//  NSString+Cryptography.h
//  MacAddress
//
//  Created by vo on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Cryptography)

- (NSString *)toMD5;
- (NSString *)toSHA1;

@end
