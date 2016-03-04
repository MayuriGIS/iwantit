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

@interface MyWishViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    AppDelegate *delegate;
    UIView *popUpView;
    UIButton *existBtn, *newBtn;
    NSInteger apiAction, selectedIndex;
    ActivityIndicatorController *activityIndicator;
    CommonWebServices *APIservice;
}

@property (strong,retain) UITableView *tableView;


@end
