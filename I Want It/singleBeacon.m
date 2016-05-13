//
//  singleBeacon.m
//  I Want It
//
//  Created by macmini01 on 13/05/16.
//  Copyright © 2016 Great Innovus Solutions. All rights reserved.
//

#import "singleBeacon.h"

@implementation singleBeacon
static singleBeacon *sharedAwardCenter = nil;    // static instance variable

+ (singleBeacon *)sharedCenter {
    if (sharedAwardCenter == nil) {
        sharedAwardCenter = [[super allocWithZone:NULL] init];
    }
    return sharedAwardCenter;
}

- (id)init {
    if ( (self = [super init]) ) {
        _beaconTimer = [NSTimer    scheduledTimerWithTimeInterval:IDLETIMER target:self selector:@selector(beconInitialization) userInfo:nil repeats:NO];
    }
    return self;
}



-(void)beconInitialization{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    APIservice = [[CommonWebServices alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LocationManagerAction)
                                                 name:@"LocationNotification"
                                               object:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isBeaconView];
    [self LocationManagerAction];
}

- (void)LocationManagerAction{
    
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"App Permission Denied" message:@"To re-enable, Please go to Settings and turn on Location Service for this app."preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
                if (canOpenSettings)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil];
            [alertController addAction:actionOk];
            [alertController addAction:actionCancel];
            [self.mainView presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self restartMonitoring];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning !"
                                                                                 message:@"This feature is Currently Unavailable- Turn ON Location Services?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
            if (canOpenSettings)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        [alertController addAction:actionOk];
        [alertController addAction:actionCancel];
        [self.mainView presentViewController:alertController animated:YES completion:nil];
    }
}


-(void)restartMonitoring{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [_beaconTimer invalidate];
    _beaconTimer = nil;
    
    for (RWTItem *obj in delegate.beaconArray) {
        [self startMonitoringItem:obj];
    }
}

-(void)forcetoStopMonitoring{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [_beaconTimer invalidate];
     _beaconTimer = nil;
    [self.locationManager stopUpdatingLocation];
    for (RWTItem *obj in delegate.beaconArray) {
        [self stopMonitoringItem:obj];
    }
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    for (CLBeacon *beacon in beacons) {
        for (RWTItem *item in delegate.beaconArray) {
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
                if (item.lastSeenBeacon.proximity == 1 || item.lastSeenBeacon.proximity == 2){
                    beconUID = [NSString stringWithFormat:@"%@", item.uuid.UUIDString];
                    [self forcetoStopMonitoring];
                    NSDictionary *dict = @{@"title":@"Welcome",@"summary":@"An Associate is on the way to assist you.",@"image":@"store.jpg"};
                    if(!self.visibleCardView) {
                        [self showSummaryCard:dict];
                    }
                    break;
                }else{
                    [UIView animateWithDuration:0.35 animations:^{
                        self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
                    } completion:^(BOOL finished) {
                        [summaryCardView removeFromSuperview];
                        self.visibleCardView = nil;
                    }];
                }
            }
        }
    }
}


- (void)showSummaryCard:(NSDictionary *)infoDict{
    if (!summaryCardView) {
        summaryCardView = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCardView"
                                                         owner:self
                                                       options:nil] firstObject];
        summaryCardView.backgroundColor = [UIColor clearColor];
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window){
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [[[window subviews] objectAtIndex:0] addSubview:summaryCardView];
    
    summaryCardView.frame = [[UIScreen mainScreen]bounds];
    summaryCardView.layer.masksToBounds = YES;
    summaryCardView.delegate = self;
    summaryCardView.titleLabel.text = [infoDict objectForKey:@"title"];
    summaryCardView.summaryView.text = [infoDict objectForKey:@"summary"];
    [summaryCardView.okButton setTitle:@"OK" forState:UIControlStateNormal];
    summaryCardView.imageView.image = [UIImage imageNamed:[infoDict objectForKey:@"image"]];
    
    self.visibleCardView = summaryCardView;
    [UIView animateWithDuration:0.35 animations:^{
        summaryCardView.frame = [[UIScreen mainScreen]bounds];
    } completion:^(BOOL finished) {
    }];
}

#pragma Mark - Okay Button Action
- (void)summaryButtonClickedAtIndex:(int)index
{
    
    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [summaryCardView removeFromSuperview];
                self.visibleCardView = nil;
            }];
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"]) {
                _beaconTimer = [NSTimer    scheduledTimerWithTimeInterval:IDLETIMER target:self selector:@selector(LocationManagerAction) userInfo:nil repeats:NO];
                [self userRegistrationAPI];
            }
        }
            break;
        default:
            break;
    }
}

#pragma Mark - API SERVICE
-(void)userRegistrationAPI{
    /*
     URL - http://<<server name>>:<<port number>>/json/process/execute/NotifyCustomerArrival
     BODY - {
     "loyaltyId": "<<LOYALTY ID OF THE CUSTOMER >>",
     "uuid": "<<BEACON UUID>>"
     }
     */
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:USERDETAIL];
    
    NSDictionary *data = @{@"loyaltyId":[userDetail valueForKey:@"loyaltyId"], @"uuid": beconUID};
    [APIservice createNotificationCustomerArrivalWithCompletionBlock:^(NSDictionary *resultDic) {
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Login Return Data: %@",resultDic);
            }
        }
    } failureBlock:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    } dataDict:data];
}




- (void)customMethod {
    // implement your custom code here
}

@end


