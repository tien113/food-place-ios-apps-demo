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
#import "CartCell.h"
#import "FoodPlaceFetcher.h"
#import "Helpers.h"

@interface CartTableViewController ()

@property (nonatomic, strong) UILabel *cartLabel;

@end

@implementation CartTableViewController

@synthesize cartLabel = _cartLabel;
@synthesize document = _document;
@synthesize checkOutBarButtonItem = _checkOutBarButtonItem;
@synthesize totalOrderLabel = _totalOrderLabel;

#pragma mark - Badge Value

// check badge value nil
- (void)checkBadgeValue:(int)count {
    
    if (count == 0) 
        [[[self tabBarController].tabBar.items objectAtIndex:3] setBadgeValue:nil]; // nil
    else 
        [[[self tabBarController].tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%d", count]]; // number
}

// set badge value
- (void)setBadgeValue {
    
    // fetch request with entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    
    NSError *error = nil;
    NSArray *carts = [self.document.managedObjectContext executeFetchRequest:request 
                                                                       error:&error];
    __block int count = 0;
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        count += [cart.count intValue];
    }];
    [self checkBadgeValue:count];
    NSLog(@"%d", count);
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

#define _TOTAL_ @"Total = %@%0.2f"

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

#pragma mark - Check Bar Button Item

// check checkout bar button item
- (void)showCheckOutBarButtonItem {
    
    // check totalOrder is zero or not
    if ([self totalOrder] == 0) 
        self.checkOutBarButtonItem.enabled = FALSE; // set disable
    else 
        self.checkOutBarButtonItem.enabled = TRUE; // set enable
    
}

// show checkout bar button item when it adds
- (void)showCheckOutBarButtonItemWhenAdd {
    self.checkOutBarButtonItem.enabled = TRUE; // set enable
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
    self.document = [FoodPlaceAppDelegate sharedDocument];
    
    // outlet
    [self showCartLabel];
    [self showCheckOutBarButtonItem];
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
    [self setCheckOutBarButtonItem:nil];
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
    [self showCheckOutBarButtonItemWhenAdd];
    
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
            [self showCheckOutBarButtonItem];
            
            // badge value
            [self setBadgeValue];
        }];
    });
    dispatch_release(removeQ);
}

#pragma mark - Cart Action

- (void)showAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" 
                                                        message:@"Your Order is reserved." 
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark - IBOutlet

- (IBAction)CheckOut:(id)sender {
    
    [self showAlert];
}

@end
