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
    NSTimer *myTimer;
    ZBarReaderViewController *reader;
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
    
    // Do any additional setup after loading the view.
    reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
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

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    
    NSLog(@"this is result text:%@",resultText.text);
    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];

    if (![resultText.text isEqualToString:@""]) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(targetMethod) userInfo:nil repeats:NO];
    }
}

-(void)menuBtnAction{
    self.menuContainerViewController.menuWidth = 80;
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)targetMethod{
    
    [myTimer invalidate];
    myTimer = nil;
    
    if (![resultText.text isEqualToString:@"Please Scan again"]) {
        delegate.productId = resultText.text;
        [self scanApi];
    }
    
}

-(void)scanApi{
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

    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:resultText.text,@"code",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link = @"POSMClient/json/process/execute/ProductSearch";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",delegate.SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled=NO;
        NSLog(@"returnDict: %lu",(unsigned long)returnDict.count);
        NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:0];
        arr=[[returnDict objectForKey:@"data"]valueForKey:@"SearchObjectList"];
        
        if (returnDict != nil && returnDict != (id)[NSNull null] && arr.count>0) {
            
            delegate.productDict = returnDict;
            
            ProductViewController *proObj=[[ProductViewController alloc]init];
            [self.navigationController pushViewController:proObj animated:YES];
            
        }else{
            
            UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"The product not available. do you want to scan again" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            [alrView show];
        }
        self.view.userInteractionEnabled=YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Reterive Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {

        [self presentViewController:reader animated:YES completion:nil];

        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [myTimer invalidate];
    myTimer = nil;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
