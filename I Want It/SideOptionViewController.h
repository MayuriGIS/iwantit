//
//  SideOptionViewController.h
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MyWishViewController.h"
#import "AppointmentViewController.h"
#import "MyShopperViewController.h"
#import "ScanViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SideOptionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate *delegate;
    NSMutableArray *unSeleImg,*seleImg;
    
}


@end
