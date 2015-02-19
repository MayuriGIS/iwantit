//
//  ScanViewController.h
//  OVC-MOBILE
//
//  Created by macs on 25/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "MyWishViewController.h"
#import "ProductViewController.h"
#import "ZBarReaderController.h"
#import "ZBarReaderViewController.h"
@interface ScanViewController : UIViewController< ZBarReaderDelegate, UITextFieldDelegate,UIAlertViewDelegate>{
    UIImageView *resultImage;
    UITextField *resultText;
    AppDelegate *delegate;
}

@end
