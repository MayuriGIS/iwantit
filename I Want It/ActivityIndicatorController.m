//
//  ActivityIndicatorController.m
//  SAP
//
//  Created by web7 on 21/12/15.
//  Copyright © 2015 Great Innovus Solutions. All rights reserved.
//

#import "ActivityIndicatorController.h"


@implementation ActivityIndicatorController
@synthesize activityIndicator;
-(void) initWithViewController:(UINavigationController *)viewController
{
    mainView = viewController;
    activityIndicator = [[MBProgressHUD alloc] initWithView:viewController.view];
    [viewController.view addSubview:activityIndicator];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    activityIndicator.delegate = self;
}

-(void) showActivityIndicator
{
    [activityIndicator show:YES];
    mainView.view.userInteractionEnabled = NO;
}
-(void) hideActivityIndicator
{
    [activityIndicator hide:YES];
    mainView.view.userInteractionEnabled = YES;
}

@end
