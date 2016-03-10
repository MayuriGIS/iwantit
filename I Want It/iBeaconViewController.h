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
@interface iBeaconViewController : UIViewController<SummaryCardDelegate>{
    CommonWebServices *APIservice;
    AppDelegate *delegate;
    BeconObject *ibeacon;
    SummaryCardView *summaryCardView;

    UILabel *warnLbl;
    UIView *beconView;
}
@property (nonatomic, strong) UISwitch *beconSwitch;
@property (weak, nonatomic) UIView *visibleCardView;

@end

