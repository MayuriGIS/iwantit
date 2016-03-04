//
//  ScanViewController.h
//  OVC-MOBILE
//
//  Created by macs on 25/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyWishViewController.h"
#import "ProductViewController.h"
#import "MTBBarcodeScanner.h"

@interface ScanViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    UIImageView *resultImage;
    UITextField *resultText;
    AppDelegate *delegate;
    UIView *scannerView;
    ActivityIndicatorController *activityIndicator;
    CommonWebServices *APIservice;
}
@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, strong) NSMutableArray *uniqueCodes;
@property (nonatomic, assign) BOOL captureIsFrozen;
@property (nonatomic, assign) BOOL didShowCaptureWarning;

@end
