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

#pragma mark - Calculate Total Order

- (float)totalOrder {
    
    __block float total = 0.0f;
    
    NSArray *carts = [self.fetchedResultsController fetchedObjects];
    [carts enumerateObjectsUsingBlock:^(Cart *cart, NSUInteger idx, BOOL *stop) {
        total += [Helpers timeNSDecimalNumber:cart.food.price andNumber:cart.count];  
    }];
    
    return total;
}

#pragma mark - Check Total Order Label

- (void)setTotalOrderLabel:(UILabel *)totalOrderLabel {
    
    if (_totalOrderLabel != totalOrderLabel) {
        _totalOrderLabel = totalOrderLabel;
        _totalOrderLabel.frame = CGRectMake(-20.0f, 0.0f, 0.0f, 30.0f);
    }
}

- (void)showTotalOrderLabelWhenRemove {
    
    if ([self totalOrder] != 0) {
        self.totalOrderLabel.text = [NSString stringWithFormat:@"Total = %@%0.2f", EURO, [self totalOrder]];
    } else {
        self.totalOrderLabel.hidden = YES;
    }
}

- (void)showTotalOrderLabelWhenAdd {
    
    if ([self totalOrder] != 0) {
        self.totalOrderLabel.hidden = NO;
        self.totalOrderLabel.text = [NSString stringWithFormat:@"Total = %@%0.2f", EURO, [self totalOrder]];
    }
}

#pragma mark - Check Bar Button Item

- (void)showCheckOutBarButtonItem {
    
    if ([self totalOrder] == 0) {
        self.checkOutBarButtonItem.enabled = FALSE;
    } else {
        self.checkOutBarButtonItem.enabled = TRUE;
    }
}

- (void)showCheckOutBarButtonItemWhenAdd {
    self.checkOutBarButtonItem.enabled = TRUE;
}

#pragma mark - Check Cart Label

- (void)showCartLabel {
    
    self.cartLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 30.0f)];
    [self.cartLabel setText:@"Nothing in Cart. Please, Order !!!"];
    [self.cartLabel setTextColor:[UIColor blackColor]];
    [self.cartLabel setTextAlignment:UITextAlignmentCenter];
    if ([self totalOrder] == 0) {
        [self.tableView addSubview:self.cartLabel];
    } else {
        [self hiddenCartLabel];
    }
}

- (void)hiddenCartLabel {
    [self.cartLabel removeFromSuperview];
}

#pragma mark - Initialize Data

- (void)setupFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                        managedObjectContext:self.document.managedObjectContext 
                                                                          sectionNameKeyPath:nil 
                                                                                   cacheName:nil];
}

- (void)useDocument {
    
    if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
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

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Cart";
    
    self.document = [FoodPlaceAppDelegate sharedDocument];
    [self showCartLabel];
    [self showCheckOutBarButtonItem];
}

- (void)viewDidUnload
{
    [self setCartLabel:nil];
    [self setDocument:nil];
    [self setTotalOrderLabel:nil];
    [self setCheckOutBarButtonItem:nil];
    [super viewDidUnload];
}

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
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cart Cell"];
    
    Cart *cart = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.foodNameLabel.text = [NSString stringWithFormat:@"%@", cart.food.name];
    cell.countLabel.text = [NSString stringWithFormat:@"x%@", [cart.count stringValue]];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%0.2f", EURO, [Helpers timeNSDecimalNumber:cart.food.price andNumber:cart.count]];
    
    // IBOutlet
    [self hiddenCartLabel];
    [self showTotalOrderLabelWhenAdd];
    [self showCheckOutBarButtonItemWhenAdd];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self removeFromCart:self.document atIndexPath:indexPath];
        NSLog(@"Delete row !!!");
    }
}

#pragma mark - Cart Action

- (void)removeFromCart:(UIManagedDocument *)document atIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_queue_t removeQ = dispatch_queue_create("Remove from Cart", NULL);
    dispatch_async(removeQ, ^{
        Cart *cart = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [document.managedObjectContext performBlock:^{
            [Cart removeFromCart:cart inManagedObjectContext:document.managedObjectContext];
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            
            // IBOutlet
            [self showTotalOrderLabelWhenRemove];
            [self showCartLabel];
            [self showCheckOutBarButtonItem];
        }];
    });
    dispatch_release(removeQ);
}

#pragma mark - Cart Action

- (void)showAlert {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" 
                                                        message:@"Your Order is reserved" 
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
