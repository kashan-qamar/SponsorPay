//
//  SPOfferTableViewCell.h
//  SponsorPay
//
//  Created by Kashan Qamar on 9/27/14.
//  Copyright (c) 2014 Skyline Dynamics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPOfferTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *payoutLabel;
@property (nonatomic, weak) IBOutlet UILabel *titlesLabel;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *teaserLabel;



@end
