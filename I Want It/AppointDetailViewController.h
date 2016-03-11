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
#import "AppointmentViewController.h"
@interface AppointDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    AppDelegate *delegate;
    ActivityIndicatorController *activityIndicator;
    CommonWebServices *APIservice;
    
    NSMutableDictionary *appDetailDict;


    UIButton *backBtn,*addBtn,*sideMenuBtn, *appDeletBtn;
    UIColor *backColor,*textColor;
    NSMutableArray *apptArray, *apptItemArray,*imageArr,*imageName;
    UITableView *productTableView ;
    NSString *dateStr;
    int appointmentApi;

    UILabel *notifLbl;
    UILabel *reasonLbl, *reasonValLbl, *emailLbl, *emailValLbl, *dateLbl, *dateValLbl, *timeLbl, *strtimeLbl, *calDateLbl, *storeLbl, *storeValLbl, *AppointLbl, *AppointDes, *appLbl;
    CGRect txtSize ;

}
@property (strong, nonatomic) NSString *appId;
@end
