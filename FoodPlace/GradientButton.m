//
//  FoodCell.h
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GradientButton.h"

@interface GradientButton ()

- (void)initLayers;
- (void)initBorder;
- (void)addShineLayer;
- (void)addHighlightLayer;

@end

@implementation GradientButton

@synthesize shineLayer = _shineLayer;
@synthesize highlightLayer = _highlightLayer;

#pragma mark - Initialization

- (void)awakeFromNib {
    [self initLayers];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayers];
    }
    return self;
}

// init layers
- (void)initLayers {
    [self initBorder];
    [self addShineLayer];
    [self addHighlightLayer];
}

// init border
- (void)initBorder {
    CALayer *layer = self.layer;
    layer.cornerRadius = 8.0f;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.2f].CGColor;   
}

// add shine layer
- (void)addShineLayer {
    self.shineLayer = [CAGradientLayer layer];
    self.shineLayer.frame = self.layer.bounds;
    self.shineLayer.colors = @[
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor
                         ];
    self.shineLayer.locations = @[
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f]
                            ];
    [self.layer addSublayer:self.shineLayer];
}

#pragma mark - Highlight button while touched

- (void)addHighlightLayer {
    self.highlightLayer = [CALayer layer];
    self.highlightLayer.backgroundColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:0.75f].CGColor;
    self.highlightLayer.frame = self.layer.bounds;
    self.highlightLayer.hidden = YES;
    [self.layer insertSublayer:self.highlightLayer below:self.shineLayer];
}

- (void)setHighlighted:(BOOL)highlight {
    self.highlightLayer.hidden = !highlight;
    [super setHighlighted:highlight];
}

@end
