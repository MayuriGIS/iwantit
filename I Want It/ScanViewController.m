//
//  ScanViewController.m
//  OVC-MOBILE
//
//  Created by macs on 25/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController (){
    UIButton *sideMenuBtn;
    UILabel *titleLbl;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];
    
    APIservice = [[CommonWebServices alloc] init];
    APIservice.delegate = self;
    APIservice.activityIndicator = activityIndicator;

    sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];
    
    resultImage = [[UIImageView alloc]init];
    resultImage.backgroundColor = [UIColor clearColor];
    resultImage.frame = CGRectMake(10,50, 300,250);
    [self.view addSubview:resultImage];
    
    resultText = [[UITextField alloc]init];
    resultText.textAlignment = NSTextAlignmentCenter;
    resultText.text = @"Please Scan again";
    resultText.delegate = self;
    resultText.userInteractionEnabled=NO;
    resultText.font = [UIFont fontWithName:@"Kailasa" size:20.0];
    resultText.frame = CGRectMake(10,300,300,100);
    [self.view addSubview:resultText];
    
    [self startScanning];
    
    // present and release the controller
    //    [self presentViewController:reader animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0,0,200,44);
    titleLbl.text = @"Scan Details";
    titleLbl.font = [UIFont fontWithName:@"Kailasa" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
}



-(void)menuBtnAction{
    self.menuContainerViewController.menuWidth = 80;
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


/*
 
 FULL BARCODE SCANNER OPERATION AND METHODS
 
 */

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:resultImage];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
    self.uniqueCodes = [[NSMutableArray alloc] init];
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                [self.uniqueCodes addObject:code.stringValue];
                NSLog(@"Found unique code: %@", code.stringValue);
                resultText.text = code.stringValue;
                if (![resultText.text isEqualToString:@"Please Scan again"] && ![resultText.text isEqualToString:@""]) {
                    delegate.productId = resultText.text;
                    [self scanApi];
                }
                if (self.captureIsFrozen) {
                    [self.scanner unfreezeCapture];
                } else {
                    [self.scanner freezeCapture];
                }
            }
        }
    }];
    
}

- (void)stopScanning {
    [self.scanner stopScanning];
    self.captureIsFrozen = NO;
}


- (void)scanApi{
    /*
     http://demoqa.ovcdemo.com:8080/POSMClient/json/process/execute/ProductSearch
     {
     "username": "eCommerce",
     "password": "changeme",
     "deviceId": "dUUID",
     "source": "external",
     "data":{"code": "479956,1992693"}
     }
     */
    
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:resultText.text,@"code",nil];
    
    [activityIndicator showActivityIndicator];
    [APIservice getProductDetailApiWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *returnDict = [resultDic mutableCopy];
                NSMutableArray *arr = [[returnDict objectForKey:@"data"]valueForKey:@"SearchObjectList"];

                if (arr.count != 0) {
                    delegate.productDict = returnDict;
                    
                    ProductViewController *proObj=[[ProductViewController alloc]init];
                    [self.navigationController pushViewController:proObj animated:YES];

                }else{
                    
                    UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"The product not available. do you want to scan again" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                    [alrView show];
                }
            }
        }
        
    } failureBlock:^(NSError *error) {
        [activityIndicator hideActivityIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    } dataDict:data];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [self.scanner unfreezeCapture];
        resultText.text = @"Please Scan again";

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
