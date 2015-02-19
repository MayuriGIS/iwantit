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
#import "AddOptionViewController.h"
#import "LoginViewController.h"

#import <HockeySDK/HockeySDK.h>

@implementation AppDelegate
@synthesize isNetConnected,userInfoArr,selectedIndex,dataBaseObj,productDict,productId,itemIdxId,proAmount,SER,popUpEnable;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"b4f68b8f0ba0bfdf9aa711f3cd46151f"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    userInfoArr = [[NSMutableArray alloc]init];
    productDict = [[NSMutableDictionary alloc]init];
    
    selectedIndex = -1;
    productId = @"";
    itemIdxId = @"";
    proAmount = @"";
    SER=@"";
    
    dataBaseObj = [[DataBaseClass alloc] init];
    [dataBaseObj createDatabase];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"]) {
        
        SER=[[NSUserDefaults standardUserDefaults]objectForKey:@"Servername"];
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
        
        navigatObj.navigationBar.backgroundColor=[UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
        
        
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
    return YES;
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
