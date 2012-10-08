//
//  CartTableViewController.m
//  FoodPlace
//
//  Created by vo on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartTableViewController.h"
#import "FoodPlaceAppDelegate.h"
#import "Cart+Food.h"
#import "Place+Create.h"
#import "Food+Create.h"
#import "CartCell.h"
#import "Helpers.h"
#import "JSONE.h"
#import "Define.h"
#import "Cryptography.h"
#import "NSDateE.h"
#import "NSNumberE.h"
#import "OrderUploader.h"
#import "BadgeValue.h"

@interface CartTableViewController () <OrderUploaderDelegate, BadgeValueDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UILabel *cartLabel;

@end

@implementation CartTableViewController

@synthesize cartLabel = _cartLabel;
@synthesize document = _document;
@synthesize placeOrderBarButtonItem = _placeOrderBarButtonItem;
@synthesize emptyCartBarButtonItem = _emptyCartBarButtonItem;
@synthesize totalOrderLabel = _totalOrderLabel;

#pragma mark - Badge Value

- (void)badgeValueUpdate {
    
    BadgeValue *badgeValue = [[BadgeValue alloc] initWithDocument:self.document
                                                         delegate:self
                                                 tabBarController:self.tabBarController];
    [badgeValue startSetBadgeValue];
}

#pragma mark - Calculate Total Order

// calculate total order
- (float)totalOrder {
    
    __block float total = 0.0f;
    
    // fetch data from Core Data to NSArray
    NSArray *carts = [self fetchedCarts];
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        total += [Helpers timeNSDecimalNumber:cart.food.price
                                    andNumber:cart.count]; // calculate total
    }];
    
    return total;
}

#pragma mark - Check Total Order Label

// set position total order label 
- (void)setTotalOrderLabel:(UILabel *)totalOrderLabel {
    
    if (_totalOrderLabel != totalOrderLabel) {
        _totalOrderLabel = totalOrderLabel;
        _totalOrderLabel.frame = CGRectMake(-16.0f, 0.0f, 0.0f, 30.0f); // set frame's position
    }
}

// check total order label when it removes
- (void)showTotalOrderLabel {
    
    // check totalOrder is zero or not
    if (0 == [self totalOrder])
        self.totalOrderLabel.enabled = NO; // set disable total order label
    else {
        self.totalOrderLabel.enabled = YES; // set enable total order label
        self.totalOrderLabel.text = [NSString stringWithFormat:@"Total = %@", @( [self totalOrder] ).currencyFormatter];
    }
}

#pragma mark - Place Order Bar Button Item

// check Place Order bar button item
- (void)showPlaceOrderBarButtonItem {
    
    // check totalOrder is zero or not
    if (0 == [self totalOrder])
        self.placeOrderBarButtonItem.enabled = NO; // set disable
    else 
        self.placeOrderBarButtonItem.enabled = YES; // set enable
    
}

#pragma mark - Empty Cart Bar Button Item

// check Empty Cart bar button item
- (void)showEmptyCartBarButtonItem {
    
    if (0 == [self totalOrder])
        self.emptyCartBarButtonItem.enabled = NO; // set disable
    else 
        self.emptyCartBarButtonItem.enabled = YES; // set enable
}

#pragma mark - Check Cart Label

- (void)setCartLabel:(UILabel *)cartLabel {
    
    if (_cartLabel != cartLabel) {
        _cartLabel = cartLabel;
    }
}

- (UILabel *)cartLabel {
    
    if (!_cartLabel) {
        _cartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 30.0f)];
        _cartLabel.text = @"Your Shopping Cart is empty ...";
        _cartLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        _cartLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return _cartLabel;
}

// check Cart Label
- (void)showCartLabel {
    
    // check totalOrder is zero or not
    if (0 == [self totalOrder])
        [self.tableView addSubview:self.cartLabel]; // add cart label to tableView
    else
        [self.cartLabel removeFromSuperview]; // remove cart label from tableView
}

#pragma mark - Initialize Data

// setup fetched result controller
- (void)setupFetchedResultsController {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"created_at"
                                                               ascending:YES] ];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

// use document
- (void)useDocument {
    
    // if document state is closed, open and using it
    if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
        // if document state is normal, use it
    } else if (self.document.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setDocument:(UIManagedDocument *)document {
    
    if (_document != document) {
        _document = document;
        [self useDocument];
    }
}

- (void)loadData {
    
    self.title = @"Cart";
    
    // load document
    self.document = FoodPlaceAppDelegate.sharedDocument;
    
    // outlet
    [self showCartLabel];
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load data
    [self loadData];
}

- (void)viewDidUnload
{
    [self setCartLabel:nil];
    [self setDocument:nil];
    [self setTotalOrderLabel:nil];
    [self setPlaceOrderBarButtonItem:nil];
    [self setEmptyCartBarButtonItem:nil];
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
#pragma mark - Table view delegate

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 Cart *cart = [self.fetchedResultsController objectAtIndexPath:indexPath];
 UIFont *myFont = [UIFont systemFontOfSize:14.0f];
 CGSize constraint = CGSizeMake(200.0f, 42.0);
 CGSize size = [cart.food.name sizeWithFont:myFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
 CGFloat height = size.height + 16.0f;
 
 NSLog(@"%0.2f", height);
 NSLog(@"%@", NSStringFromCGSize(size));
 
 return height;
 }
 */

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // CartCell
    CartCell *cell = [sender dequeueReusableCellWithIdentifier:@"Cart Cell"];
    
    Cart *cart = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.foodNameLabel.text = cart.food.name;
    cell.countLabel.text = [NSString stringWithFormat:@"x%@", cart.count.noFormatter];
    cell.priceLabel.text = @( [Helpers timeNSDecimalNumber:cart.food.price
                                                 andNumber:cart.count] ).currencyFormatter;
    
    // outlet
    [self showCartLabel];
    [self showTotalOrderLabel];
    [self showPlaceOrderBarButtonItem];
    [self showEmptyCartBarButtonItem];
    
    return cell;
}

// edit tableView
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // editing style
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFromCart:self.document atIndexPath:indexPath]; // remove food from cart at indexPath
        NSLog(@"Delete row !!!");
    }
}

#pragma mark - Cart Action

// remove from cart
- (void)removeFromCart:(UIManagedDocument *)document atIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_queue_t removeQ = dispatch_queue_create("Remove from Cart", NULL);
    dispatch_async(removeQ, ^{
        Cart *cart = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [document.managedObjectContext performBlock:^{
            [Cart removeFromCart:cart inManagedObjectContext:document.managedObjectContext];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
            // outlet
            [self showCartLabel];
            [self showTotalOrderLabel];
            [self showPlaceOrderBarButtonItem];
            [self showEmptyCartBarButtonItem];
            
            // badge value
            [self badgeValueUpdate];
        }];
    });
    dispatch_release(removeQ);
}

// empty cart
- (void)emptyCart:(UIManagedDocument *)document {
    
    dispatch_queue_t emptyQ = dispatch_queue_create("Empty Cart", NULL);
    dispatch_async(emptyQ, ^{
        NSArray *carts = [self fetchedCarts];
        [document.managedObjectContext performBlock:^{
            [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
                [Cart removeFromCart:cart inManagedObjectContext:document.managedObjectContext];
            }];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
            // outlet
            [self showCartLabel];
            [self showTotalOrderLabel];
            [self showPlaceOrderBarButtonItem];
            [self showEmptyCartBarButtonItem];
            
            // badge value
            [self badgeValueUpdate];
        }];
    });
    dispatch_release(emptyQ);
}

#pragma mark - outlet

// Place Order action
- (IBAction)PlaceOrder:(id)sender {
    
    [self showAlertConfirmation];
}

// Empty Cart action
- (IBAction)EmptyCart:(id)sender {

    [self showActionSheetConfirmation];
}

- (void)showActionSheetConfirmation {
        
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirmation"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Do it!", nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    });
}

- (void)showAlertConfirmation {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
                                                        message:@"Do you really wanna do it?" 
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert show];
    });
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    switch (buttonIndex) {
        case 0:
            [self emptyCart:self.document];
            NSLog(@"Do it! was selected.");
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([@"YES" isEqualToString:title]) {
        [self sendOrder];
        NSLog(@"YES was selected.");
    }
    if ([@"NO" isEqualToString:title]) {
        NSLog(@"NO was selected.");
    }
}

#pragma mark - Place Order Action

- (void)sendOrder {
    
    dispatch_queue_t sendQ = dispatch_queue_create("Send Order", NULL);
    dispatch_async(sendQ, ^{       
        NSArray *carts = [self fetchedCarts];
        [self performSelectorOnMainThread:@selector(prepareOrder:)
                               withObject:carts
                            waitUntilDone:YES];
    });
    dispatch_release(sendQ);
}

- (void)prepareOrder:(NSArray *)carts {

    __block NSMutableDictionary *orderDetailsAttributes = [NSMutableDictionary dictionary];
    
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        
        NSString *foodName  = cart.food.name;
        NSString *foodCount = cart.count.noFormatter;
        NSString *foodPrice = @( [Helpers timeNSDecimalNumber:cart.food.price
                                                    andNumber:cart.count] ).stringValue; // can not use NSNumberFormatter because of conflict with the web service.
        NSString *foodPlace = cart.food.place.name;

        orderDetailsAttributes[@( idx ).noFormatter] = @{ FOOD_NAME  : foodName,
                                                          FOOD_COUNT : foodCount,
                                                          FOOD_PRICE : foodPrice,
                                                          FOOD_PLACE : foodPlace };
    }];
    
    NSString *orderUuid  = [MacAddress getMacAddress].toSHA1; // get UUID
    NSString *orderTotal = @( [self totalOrder] ).stringValue; // can not use NSNumberFormatter because of conflict with the web service.
    NSString *orderDate  = [[NSDate date] toString];
    //NSString *orderDate  = @"";
    NSString *orderDone  = FALSE_VALUE; // set order to FALSE
  
    NSDictionary *orderDict = @{ ORDER_UUID               : orderUuid,
                                 ORDER_TOTAL              : orderTotal,
                                 ORDER_DATE               : orderDate,
                                 ORDER_DONE               : orderDone,
                                 ORDER_DETAILS_ATTRIBUTES : orderDetailsAttributes };
    
    NSData *orderData = orderDict.toJSON; // convert nsdictionary to nsdata
    
    [self startOrderUpload:kFoodPlaceOrdersURL
                  withData:orderData];
    
}

// uploader delegate
- (void)startOrderUpload:(NSURL *)url withData:(NSData *)data {
    
    if (nil != data) {
        OrderUploader *orderUploader = [[OrderUploader alloc] initWithURL:url
                                                                 delegate:self
                                                                orderData:data];
        [orderUploader startUpload];
    }
}

// return nsarray carts
- (NSArray *)fetchedCarts {
  
    return [self.fetchedResultsController fetchedObjects]; // fetch all carts
}

@end
