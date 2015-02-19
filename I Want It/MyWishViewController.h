//
//  MyWishViewController.h
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "ProductViewController.h"
#import "SideOptionViewController.h"
#import "AvailableAppointViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

@interface MyWishViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    
    AppDelegate *delegate;
    UIView *popUpView;
    UIButton *existBtn, *newBtn;
    int apiAction, selectedIndex;
}

@property (strong,retain) UITableView *tableView;


@end
