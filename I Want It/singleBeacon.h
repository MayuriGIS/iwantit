//
//  singleBeacon.h
//  I Want It
//
//  Created by macmini01 on 13/05/16.
//  Copyright © 2016 Great Innovus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RWTItem.h"
#import "AppDelegate.h"
#import "SummaryCardView.h"

@interface singleBeacon : NSObject<CLLocationManagerDelegate, SummaryCardDelegate>{
    CommonWebServices *APIservice;
    ActivityIndicatorController *activityIndicator;
    SummaryCardView *summaryCardView;
    NSString *beconUID;
}
@property (strong, nonatomic) NSTimer *beaconTimer;
@property (weak, nonatomic) UIView *visibleCardView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIViewController *mainView;

+ (singleBeacon *)sharedCenter;   // class method to return the singleton object
- (void)customMethod; // add optional methods to customize the singleton class
-(void)forcetoStopMonitoring;
-(void)restartMonitoring;
-(void)beconInitialization;

@end
