//
//  SPFormTableViewController.h
//  SponsorPay
//
//  Created by Kashan Qamar on 9/26/14.
//  Copyright (c) 2014 Skyline Dynamics. All rights reserved.
//


@interface SPFormTableViewController : UITableViewController

@property(nonatomic, retain) IBOutlet UIButton *offerButton;

- (IBAction)getOffers:(id)sender;

@property (nonatomic, assign) IBOutlet UITextField *uId;
@property (nonatomic, assign) IBOutlet UITextField *appId;
@property (nonatomic, assign) IBOutlet UITextField *apiKey;
@property (nonatomic, assign) IBOutlet UITextField *pub0;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@end
