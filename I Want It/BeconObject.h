//
//  BeconObject.h
//  I Want It
//
//  Created by macmini01 on 09/03/16.
//  Copyright © 2016 Great Innovus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RWTItem.h"
#import "AppDelegate.h"
#import "SummaryCardView.h"

@interface BeconObject : NSObject<CLLocationManagerDelegate, SummaryCardDelegate>{
    CommonWebServices *APIservice;
    ActivityIndicatorController *activityIndicator;
    SummaryCardView *summaryCardView;
    
    NSString *beconUID;
}

@property (weak, nonatomic) UIView *visibleCardView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIViewController *mainView;

-(void)forcetoStopMonitoring;
-(void)restartMonitoring;
-(void)beconInitialization;
@end
