//
//  ViewController.m
//  iBeacon Sample
//
//  Created by mac6 on 29/02/16.
//  Copyright © 2016 Great Innouvs Solutions. All rights reserved.
//

#import "iBeaconViewController.h"
#import "RWTItem.h"

@interface iBeaconViewController ()

@end

@implementation iBeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    APIservice = [[CommonWebServices alloc] init];
    
    ibeacon = [[BeconObject alloc]init];
    ibeacon.mainView = self;
        
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
    warnLbl.text = @"This feature is currently unavailable, turn on location services?";
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
                                                 name:@"LocationNotification"
                                               object:nil];
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
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            NSLog(@"kCLAuthorizationStatusDenied");

            [UIView animateWithDuration:0.5 animations:^{
                warnLbl.frame = CGRectMake(10,10,300,80);
                beconView.frame = CGRectMake(0, warnLbl.frame.origin.y + warnLbl.frame.size.height, 320, 80);
            }completion:^(BOOL finished){
                [UIView animateWithDuration:0.5 animations:^{
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
                    [self.navigationController presentViewController:alertController animated:YES completion:nil];
                }completion:nil];
            }];
        }else{
            NSLog(@"kCLAuthorizationStatusAccepted");
            beconView.frame = CGRectMake(0, 0, 320, 80);
            [UIView animateWithDuration:0.5 animations:^{
                warnLbl.frame = CGRectMake(10,-100,300,80);
            }];
            
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            if (delegate.beaconTimer == nil) {
                [ibeacon beconInitialization];
            }
        }
    }else{
        NSLog(@"Location Services Disabled");
        
        [UIView animateWithDuration:0.5 animations:^{
            warnLbl.frame = CGRectMake(10,10,300,80);
            beconView.frame = CGRectMake(0, warnLbl.frame.origin.y + warnLbl.frame.size.height, 320, 80);
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.5 animations:^{
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
                [self.navigationController presentViewController:alertController animated:YES completion:nil];
            }completion:nil];
        }];
    }
}

- (void) switchIsChanged:(UISwitch *)sender{
    if ([sender isOn]){
        [ibeacon forcetoStopMonitoring];
        NSDictionary *dict = @{@"title":@"Welcome to the “London - The Strand” Store",@"summary":@"An Associate is on the way to assist you.",@"image":@"o2image.jpg"};
        if(!self.visibleCardView) {
            [self performSelector:@selector(showSummaryCard:) withObject:dict afterDelay:1];
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

- (void)summaryButtonClickedAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [self.beconSwitch setOn:NO];
            [self userRegistrationAPI];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            delegate.beaconTimer = [NSTimer    scheduledTimerWithTimeInterval:IDLETIMER target:ibeacon selector:@selector(beconInitialization) userInfo:nil repeats:NO];

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

-(void)userRegistrationAPI{
    /*
     URL - http://<<server name>>:<<port number>>/json/process/execute/NotifyCustomerArrival
     BODY - {
     "loyaltyId": "<<LOYALTY ID OF THE CUSTOMER >>",
     "uuid": "<<BEACON UUID>>"
     }
     */
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:USERDETAIL];
    
    // UUID Hard Coded
    NSDictionary *data = @{@"loyaltyId":[userDetail valueForKey:@"loyaltyId"], @"uuid": @"12345"};
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

-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isBeaconView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
