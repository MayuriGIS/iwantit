//
//  AppointmentViewController.h
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "AvailableAppointViewController.h"
#import "AppointDetailViewController.h"
#import "ChatScreen.h"
@interface AppointmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    AppDelegate *delegate;
    NSMutableArray *returnData;

}

@end
