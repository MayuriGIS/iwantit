//
//  AppDelegate.h
//  I Want It
//
//  Created by Mac5 on 06/01/15.
//  Copyright (c) 2015 Great Innovus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseClass.h"
#include <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *naviPath,*productId, *itemIdxId,*proAmount,*SER;
@property (nonatomic, strong) DataBaseClass *dataBaseObj;
@property (nonatomic, strong) NSMutableArray *userInfoArr;
@property (nonatomic, strong) NSMutableDictionary *productDict;
@property (nonatomic) int selectedIndex;
@property (nonatomic) BOOL isNetConnected , popUpEnable;

@end
