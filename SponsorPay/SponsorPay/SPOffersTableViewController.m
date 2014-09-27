//
//  SPOffersTableViewController.m
//  SponsorPay
//
//  Created by Kashan Qamar on 9/27/14.
//  Copyright (c) 2014 Skyline Dynamics. All rights reserved.
//

#import "SPOffersTableViewController.h"
#import "RKHTTPRequestOperation+Curl.h"
#import "SPOfferTableViewCell.h"

@interface SPOffersTableViewController ()

@end

@implementation SPOffersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Fyber Offers";
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return [self.titleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPOfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMain"];
    cell.titlesLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    cell.payoutLabel.text = [[self.payoutArray objectAtIndex:indexPath.row] stringValue];
    cell.teaserLabel.text = [self.teaserArray objectAtIndex:indexPath.row];
    
    return cell;
}



@end
