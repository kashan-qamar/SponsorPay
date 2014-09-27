//
//  FyberOffers.h
//  SponsorPay
//
//  Created by Kashan Qamar on 9/27/14.
//  Copyright (c) 2014 Skyline Dynamics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FyberOffers : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * teaser;
@property (nonatomic, retain) NSNumber * payout;

@end
