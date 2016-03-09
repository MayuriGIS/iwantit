//
//  ViewController.h
//  iBeacon Sample
//
//  Created by mac6 on 29/02/16.
//  Copyright © 2016 Great Innouvs Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "BeconObject.h"
@interface iBeaconViewController : UIViewController{
    CommonWebServices *APIservice;
    ActivityIndicatorController *activityIndicator;
    AppDelegate *delegate;
    BeconObject *ibeacon;
    
    UILabel *warnLbl;
    UIView *beconView;
    NSString *beconUID;
    NSTimer *timer;
}
@property (nonatomic, strong) UISwitch *beconSwitch;

@end

