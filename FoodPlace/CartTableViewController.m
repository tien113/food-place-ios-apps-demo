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
#import "CartCell.h"
#import "FoodPlaceFetcher.h"
#import "Helpers.h"
#import "Cryptography.h"
#import "NSDateE.h"
#import "JSONE.h"

@interface CartTableViewController ()

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
    
    BadgeValue *badgeValue = [[BadgeValue alloc] init];
    badgeValue.document = self.document;
    badgeValue.tabBarController = self.tabBarController;
    badgeValue.delegate = self;
    [badgeValue startSetBadgeValue];
}

#pragma mark - Calculate Total Order

// calculate total order
- (float)totalOrder {
    
    __block float total = 0.0f;
    
    // fetch data from Core Data to NSArray
    NSArray *carts = [self.fetchedResultsController fetchedObjects]; 
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        total += [Helpers timeNSDecimalNumber:cart.food.price andNumber:cart.count]; // calculate total  
    }];
    
    return total;
}

#pragma mark - Check Total Order Label

// set position total order label 
- (void)setTotalOrderLabel:(UILabel *)totalOrderLabel {
    
    if (_totalOrderLabel != totalOrderLabel) {
        _totalOrderLabel = totalOrderLabel;
        _totalOrderLabel.frame = CGRectMake(-20.0f, 0.0f, 0.0f, 30.0f); // set frame's position
    }
}

// check total order label when it removes
- (void)showTotalOrderLabelWhenRemove {
    
    // check totalOrder is zero or not
    if ([self totalOrder] != 0) 
        self.totalOrderLabel.text = [NSString stringWithFormat:_TOTAL_, EURO, [self totalOrder]];
    else 
        self.totalOrderLabel.hidden = YES; // set hidden total order label 
    
}

// show total order label when it adds
- (void)showTotalOrderLabelWhenAdd {
    
    // check totalOrder is zero or not
    if ([self totalOrder] != 0) {
        self.totalOrderLabel.hidden = NO; // set hidden total order label
        self.totalOrderLabel.text = [NSString stringWithFormat:_TOTAL_, EURO, [self totalOrder]];
    }
}

#pragma mark - Place Order Bar Button Item

// check Place Order bar button item
- (void)showPlaceOrderBarButtonItem {
    
    // check totalOrder is zero or not
    if ([self totalOrder] == 0) 
        self.placeOrderBarButtonItem.enabled = FALSE; // set disable
    else 
        self.placeOrderBarButtonItem.enabled = TRUE; // set enable
    
}

// show Place Order bar button item when it adds
- (void)showPlaceOrderBarButtonItemWhenAdd {
    self.placeOrderBarButtonItem.enabled = TRUE; // set enable
}

#pragma mark - Empty Cart Bar Button Item

// check Empty Cart bar button item
- (void)showEmptyCartBarButtonItem {
    
    if ([self totalOrder] == 0) 
        self.emptyCartBarButtonItem.enabled = FALSE;
    else 
        self.emptyCartBarButtonItem.enabled = TRUE;
}

// show Empty Cart bar button item when it adds
- (void)showEmptyCartBarButtonItemWhenAdd {
    self.emptyCartBarButtonItem.enabled = TRUE;
}

#pragma mark - Check Cart Label

- (void)setCartLabel:(UILabel *)cartLabel {
    
    if (_cartLabel != cartLabel) {
        _cartLabel = cartLabel;
    }
}

// check Cart Label
- (void)showCartLabel {
    
    // init cart label with frame
    self.cartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 30.0f)];
    self.cartLabel.text = @"Nothing in Cart. Please, Order !!!";
    self.cartLabel.textColor = [UIColor blackColor];
    self.cartLabel.textAlignment = UITextAlignmentCenter;
    
    // check totalOrder is zero or not
    if ([self totalOrder] == 0) 
        [self.tableView addSubview:self.cartLabel]; // add cart label to tableView
    else 
        [self hiddenCartLabel];
    
}

- (void)hiddenCartLabel {
    
    // remove cart label from tableView
    [self.cartLabel removeFromSuperview]; 
}

#pragma mark - Initialize Data

// setup fetched result controller
- (void)setupFetchedResultsController {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created_at" 
                                                                                     ascending:YES]];
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
    [self showPlaceOrderBarButtonItem];
    [self showEmptyCartBarButtonItem];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // CartCell
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cart Cell"];
    
    Cart *cart = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.foodNameLabel.text = [NSString stringWithFormat:@"%@", cart.food.name];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@", [cart.count stringValue]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%0.2f", EURO, [Helpers timeNSDecimalNumber:cart.food.price 
                                                                                           andNumber:cart.count]];
    
    // outlet
    [self hiddenCartLabel];
    [self showTotalOrderLabelWhenAdd];
    [self showPlaceOrderBarButtonItemWhenAdd];
    [self showEmptyCartBarButtonItemWhenAdd];
    
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
            [self showTotalOrderLabelWhenRemove];
            [self showCartLabel];
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
        NSArray *carts = [self.fetchedResultsController fetchedObjects];
        [document.managedObjectContext performBlock:^{
            [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
                [Cart removeFromCart:cart inManagedObjectContext:document.managedObjectContext];
            }];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
            // outlet
            [self showCartLabel];
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
    
    [self showConfirmation];
}

// Empty Cart action
- (IBAction)EmptyCart:(id)sender {
    
    [self emptyCart:self.document];
}

- (void)showConfirmation {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
                                                        message:@"Do you really wanna do it?" 
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert show];
    });
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
        NSArray *carts = [self.fetchedResultsController fetchedObjects]; // fetch all carts
        [self performSelectorOnMainThread:@selector(prepareOrder:) withObject:carts waitUntilDone:YES];
    });
    dispatch_release(sendQ);
}

- (void)prepareOrder:(NSArray *)carts {
    
    NSString *orderUuid = [MacAddress getMacAddress].toSHA1; // get UUID 
    NSString *orderTotal = [NSString stringWithFormat:@"%.2f", [self totalOrder]];
    NSString *orderDate = [[NSDate date] toString];
    NSString *orderDone = @"0"; // set order to FALSE
    
    __block NSMutableArray *orderDetailParents = [NSMutableArray array]; // init array
    __block NSMutableArray *keyOrderDetailParents = [NSMutableArray array];

    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        NSString *foodName = cart.food.name;
        NSString *foodCount = [cart.count stringValue];
        NSString *foodPrice = [NSString stringWithFormat:@"%0.2f", [Helpers timeNSDecimalNumber:cart.food.price andNumber:cart.count]];
        NSString *foodPlace = cart.food.place.name;
        
        NSArray *foodObjects = [NSArray arrayWithObjects:foodName, foodCount, foodPrice, foodPlace, nil];
        NSArray *foodKeys = [NSArray arrayWithObjects:FOOD_NAME, FOOD_COUNT, FOOD_PRICE, FOOD_PLACE, nil];
        
        NSDictionary *orderDetailChild = [[NSDictionary alloc] initWithObjects:foodObjects forKeys:foodKeys];
        
        [orderDetailParents addObject:orderDetailChild]; // add order detail child to orderdetailparents
        [keyOrderDetailParents addObject:[NSString stringWithFormat:@"%d", idx]]; // add key orderdetailparent
    }];
    
    // alloc order detail parent
    NSDictionary *orderDetailParent = [[NSDictionary alloc] initWithObjects:orderDetailParents forKeys:keyOrderDetailParents]; 
    
    NSArray *orderObjects = [NSArray arrayWithObjects:orderUuid, orderTotal, orderDate, orderDone, orderDetailParent, nil];
    NSArray *orderKeys = [NSArray arrayWithObjects:ORDER_UUID, ORDER_TOTAL, ORDER_DATE, ORDER_DONE, ORDER_DETAILS_ATTRIBUTES, nil];
    
    NSDictionary *orderChild = [[NSDictionary alloc] initWithObjects:orderObjects forKeys:orderKeys];
    
    NSDictionary *orderParent = [[NSDictionary alloc] initWithObjectsAndKeys: orderChild, ORDER, nil];
    
    NSData *orderData = orderParent.toJSON; // convert nsdictionary to nsdata
    
    [self startOrderUpload:orderData];
    
}

// uploader delegate

- (void)startOrderUpload:(NSData *)data {
    
    OrderUploader *orderUploader = [[OrderUploader alloc] init];
    orderUploader.orderData = data;
    orderUploader.delegate = self;
    [orderUploader startUpload];
}

@end
