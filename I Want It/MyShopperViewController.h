//
//  MyShopperViewController.h
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "SideOptionViewController.h"
#import "ProductViewController.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "ChatScreen.h"
#import "Constants.h"
#import "AsyncImageView.h"

@interface MyShopperViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
{
    AppDelegate *delegate;
    int apiAction;
    
}
@property (strong,nonatomic,readonly) UITableView *tableView;

@end
