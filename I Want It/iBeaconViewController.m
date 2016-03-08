//
//  ViewController.m
//  iBeacon Sample
//
//  Created by mac6 on 29/02/16.
//  Copyright © 2016 Great Innouvs Solutions. All rights reserved.
//

#import "iBeaconViewController.h"
#import "RWTItem.h"
#import "SummaryCardView.h"

#define IDLETIMER 300


@interface iBeaconViewController ()<CLLocationManagerDelegate,SummaryCardDelegate>{
    SummaryCardView *summaryCardView;
}
@property (weak, nonatomic) UIView *visibleCardView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation iBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.items = [[NSMutableArray alloc]init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];
    
    APIservice = [[CommonWebServices alloc] init];
    APIservice.delegate = self;
    APIservice.activityIndicator = activityIndicator;
    
    UIButton *sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];
    
    warnLbl = [[UILabel alloc]init];
    warnLbl.frame = CGRectMake(10,-100,300,80);
    warnLbl.numberOfLines = 0;
    warnLbl.text = @"This feature is currently unavailable, turn on location services";
    warnLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    warnLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:warnLbl];
    
    beconView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    [self.view addSubview:beconView];
    
    
    UILabel *beconLbl = [[UILabel alloc]init];
    beconLbl.frame = CGRectMake(10,0,240,80);
    beconLbl.numberOfLines = 0;
    beconLbl.backgroundColor = [UIColor whiteColor];
    beconLbl.text = @"Turn Store Recognition \n ON\\OFF";
    beconLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    beconLbl.textAlignment = NSTextAlignmentCenter;
    [beconView addSubview:beconLbl];
    
    self.beconSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(260, 25, 50, 30)];
    [self.beconSwitch setOn:NO];
    [self.beconSwitch addTarget:self
                         action:@selector(switchIsChanged:)
               forControlEvents:UIControlEventValueChanged];
    [beconView addSubview:self.beconSwitch];
    
    // Configuration of Beacons
    
   /* // GIS Beacons
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
}

-(void)viewWillAppear:(BOOL)animated{
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(80,0,150,40);
    titleLbl.text = @"iBeacon";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isBeaconView];
    [self LocationManagerAction];
}

- (void)LocationManagerAction{
    NSLog (@"Successfully received the test notification!");
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Yes");
        beconView.frame = CGRectMake(0, 0, 320, 80);
        [UIView animateWithDuration:0.5 animations:^{
            warnLbl.frame = CGRectMake(10,-100,300,80);
        }];
    }else{
        NSLog(@"No");
        
        [UIView animateWithDuration:0.5 animations:^{
            warnLbl.frame = CGRectMake(10,10,300,80);
            beconView.frame = CGRectMake(0, warnLbl.frame.origin.y + warnLbl.frame.size.height, 320, 80);
        }completion:^(BOOL finished){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning !"
                                                                                     message:@"Your Location Service is Offline, Can you please  switch on your Location services.."
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
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

- (void) switchIsChanged:(UISwitch *)sender{
    if ([sender isOn]){
        NSLog(@"The switch is turned on.");
        if (![CLLocationManager locationServicesEnabled]) {
            [self LocationManagerAction];
        }else{
            [self restartMonitoring];
        }
    } else {
        [self forcetoStopMonitoring];
    }
}

-(void)restartMonitoring{
    [self.locationManager startUpdatingLocation];
    for (RWTItem *obj in self.items) {
        [self startMonitoringItem:obj];
    }
}
-(void)forcetoStopMonitoring{
    [self.locationManager stopUpdatingLocation];
    NSLog(@"The switch is turned off.");
    for (RWTItem *obj in self.items) {
        [self stopMonitoringItem:obj];
    }
}


- (void)menuBtnAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
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
                        self.navigationController.navigationBarHidden = NO;
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
    [self.view addSubview:summaryCardView];
    
    summaryCardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    summaryCardView.layer.masksToBounds = YES;
    summaryCardView.delegate = self;
    summaryCardView.titleLabel.text = [infoDict objectForKey:@"title"];
    summaryCardView.summaryView.text = [infoDict objectForKey:@"summary"];
    [summaryCardView.okButton setTitle:@"OK" forState:UIControlStateNormal];
    summaryCardView.imageView.image = [UIImage imageNamed:[infoDict objectForKey:@"image"]];
    
    self.visibleCardView = summaryCardView;
    [UIView animateWithDuration:0.35 animations:^{
        self.navigationController.navigationBarHidden = NO;
        summaryCardView.frame = [[UIScreen mainScreen]bounds];
    } completion:^(BOOL finished) {
    }];
}


- (void)summaryButtonClickedAtIndex:(int)index
{
    [self performSelector:@selector(restartMonitoring) withObject:nil afterDelay:IDLETIMER];
    
    switch (index) {
            
        case 0:
        {
            [UIView animateWithDuration:0.35 animations:^{
                self.visibleCardView.frame = CGRectMake(0, self.visibleCardView.frame.size.height, self.visibleCardView.frame.size.width, self.visibleCardView.frame.size.height);
            } completion:^(BOOL finished) {
                [summaryCardView removeFromSuperview];
                self.visibleCardView = nil;
                self.navigationController.navigationBarHidden = NO;
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isBeaconView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
