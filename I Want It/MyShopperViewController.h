//
//  MyShopperViewController.h
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideOptionViewController.h"
#import "ProductViewController.h"
#import "AppDelegate.h"
#import "ChatScreen.h"

@interface MyShopperViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
{
    AppDelegate *delegate;
    int apiAction;
    ActivityIndicatorController *activityIndicator;
    CommonWebServices *APIservice;

}
@property (strong,nonatomic,readonly) UITableView *tableView;

@end
