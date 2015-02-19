//
//  AppointDetailViewController.h
//  OVC-MOBILE
//
//  Created by macs on 22/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "MFSideMenu.h"
@interface AppointDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
    AppDelegate *delegate;
}
@end
