//
//  AvailableAppointViewController.h
//  OVC-MOBILE
//
//  Created by macs on 22/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "AppointmentViewController.h"
#import "MyWishViewController.h"
@interface AvailableAppointViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *storeCollectionView;

    AppDelegate *delegate;
    ActivityIndicatorController *activityIndicator;
    CommonWebServices *APIservice;

    NSString *startTime, *endTime, *dateStr;
}


@end
