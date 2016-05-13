//
//  MyWishViewController.h
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ProductViewController.h"
#import "SideOptionViewController.h"
#import "AvailableAppointViewController.h"
#import "singleBeacon.h"

@interface MyWishViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>{
    ActivityIndicatorController *activityIndicator;
    CommonWebServices *APIservice;
    AppDelegate *delegate;
//    BeconObject *ibeacon;

    UIView *popUpView;
    UIButton *existBtn, *newBtn;
    NSInteger apiAction, selectedIndex;
}

@property (strong,retain) UITableView *tableView;

@end
