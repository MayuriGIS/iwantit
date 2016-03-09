//
//  ViewController.m
//  iBeacon Sample
//
//  Created by mac6 on 29/02/16.
//  Copyright © 2016 Great Innouvs Solutions. All rights reserved.
//

#import "iBeaconViewController.h"
#import "RWTItem.h"

#define IDLETIMER 300


@interface iBeaconViewController ()<CLLocationManagerDelegate>

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
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];
    
    ibeacon = [[BeconObject alloc]init];
    ibeacon.mainView = self;
    
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
    beconLbl.frame = CGRectMake(10,0,180,80);
    beconLbl.numberOfLines = 0;
    beconLbl.backgroundColor = [UIColor whiteColor];
    beconLbl.text = @"Simulate iBeacon call";
    beconLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    beconLbl.textAlignment = NSTextAlignmentRight;
    [beconView addSubview:beconLbl];
    
    self.beconSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 25, 50, 30)];
    [self.beconSwitch addTarget:self
                         action:@selector(switchIsChanged:)
               forControlEvents:UIControlEventValueChanged];
    [beconView addSubview:self.beconSwitch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LocationManagerAction)
                                                 name:@"LocatinNotification"
                                               object:nil];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:isBeaconEnabled]) {
        [self.beconSwitch setOn:YES];
    }else{
        [self.beconSwitch setOn:NO];
    }
}

- (void)menuBtnAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
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
            [UIView animateWithDuration:0.5 animations:^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning !"
                                                                                         message:@"This feature is currently unavailable- turn on location services?"preferredStyle:UIAlertControllerStyleAlert];
                
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
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
            }completion:nil];
        }];
    }
}

- (void) switchIsChanged:(UISwitch *)sender{
    if ([sender isOn]){
        NSLog(@"The switch is turned on.");
        [ibeacon beconInitialization];
    } else {
        [delegate.beaconTimer invalidate];
        delegate.beaconTimer = nil;
        [ibeacon forcetoStopMonitoring];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isBeaconEnabled];
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
