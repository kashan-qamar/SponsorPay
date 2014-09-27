//
//  SPFormTableViewController.m
//  SponsorPay
//
//  Created by Kashan Qamar on 9/26/14.
//  Copyright (c) 2014 Skyline Dynamics. All rights reserved.
//

#import "SPFormTableViewController.h"
#import <CommonCrypto/CommonHMAC.h>
#import "SPOffersTableViewController.h"



NSString *const SPOffersIdentififier = @"SPOfferIdentifier";

@interface SPFormTableViewController ()

@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, retain) NSMutableArray *titleArray;
@property (nonatomic, retain) NSMutableArray *payoutArray;
@property (nonatomic, retain) NSMutableArray *thumbnailArray;
@property (nonatomic, retain) NSMutableArray *teaserArray;

@end

//For Magical Record

//@interface NSManagedObjectContext ()
//+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
//+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
//
//@end

@implementation SPFormTableViewController

// For core data
//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize responseData = _responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Fyber Offers Form";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
}

- (IBAction)getOffers:(id)sender{

    NSString *uid = self.uId.text;
    NSString *appId = self.appId.text;
    NSString *apiKey = self.apiKey.text;
    NSString *pub0 = self.pub0.text;
    NSString *locale = @"de";
    NSString *ipAddress = @"109.235.143.113";
    NSString *timeStamp = [self GetCurrentTimeStamp];
    NSString *osVersion = @"6.0";
    NSString *baseURL = @"http://api.sponsorpay.com/feed/v1/offers.json?";
    
    
    NSString *hashString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",@"appid=",appId,@"&ip=",ipAddress,@"&locale=",locale,
                            @"&os_version=",osVersion,@"&timestamp=",timeStamp,@"&uid=",uid];
    NSString *sha1Str = [self sha1:[NSString stringWithFormat:@"%@%@%@",hashString,@"&",apiKey]];
    NSString *hashKey = [NSString stringWithFormat:@"%@%@%@",hashString,@"&hashkey=",sha1Str];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL,hashKey];
    
    NSLog(@"URL = %@", url);
    
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
   
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    NSArray *results = [res objectForKey:@"offers"];
    
    self.titleArray = [[NSMutableArray alloc] initWithCapacity:results.count];
    self.teaserArray = [[NSMutableArray alloc] initWithCapacity:results.count];
    self.thumbnailArray = [[NSMutableArray alloc] initWithCapacity:results.count];
    self.payoutArray = [[NSMutableArray alloc] initWithCapacity:results.count];
    
    for (NSDictionary *result in results) {
        [self.titleArray addObject:[result objectForKey:@"title"]];
        [self.teaserArray addObject:[result objectForKey:@"teaser"]];
        [self.thumbnailArray addObject:[result objectForKey:@"thumbnail"]];
        [self.payoutArray addObject:[result objectForKey:@"payout"]];
        

    }
    
    if([self.titleArray count] == 0){
            
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offers"
                                                       message:@"No Offers Found!"
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SPOffersTableViewController *offersController = [storyboard instantiateViewControllerWithIdentifier:@"SPOfferIdentifier"];
    offersController.titleArray = self.titleArray;
    offersController.teaserArray = self.teaserArray;
    offersController.payoutArray = self.payoutArray;
    offersController.thumbnailArray = self.thumbnailArray;
    
    [self.navigationController pushViewController:offersController animated:YES];
    }
    
}


- (NSString *)GetCurrentTimeStamp
{
    int unixtime = [[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] integerValue];
    return [[NSNumber numberWithInt:unixtime] stringValue];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)prepareRestKitMapping{

    //    NSError *error = nil;
    //    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SponsorPay" ofType:@"momd"]];
    //    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    //    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    //    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    //
    //    // Initialize the Core Data stack
    //    [managedObjectStore createPersistentStoreCoordinator];
    //
    //    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    //    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    //
    //    [managedObjectStore createManagedObjectContexts];
    //
    //    // Set the default store shared instance
    //    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    //
    //
    //    // Configure the object manager
    //    //    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:8080"]];
    //    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:url]];
    //    objectManager.managedObjectStore = managedObjectStore;
    //
    //    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"Authorization" value:@" Bearer 7e857069ac4fb19bcf1e4aeb58d6bd2e"];
    //    [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON];
    //    [objectManager setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
    //    [RKObjectManager setSharedManager:objectManager];
    //
    //
    //    RKEntityMapping *userInfoMapping = [RKEntityMapping mappingForEntityForName:@"FyberOffers" inManagedObjectStore:managedObjectStore];
    //    [userInfoMapping addAttributeMappingsFromDictionary:@{
    //                                                          @"payout":         @"payout",
    //                                                          @"teaser":           @"teaser",
    //                                                          @"title":         @"title"
    //                                                          }];
    //
    //
    //
    //    RKResponseDescriptor *responseDescriptor =
    //    [RKResponseDescriptor responseDescriptorWithMapping:userInfoMapping
    //                                                 method:RKRequestMethodAny
    //                                            pathPattern:url keyPath:@"offers"
    //                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    //
    //    // Configure MagicalRecord to use RestKit's Core Data stack
    //    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    //    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    //    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    //
    //    [objectManager addResponseDescriptor:responseDescriptor];
    //
    //
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    SPOffersTableViewController *offersController = [storyboard instantiateViewControllerWithIdentifier:@"SPOfferIdentifier"];
    //     offersController.url = url;
    //    [self.navigationController pushViewController:offersController animated:YES];


}

@end
