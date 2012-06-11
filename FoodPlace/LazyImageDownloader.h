//
//  ImageDownloader2.h
//  FoodPlace
//
//  Created by vo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food+Create.h"

@protocol LazyImageDownloaderDelegate

- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end

@interface LazyImageDownloader : NSObject

@property (nonatomic, strong) Food *food;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, strong) id <LazyImageDownloaderDelegate> delegate;

- (void)startDownload;

@end
