//
//  LoginViewController.h
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    AppDelegate *delegate;
    
}
//AFHTTPClient

@end
