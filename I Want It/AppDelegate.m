//
//  AppDelegate.m
//  I Want It
//
//  Created by Mac5 on 06/01/15.
//  Copyright (c) 2015 Great Innovus Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "SideOptionViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate
@synthesize userInfoArr,selectedIndex,dataBaseObj,productDict,productId,itemIdxId,proAmount,popUpEnable,isNetConnected, beaconTimer, beaconArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    userInfoArr = [[NSMutableArray alloc]init];
    productDict = [[NSMutableDictionary alloc]init];
    beaconArray = [[NSMutableArray alloc] init];
    
    // Setup Beacon UUID, MAJOR and MINOR ID's
    [self configuration];
    
    selectedIndex = -1;
    productId = @"";
    itemIdxId = @"";
    proAmount = @"";
    
    dataBaseObj = [[DataBaseClass alloc] init];
    [dataBaseObj createDatabase];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"]) {
        MyWishViewController *wishObj = [[MyWishViewController alloc]init];
        UINavigationController *navigatObj = [[UINavigationController alloc]initWithRootViewController:wishObj];
        
        navigatObj.navigationBar.barTintColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
        navigatObj.navigationBar.backgroundColor=[UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
        navigatObj.navigationBar.translucent=NO;
        
        SideOptionViewController *leftObj = [[SideOptionViewController alloc] init];
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:navigatObj leftMenuViewController:leftObj rightMenuViewController:nil];
        
        self.window.rootViewController = container;
        
    }else{
        LoginViewController *loginObj = [[LoginViewController alloc]init];
        UINavigationController *navigatObj = [[UINavigationController alloc]initWithRootViewController:loginObj];
        navigatObj.navigationBar.barTintColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
        navigatObj.navigationBar.backgroundColor=[UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
        
        SideOptionViewController *leftObj = [[SideOptionViewController alloc] init];
        MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:navigatObj leftMenuViewController:leftObj rightMenuViewController:nil];
        self.window.rootViewController = container;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.layer.edgeAntialiasingMask=YES;
    
    self.window.windowLevel = UIWindowLevelStatusBar;
    [self.window makeKeyAndVisible];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isBeaconEnabled];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isBeaconView]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"LocatinNotification"
         object:self];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) isNetConnected
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


- (void)configuration{
    // Configuration of Beacons
    
    /*// GIS Beacons
    NSArray *beaconArr = @[@{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",
                             @"name":@"mint",
                             @"major":@"57813",
                             @"minor":@"43675"},
                           @{@"UUID":@"F94DBB23-2266-7822-3782-57BEAC0952AC",
                             @"name":@"ice",
                             @"major":@"14743",
                             @"minor":@"60335"},
                           @{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                             @"name":@"blueberry",
                             @"major":@"40841",
                             @"minor":@"40841"}];
    */
    
     // OVC Beacons
     NSArray *beaconArr = @[@{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                              @"name":@"mint",
                              @"major":@"37058",
                              @"minor":@"3093"},
                            @{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                              @"name":@"ice",
                              @"major":@"34114",
                              @"minor":@"49664"},
                            @{@"UUID":@"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
                              @"name":@"blueberry",
                              @"major":@"40841",
                              @"minor":@"45724"}];
    
    
    for (NSDictionary *dict in beaconArr) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"UUID"]];
        RWTItem *item = [[RWTItem alloc] initWithName:[dict objectForKey:@"name"]
                                                 uuid:uuid
                                                major:[[dict objectForKey:@"major"] intValue]
                                                minor:[[dict objectForKey:@"minor"] intValue]];
        [self.beaconArray addObject:item];
    }

}
@end
