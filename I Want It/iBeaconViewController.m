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
    self.items = [[NSMutableArray alloc]init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    
    UIButton *sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];

    
//    NSArray *beaconArr = @[@{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",@"name":@"Beacon 1",@"major":@"57813",@"minor":@"43675"},@{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",@"name":@"Beacon 2",@"major":@"14743",@"minor":@"60335"}];
    
    NSArray *beaconArr = @[@{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",@"name":@"Beacon 1",@"major":@"57813",@"minor":@"43675"}];

    for (NSDictionary *dict in beaconArr) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"UUID"]];
        RWTItem *item = [[RWTItem alloc] initWithName:[dict objectForKey:@"name"]
                                                    uuid:uuid
                                                   major:[[dict objectForKey:@"major"] intValue]
                                                   minor:[[dict objectForKey:@"minor"] intValue]];
        [self.items addObject:item];
        [self startMonitoringItem:item];
    }
    
    NSDictionary *dict = @{@"title":@"You Have Reached O2 Store",@"summary":@"Hello USER! Welcome to the O2 Store, Have a nice day",@"image":@"o2image.jpg"};
    if(!self.visibleCardView) {
        [self showSummaryCard:dict];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    //    [self appointmentApi];
    
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(80,0,150,40);
    titleLbl.text = @"iBeacon";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        for (RWTItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
                if (item.lastSeenBeacon.proximity == 1 || item.lastSeenBeacon.proximity == 2){
                    NSDictionary *dict = @{@"title":@"You Have Reached O2 Store",@"summary":@"Hello USER! Welcome to the O2 Store, Have a nice day",@"image":@"o2image.jpg"};
                    if(!self.visibleCardView) {
                        [self showSummaryCard:dict];
                    }
                    
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


/*
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        for (RWTItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
                if (item.lastSeenBeacon.proximity == 1 || item.lastSeenBeacon.proximity == 2){
                    if ([item.name isEqualToString:@"Beacon 1"]){
                        isShow = NO;
                        NSDictionary *dict = @{@"title":@"You Have Reached O2 Store",@"summary":@"Hello USER! Welcome to the O2 Store, Have a nice day",@"image":@"o2image.jpg"};
                        if(!self.visibleCardView) {
                            if (!isShow) {
                                isShow = YES;
                                [self showSummaryCard:dict];
                            }
                        }
                    }else if ([item.name isEqualToString:@"Beacon 2"]){
                        isShow = NO;
                        NSDictionary *dict = @{@"title":@"You Have Reached another O2 Store",@"summary":@"Hello MANIMARAN! Welcome to the O2 Store, You have lot of amazing offers here",@"image":@"o2image1.png"};
                        if(!self.visibleCardView) {
                            if (!isShow) {
                                isShow = YES;
                                [self showSummaryCard:dict];
                            }
                        }
                    }else{
                        isShow = NO;
                        self.visibleCardView = nil;
                    }

                }else{
                    isShow = NO;

                    self.visibleCardView = nil;

                }
            }
        }
    }
}
*/
- (void)showSummaryCard:(NSDictionary *)infoDict{
    if (!summaryCardView) {
        summaryCardView = [[[NSBundle mainBundle] loadNibNamed:@"SummaryCardView"
                                                         owner:self
                                                       options:nil] firstObject];
    }
    [self.view addSubview:summaryCardView];
    summaryCardView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    summaryCardView.layer.masksToBounds = YES;
    summaryCardView.delegate = self;
    summaryCardView.titleLabel.text = [infoDict objectForKey:@"title"];
    summaryCardView.summaryView.text = [infoDict objectForKey:@"summary"];
    [summaryCardView.okButton setTitle:@"OK" forState:UIControlStateNormal];
//    summaryCardView.okAction = notif.okAction;
    summaryCardView.imageView.image = [UIImage imageNamed:[infoDict objectForKey:@"image"]];

    self.visibleCardView = summaryCardView;
    [UIView animateWithDuration:0.35 animations:^{
        summaryCardView.frame = self.view.frame;
        self.navigationController.navigationBarHidden = NO;
    } completion:^(BOOL finished) {
    }];
}


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
                self.navigationController.navigationBarHidden = NO;
            }];
        }
            break;
            
        case 1:
        {
            if ([summaryCardView.okAction length]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:summaryCardView.okAction]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
