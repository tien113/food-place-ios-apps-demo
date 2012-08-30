//
//  OrderUploader.h
//  FoodPlace
//
//  Created by vo on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderUploaderDelegate

@end

@interface OrderUploader : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *orderData;
@property (nonatomic, strong) id <OrderUploaderDelegate> delegate;

- (void)startUpload;
- (id)initWithURL:(NSURL *)url delegate:(id)delegate orderData:(NSData *)data;

@end
