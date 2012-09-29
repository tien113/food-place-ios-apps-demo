//
//  LocationDetailTableViewController.m
//  FoodPlace
//
//  Created by vo on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationDetailTableViewController.h"
#import "Place+Create.h"

@interface LocationDetailTableViewController ()

@end

@implementation LocationDetailTableViewController

@synthesize placeNameLabel = _placeNameLabel;
@synthesize placeAddressLabel = _placeAddressLabel;
@synthesize phoneNumberTextView = _phoneNumberTextView;
@synthesize openingTime1Label = _openingTime1Label;
@synthesize openingTime2Label = _openingTime2Label;
@synthesize openingTime3Label = _openingTime3Label;
@synthesize openingTime4Label = _openingTime4Label;
@synthesize emailLabel = _emailLabel;

@synthesize place = _place;

// set title = place name
- (void)setPlace:(Place *)place {
    
    if (_place != place) {
        _place = place;
        
        self.title = place.name;
    }
}

// load data to outlet
- (void)loadData {
    
    self.placeNameLabel.text = self.place.name;
    self.placeAddressLabel.text = self.place.address;
    [self.placeAddressLabel sizeToFit];
    self.phoneNumberTextView.text = self.place.phone_number;
    self.emailLabel.text = self.place.email;
    self.openingTime1Label.text = self.place.opening_time_1;    
    self.openingTime2Label.text = self.place.opening_time_2;    
    self.openingTime3Label.text = self.place.opening_time_3;
    self.openingTime4Label.text = self.place.opening_time_4;
    
    NSLog(@"%@, %@, %@, %@, %@", self.place.name, self.place.address, self.place.opening_time_1, self.place.phone_number, self.place.email);
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
    [self setPlaceNameLabel:nil];
    [self setPlaceAddressLabel:nil];
    [self setEmailLabel:nil];
    [self setPhoneNumberTextView:nil];
    [self setOpeningTime1Label:nil];
    [self setOpeningTime2Label:nil];
    [self setOpeningTime3Label:nil];
    [self setOpeningTime4Label:nil];
    [self setPlace:nil];
    [super viewDidUnload];

}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
