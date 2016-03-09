//
//  BeconObject.m
//  I Want It
//
//  Created by macmini01 on 09/03/16.
//  Copyright © 2016 Great Innovus Solutions. All rights reserved.
//

#import "BeconObject.h"

@implementation BeconObject

#define IDLETIMER 2

-(void)beconInitialization{
    self.items = [[NSMutableArray alloc]init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    // Configuration of Beacons
    
     /*// GIS Beacons
     NSArray *beaconArr = @[@{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",
                              @"name":@"mint",
                              @"major":@"57813",
                              @"minor":@"43675"},
                            @{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",
                              @"name":@"ice",
                              @"major":@"14743",
                              @"minor":@"60335"},
                            @{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                              @"name":@"blueberry",
                              @"major":@"40841",
                              @"minor":@"40841"}];
    */
    
    // OVC Beacons
    NSArray *beaconArr = @[@{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                             @"name":@"mint",
                             @"major":@"37058",
                             @"minor":@"3093"},
                           @{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                             @"name":@"ice",
                             @"major":@"34114",
                             @"minor":@"34114"},
                           @{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                             @"name":@"blueberry",
                             @"major":@"40841",
                             @"minor":@"40841"}];
    
    
    for (NSDictionary *dict in beaconArr) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"UUID"]];
        RWTItem *item = [[RWTItem alloc] initWithName:[dict objectForKey:@"name"]
                                                 uuid:uuid
                                                major:[[dict objectForKey:@"major"] intValue]
                                                minor:[[dict objectForKey:@"minor"] intValue]];
        [self.items addObject:item];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LocationManagerAction)
                                                 name:@"LocatinNotification"
                                               object:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isBeaconView];
    [self LocationManagerAction];
}

- (void)LocationManagerAction{
    NSLog (@"Successfully received the test notification!");
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Yes");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isBeaconEnabled];
        [self restartMonitoring];
    }else{
        NSLog(@"No");
        [UIView animateWithDuration:0.5 animations:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning !"
                                                                                     message:@"This feature is currently unavailable- turn on location services?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Settings"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
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
            [self.mainView.navigationController presentViewController:alertController animated:YES completion:nil];
        }completion:nil];
    }
}


-(void)restartMonitoring{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegate.beaconTimer invalidate];
    delegate.beaconTimer = nil;
    
    for (RWTItem *obj in self.items) {
        [self startMonitoringItem:obj];
    }
}

-(void)forcetoStopMonitoring{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [delegate.beaconTimer invalidate];
    delegate.beaconTimer = nil;
    [self.locationManager stopUpdatingLocation];
    NSLog(@"The switch is turned off.");
    for (RWTItem *obj in self.items) {
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
    for (CLBeacon *beacon in beacons) {
        for (RWTItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
                if (item.lastSeenBeacon.proximity == 1 || item.lastSeenBeacon.proximity == 2){
                    beconUID = [NSString stringWithFormat:@"%@", item.uuid.UUIDString];
                    [self forcetoStopMonitoring];
                    [self userRegistrationAPI];
                    NSDictionary *dict = @{@"title":@"Welcome to the “London - The Strand” Store",@"summary":@"An Associate is on the way to assist you.",@"image":@"o2image.jpg"};
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

- (void)showSummaryCard:(NSDictionary *)infoDict{
    if (!summaryCardView) {
        summaryCardView = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCardView"
                                                         owner:self
                                                       options:nil] firstObject];
        summaryCardView.backgroundColor = [UIColor clearColor];
    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
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


- (void)summaryButtonClickedAtIndex:(int)index
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    delegate.beaconTimer = [NSTimer    scheduledTimerWithTimeInterval:IDLETIMER target:self selector:@selector(LocationManagerAction) userInfo:nil repeats:NO];

    switch (index) {
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [summaryCardView removeFromSuperview];
                self.visibleCardView = nil;
            }];
        }
            break;
        default:
            break;
    }
}



@end
