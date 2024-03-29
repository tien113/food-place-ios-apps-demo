//
//  FoodDetailTableViewController.m
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FoodDetailTableViewController.h"
#import "Place+Create.h"
#import "Cart+Food.h"
#import "Food+Create.h"
#import <QuartzCore/QuartzCore.h>
#import "Helpers.h"
#import "Define.h"
#import "NSNumberE.h"
#import "BadgeValue.h"

@interface FoodDetailTableViewController () <BadgeValueDelegate>

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

#pragma mark - Badge Value

- (void)badgeValueUpdate {
    
    BadgeValue *badgeValue = [[BadgeValue alloc] initWithDocument:self.document
                                                         delegate:self
                                                 tabBarController:self.tabBarController];
    [badgeValue startSetBadgeValue];
}

#pragma mark - Initialize Data

// set title = food name
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

// load data to outlet
- (void)loadData {
    
    self.foodNameLabel.text = self.food.name;
    [self.foodNameLabel sizeToFit];
    self.placeNameLabel.text = self.food.place.name;
    [self.placeNameLabel sizeToFit];
    self.priceLabel.text = self.food.price.currencyFormatter;
    self.foodIngredientTextView.text = self.food.ingredient;
    self.foodImageView.image = self.food.image;
    [self.addToCartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
    
    NSLog(@"%@, %@, %@, %@", self.food.name, self.food.place.name, self.food.price, self.food.ingredient);
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // load data
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Cart Action

// add food to Cart
- (void)addToCart:(UIManagedDocument *)document {
    
    // create queue for Add to Cart
    dispatch_queue_t addQ = dispatch_queue_create("Add to Cart", NULL);
    dispatch_async(addQ, ^{
        [document.managedObjectContext performBlock:^{
            [Cart cartWithFood:self.food inManagedObjectContext:document.managedObjectContext]; // add food to Cart
            [document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL]; // save to document
            
            // badge value
            [self badgeValueUpdate];
        }];
    });
    dispatch_release(addQ);
}

#pragma mark - Action

- (IBAction)AddToCart:(id)sender {
    
    [self addToCart:self.document];
}

@end
