//
//  LoginViewController.m
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "LoginViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MyWishViewController.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"

@interface LoginViewController (){
    UITextField *emailTxtfld,*passTxtfld,*urlTxtfld;
    UIButton    *submit;
    NSString    *trimEmail;
    UIImageView *naviLogo;
    UILabel *chooseLbl;
    UITableView *serverTable;
    NSMutableArray *serverArr;
    BOOL arrowFlag;
}


@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    arrowFlag = NO;
    
    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];
    
    APIservice = [[CommonWebServices alloc] init];
    APIservice.delegate = self;
    APIservice.activityIndicator = activityIndicator;

    
    serverArr = [[NSMutableArray alloc]initWithObjects:
                 @"http://mo-ovc-test.obnubilate.co.uk:8080/",
                 @"http://mo-ovc-demo.obnubilate.co.uk:8080/",
                 @"http://ovc-o2.ovcdemo.com:8080/",
                 @"http://sales.ovcdemo.com:8080/",
                 @"http://ovctelco.ovcdemo.com:8080/",
                 @"http://ovcapparel.ovcdemo.com:8080", nil];
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    self.view.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    
    naviLogo = [[UIImageView alloc]init];
    naviLogo.frame = CGRectMake(96,0,128,40);
    naviLogo.image = [UIImage imageNamed:@"appbar_icon"];
    [self.navigationController.navigationBar addSubview:naviLogo];
    
    chooseLbl = [[UILabel alloc]init];
    chooseLbl.tag=10;
    chooseLbl.text = @"Server URL:";
    chooseLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    chooseLbl.textColor = [UIColor blackColor];
    chooseLbl.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:chooseLbl];
    
    UIView *urlBackView=[[UIView alloc]init];
    urlBackView.layer.borderColor = [[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]CGColor];
    urlBackView.layer.borderWidth = 1.0f;
    urlBackView.layer.cornerRadius = 5;
    [self.view addSubview:urlBackView];
    
    urlTxtfld = [[UITextField alloc]init];
    urlTxtfld.tag=10;
    urlTxtfld.delegate=self;
    if ([[NSUserDefaults standardUserDefaults]stringForKey:SERVERNAME] != nil) {
        urlTxtfld.text = [[NSUserDefaults standardUserDefaults]stringForKey:SERVERNAME];
    }else{
        urlTxtfld.text = [serverArr objectAtIndex:3];
    }
    
    urlTxtfld.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    urlTxtfld.backgroundColor = [UIColor whiteColor];
    [urlBackView addSubview:urlTxtfld];
    
    UIButton *dropImg = [[UIButton alloc]init];
    [dropImg setImage: [UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    [dropImg addTarget:self action:@selector(chooseBtnAct) forControlEvents:UIControlEventTouchUpInside];
    dropImg.userInteractionEnabled = YES;
    dropImg.backgroundColor = [UIColor clearColor];
    [urlBackView addSubview:dropImg];
    
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.text = @"Email:";
    emailLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    emailLabel.textColor = [UIColor blackColor];
    emailLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:emailLabel];
    
    
    UIView *emailBackView = [[UIView alloc]init];
    emailBackView.backgroundColor = [UIColor whiteColor];
    emailBackView.layer.borderColor = [[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]CGColor];
    emailBackView.layer.borderWidth = 1.0f;
    emailBackView.layer.cornerRadius = 5;
    [self.view addSubview:emailBackView];
    
    
    emailTxtfld = [[UITextField alloc]init];
    if ([[NSUserDefaults standardUserDefaults]stringForKey:@"userMail"] == nil) {
        emailTxtfld.text = @"abhijit@oneviewcommerce.com";
    }else{
        emailTxtfld.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"userMail"];
    }
    emailTxtfld.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    emailTxtfld.keyboardType = UIKeyboardTypeEmailAddress;
    emailTxtfld.delegate = self;
    emailTxtfld.autocapitalizationType = NO;
    emailTxtfld.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTxtfld.backgroundColor = [UIColor clearColor];
    emailTxtfld.textAlignment = NSTextAlignmentRight;
    [emailBackView addSubview:emailTxtfld];
    
    UILabel *passLabel = [[UILabel alloc]init];
    passLabel.text = @"Password:";
    passLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    passLabel.textColor = [UIColor blackColor];
    passLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:passLabel];
    
    UIView *passBackView = [[UIView alloc]init];
    passBackView.backgroundColor = [UIColor whiteColor];
    passBackView.layer.borderColor = [[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1]CGColor];
    passBackView.layer.borderWidth = 1.0f;
    passBackView.layer.cornerRadius = 5;
    [self.view addSubview:passBackView];
    
    passTxtfld = [[UITextField alloc]init];
    passTxtfld.backgroundColor = [UIColor clearColor];
    passTxtfld.delegate = self;
    passTxtfld.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    passTxtfld.text = @"123456";
    passTxtfld.secureTextEntry = YES;
    passTxtfld.textAlignment = NSTextAlignmentRight;
    passTxtfld.backgroundColor = [UIColor clearColor];
    [passBackView addSubview:passTxtfld];
    
    submit = [[UIButton alloc]init];
    submit.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:239.0f/255.0f blue:255.0f/255.0f alpha:1];
    submit.layer.cornerRadius = 5;
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    submit.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
    [submit setTitle:@"LOG IN" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:submit];
    
    UIImageView *cornerImage=[[UIImageView alloc]init];
    cornerImage.image=[UIImage imageNamed:@"IWI_logincorner"];
    cornerImage.backgroundColor=[UIColor clearColor];
    [self.view addSubview:cornerImage];
    
    //----------------Frame--------------
    
    chooseLbl.frame = CGRectMake(0, 110, 80, 30);
    urlBackView.frame = CGRectMake(85, 110,230 , 30);
    urlTxtfld.frame = CGRectMake(0, 0,200, 30);
    dropImg.frame = CGRectMake(200, 0, 30,30);
    
    emailLabel.frame = CGRectMake(0,chooseLbl.frame.size.height+chooseLbl.frame.origin.y+18 , 80, 30);
    emailBackView.frame = CGRectMake(85,chooseLbl.frame.size.height+chooseLbl.frame.origin.y+18, 230, 35);
    emailTxtfld.frame = CGRectMake(0, 0,225, 35);
    
    passLabel.frame = CGRectMake(0,emailLabel.frame.size.height+emailLabel.frame.origin.y+18 , 80, 30);
    passBackView.frame = CGRectMake(85,emailLabel.frame.size.height+emailLabel.frame.origin.y+18, 230, 35);
    passTxtfld.frame = CGRectMake(0, 0, 225, 35);
    
    submit.frame = CGRectMake(80, passBackView.frame.origin.y + passBackView.frame.size.height+40, 150, 40);
    
    if (IS_IPHONE4) {
        cornerImage.frame=CGRectMake(213,309 ,107, 107);
        
    }else{
        cornerImage.frame=CGRectMake(213,398 ,107, 107);
        
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
}

#pragma mark-function

-(void)submitAction{
    [emailTxtfld resignFirstResponder];
    [passTxtfld resignFirstResponder];
    
    if ([urlTxtfld.text isEqualToString:@""]) {
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Select Server URL" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
        [alertObj show];
    }else{
        if ([emailTxtfld.text isEqualToString:@""]) {
            
            UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter your Email Id" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alertObj show];
            
            
        }else if ([passTxtfld.text isEqualToString:@""]){
            UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter your Passoword" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            [alertObj show];
            
        }else{
            
            if ([self Emailvalidate:emailTxtfld.text]) {
                [[NSUserDefaults standardUserDefaults]setObject:trimEmail forKey:@"userMail"];
                if (![urlTxtfld.text isEqualToString:@""] && ![urlTxtfld.text isEqualToString:@"http://"]) {
                    [self loginApi];
                }
                
            }else{
                
                UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter a Valid Email Id" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                [alertObj show];
            }
        }
    }
}

-(void)chooseBtnAct
{
    if (!arrowFlag){
        
        [emailTxtfld resignFirstResponder];
        [passTxtfld resignFirstResponder];
        
        serverTable = [[UITableView alloc]init];
        serverTable.frame = CGRectMake(85,145, 230, 100);
        serverTable.dataSource = self;
        serverTable.delegate = self;
        serverTable.backgroundColor = [UIColor whiteColor];
        serverTable.layer.cornerRadius = 0.5;
        serverTable.layer.borderColor = [UIColor grayColor].CGColor;
        serverTable.layer.borderWidth = 1.0;
        [self.view addSubview:serverTable];
        arrowFlag = YES;
    }else{
        serverTable.hidden = YES;
        arrowFlag = NO;
    }
    
}
#pragma mark TableViewDataSource and TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return serverArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    UIView *tablecellView = [[UIView alloc]init];
    tablecellView.backgroundColor = [UIColor clearColor];
    tablecellView.frame = CGRectMake(0,0,230,40);
    
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *strIDLabl = [[UILabel alloc]init];
    strIDLabl.backgroundColor = [UIColor clearColor];
    strIDLabl.frame = CGRectMake(05, 0, 220, 40);
    strIDLabl.text = [NSString stringWithFormat:@"%@",[serverArr  objectAtIndex:indexPath.row]];
    strIDLabl.textColor = [UIColor blackColor];
    strIDLabl.font = [UIFont fontWithName:@"Open Sans" size:12.0];
    [tablecellView addSubview:strIDLabl];
    
    [cell.contentView addSubview:tablecellView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlName = [NSString stringWithFormat:@"%@",[serverArr  objectAtIndex:indexPath.row]];
    urlTxtfld.text = urlName;
    serverUrl = urlName;
    serverTable.hidden = YES;
}

- (BOOL) Emailvalidate:(NSString *)tempMail
{
    NSString *email_Id = tempMail;
    trimEmail = [email_Id stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:trimEmail];
}

#pragma mark - Api Action

- (void) loginApi{
    [[NSUserDefaults standardUserDefaults] setObject:urlTxtfld.text forKey:SERVERNAME];
    
    /*http://demoqa.ovcdemo.com:8080/POSMClient/json/process/execute/QueryLoyaltyMembers
     Request payload:
     {
     "username": "eCommerce",
     "password": "changeme",
     "deviceId": "dUUID",
     "source": "external",
     "data":{"loyaltyyId":"linda","firstName":"","lastName":"","email":"linda","retailerId":"demoRetailer"}
     }
     */
    
//    NSDictionary *data = @{@"loyaltyId":trimEmail, @"firstName": @"Abhijit", @"lastName": @"killedar", @"email": @"abhijit@oneviewcommerce.com", @"phone": @""};
    
    NSDictionary *data = @{@"loyaltyId":trimEmail, @"firstName": @"", @"lastName": @"", @"email": trimEmail, @"phone": @""};

    
    [activityIndicator showActivityIndicator];
    [APIservice loginApiWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Login Return Data: %@",resultDic);
                if ([[[resultDic objectForKey:@"data"]objectForKey:@"memberList"] count] != 0) {
                    [delegate.userInfoArr addObjectsFromArray:[[[resultDic objectForKey:@"data"]objectForKey:@"memberList"] mutableCopy]];
                    NSMutableDictionary *userDetail = [[NSMutableDictionary alloc]init];
                    
                    if (![[[delegate.userInfoArr firstObject] valueForKey:@"email"] isEqualToString:@""]) {
                        [userDetail setValue:[[delegate.userInfoArr firstObject] valueForKey:@"email"] forKey:@"email"];
                    }
                    
                    if (![[[delegate.userInfoArr firstObject] valueForKey:@"firstName"] isEqualToString:@""]) {
                        [userDetail setValue:[[delegate.userInfoArr firstObject] valueForKey:@"firstName"] forKey:@"firstName"];
                    }
                    
                    if (![[[delegate.userInfoArr firstObject] valueForKey:@"lastName"] isEqualToString:@""]) {
                        [userDetail setValue:[[delegate.userInfoArr firstObject] valueForKey:@"lastName"] forKey:@"lastName"];
                    }
                    
                    if (![[[delegate.userInfoArr firstObject] valueForKey:@"loyaltyId"] isEqualToString:@""] ) {
                        [userDetail setValue:[[delegate.userInfoArr firstObject] valueForKey:@"loyaltyId"] forKey:@"loyaltyId"];
                    }
                    
                    if ([[delegate.userInfoArr firstObject] valueForKey:@"homePhone"] != (id) [NSNull null]) {
                        [userDetail setValue:[[delegate.userInfoArr firstObject] valueForKey:@"homePhone"] forKey:@"homePhone"];
                    }
                    
                    if ([[delegate.userInfoArr firstObject] valueForKey:@"homePhone"] != (id) [NSNull null]) {
                        [userDetail setValue:[[delegate.userInfoArr firstObject] valueForKey:@"mobilePhone"] forKey:@"mobilePhone"];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:userDetail forKey:USERDETAIL];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FirstTime"];
                    
                    MyWishViewController *wishObj=[[MyWishViewController alloc]init];
                    [self.navigationController pushViewController:wishObj animated:NO];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                        message:@"User Not Found"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];

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

#pragma mark-UITextfield delegate Function

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    serverTable.hidden = YES;
    arrowFlag = NO;
    if (IS_IPHONE4) {
    }
    if (textField.tag==10) {
        if ([textField.text isEqualToString:@""]) {
            urlTxtfld.text=@"http://";
        }
    }
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self changeText];
    return YES;
}
-(void)changeText{
    
    if ([chooseLbl.text isEqualToString:@"http://"]||[chooseLbl.text isEqualToString:@""]) {
        
        chooseLbl.text = @"";
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [naviLogo removeFromSuperview];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
