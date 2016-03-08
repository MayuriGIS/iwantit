//
//  ViewController.h
//  iBeacon Sample
//
//  Created by mac6 on 29/02/16.
//  Copyright © 2016 Great Innouvs Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
@interface iBeaconViewController : UIViewController{
    UILabel *warnLbl;
    UIView *beconView;
    CommonWebServices *APIservice;
    ActivityIndicatorController *activityIndicator;
    NSString *beconUID;
    NSTimer *timer;
}
@property (nonatomic, strong) UISwitch *beconSwitch;

@end

