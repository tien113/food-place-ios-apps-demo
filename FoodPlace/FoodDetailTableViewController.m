//
//  FoodDetailTableViewController.m
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodDetailTableViewController.h"
#import "FoodPlaceFetcher.h"
#import <QuartzCore/QuartzCore.h>

@interface FoodDetailTableViewController ()

@end

@implementation FoodDetailTableViewController

@synthesize foodImageView = _foodImageView;
@synthesize foodNameLabel = _foodNameLabel;
@synthesize placeNameLabel = _placeNameLabel;
@synthesize priceLabel = _priceLabel;
@synthesize foodIngredientTextView = _foodIngredientTextView;
@synthesize addToCartButton = _addToCartButton;

@synthesize food = _food;
@synthesize document = _document;

- (void)setFood:(Food *)food {
    
    if (_food != food) {
        _food = food;
  
        self.title = food.name;
    }
}

- (void)setDocument:(UIManagedDocument *)document {
    
    if (_document != document) {
        _document = document;
    }
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.foodNameLabel.text = [NSString stringWithFormat:@"%@", self.food.name];
    [self.foodNameLabel sizeToFit];
    self.placeNameLabel.text = [NSString stringWithFormat:@"%@", self.food.place.name];
    [self.placeNameLabel sizeToFit];
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@", EURO, [self.food.price stringValue]];
    self.foodIngredientTextView.text = [NSString stringWithFormat:@"%@", self.food.ingredient];
    self.foodImageView.image = self.food.image;
    
    NSLog(@"%@, %@, %@, %@", self.food.name, self.food.place.name, self.food.price, self.food.ingredient);
  
}

- (void)viewDidUnload {
    [self setDocument:nil];
    [self setFood:nil];
    [self setFoodImageView:nil];
    [self setFoodNameLabel:nil];
    [self setPlaceNameLabel:nil];
    [self setPriceLabel:nil];
    [self setFoodIngredientTextView:nil];
    [self setAddToCartButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Cart Action

- (void)addToCart:(UIManagedDocument *)document {
    
    dispatch_queue_t addQ = dispatch_queue_create("Add to Cart", NULL);
    dispatch_async(addQ, ^{
        [document.managedObjectContext performBlock:^{
            [Cart cartWithFood:self.food inManagedObjectContext:document.managedObjectContext];
            [document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        }];
    });
    dispatch_release(addQ);
}

#pragma mark - IBOutlet

- (IBAction)AddToCart:(id)sender {
    
    [self addToCart:self.document];
}


@end
