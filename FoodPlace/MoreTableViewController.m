//
//  MoreTableViewController.m
//  FoodPlace
//
//  Created by vo on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreTableViewController.h"
#import "Helpers.h"

@interface MoreTableViewController () 

@end

@implementation MoreTableViewController

// load data
- (void)loadData {
    
    self.title = @"More";
    [Helpers changeBackBarButton:self.navigationItem];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([@"About Me" isEqualToString:segue.identifier]) {
    }
    if ([@"Email" isEqualToString:segue.identifier]) {
        // check mail account setup or not
        if ([MFMailComposeViewController canSendMail]) {
            [self displayEmailView];
        }
    }
    if ([@"Website" isEqualToString:segue.identifier]) {
    }
    if ([@"Identification" isEqualToString:segue.identifier]) {
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

// display email view
- (void)displayEmailView
{
    // init MFMailComposeViewController
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    [mailController setToRecipients: @[ @"tien113@gmail.com" ]]; // set recipient to tien113@gmail.com
    // [mailController setToRecipients:[NSArray arrayWithObjects:@"tien113@gmail.com", nil]]; 
    [mailController setSubject:@"Feedback"]; // set subject to Feedback
    [mailController setMessageBody:@"" isHTML:NO];
    
    // show mail view
    [self presentModalViewController:mailController animated:YES];
}

// log everything of mail
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // remove the mail view
    [self dismissModalViewControllerAnimated:YES];
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
    [super viewDidUnload];
}

// set rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
