//
//  ActivityIndicatorController.h
//  SAP
//
//  Created by web7 on 21/12/15.
//  Copyright © 2015 Great Innovus Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ActivityIndicatorController : NSObject <MBProgressHUDDelegate>
{
    UIViewController *mainView;
}

@property (nonatomic, strong) MBProgressHUD *activityIndicator;

-(void) initWithViewController:(UINavigationController *) viewController;
-(void) showActivityIndicator;
-(void) hideActivityIndicator;

@end
