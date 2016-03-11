//
//  AppointDetailViewController.m
//  OVC-MOBILE
//
//  Created by macs on 22/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "AppointDetailViewController.h"

@interface AppointDetailViewController (){
}

@end

@implementation AppointDetailViewController
@synthesize appId;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    appointmentApi=0;
    
    //    [self appointmentDetailsApi];
    
    apptArray = [[NSMutableArray alloc]initWithCapacity:0];
    appDetailDict = [[NSMutableDictionary alloc]init];
    apptItemArray = [[NSMutableArray alloc]init];
    
    backColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1];
    textColor = [UIColor colorWithRed:81.0f/255.0f green:81.0f/255.0f blue:81.0f/255.0f alpha:1];
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];
    
    APIservice = [[CommonWebServices alloc] init];
    APIservice.delegate = self;
    APIservice.activityIndicator = activityIndicator;
    
    self.view.backgroundColor = backColor;
    
    sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,40,64);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -20, 0, 0);
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAct) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftA = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];
    UIBarButtonItem *leftB = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:leftA,leftB, nil];
    
    reasonLbl = [[UILabel alloc]init];
    reasonLbl.backgroundColor = [UIColor clearColor];
    reasonLbl.text = @"Reason Code : ";
    reasonLbl.textAlignment=NSTextAlignmentLeft;
    reasonLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:reasonLbl];
    
    reasonValLbl = [[UILabel alloc]init];
    reasonValLbl.backgroundColor = [UIColor clearColor];
    reasonValLbl.textColor = textColor;
    reasonValLbl.textAlignment = NSTextAlignmentLeft;
    reasonValLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    [self.view addSubview:reasonValLbl];
    
    emailLbl = [[UILabel alloc]init];
    emailLbl.backgroundColor = [UIColor clearColor];
    emailLbl.text = @"Email : ";
    emailLbl.textAlignment=NSTextAlignmentLeft;
    emailLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:emailLbl];
    
    emailValLbl = [[UILabel alloc]init];
    emailValLbl.backgroundColor = [UIColor clearColor];
    emailValLbl.numberOfLines = 0;
    emailValLbl.textColor = textColor;
    emailValLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    [self.view addSubview:emailValLbl];
    
    dateLbl = [[UILabel alloc]init];
    dateLbl.backgroundColor = [UIColor clearColor];
    dateLbl.text = @"Date : ";
    dateLbl.textAlignment=NSTextAlignmentLeft;
    dateLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:dateLbl];
    
    dateValLbl = [[UILabel alloc]init];
    dateValLbl.textColor = [UIColor colorWithRed:33.0f/255.0f green:166.0f/255.0f  blue:146.0f/255.0f alpha:1];;
    dateValLbl.textAlignment = NSTextAlignmentLeft;
    dateValLbl.font = [UIFont boldSystemFontOfSize:18];
    [self.view  addSubview:dateValLbl];
    
    timeLbl = [[UILabel alloc]init];
    timeLbl.backgroundColor = [UIColor clearColor];
    timeLbl.text = @"Time : ";
    timeLbl.textAlignment=NSTextAlignmentLeft;
    timeLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:timeLbl];
    
    strtimeLbl = [[UILabel alloc]init];
    strtimeLbl.textColor = textColor;
    strtimeLbl.numberOfLines = 0;
    strtimeLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:12.0];
    [self.view addSubview:strtimeLbl];
    
    calDateLbl = [[UILabel alloc]init];
    calDateLbl.text = dateStr;
    calDateLbl.textColor = textColor;
    calDateLbl.numberOfLines = 0;
    calDateLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    [self.view addSubview:calDateLbl];
    
    
    storeLbl = [[UILabel alloc]init];
    storeLbl.backgroundColor = [UIColor clearColor];
    storeLbl.text = @"Store : ";
    storeLbl.textAlignment=NSTextAlignmentLeft;
    storeLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:storeLbl];
    
    
    storeValLbl = [[UILabel alloc]init];
    storeValLbl.textColor = textColor;
    storeValLbl.textAlignment = NSTextAlignmentLeft;
    storeValLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:storeValLbl];
    
    
    AppointLbl = [[UILabel alloc]init];
    AppointLbl.backgroundColor = [UIColor clearColor];
    AppointLbl.text = @"Description : ";
    AppointLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    [self.view addSubview:AppointLbl];
    
  
    
    AppointDes = [[UILabel alloc]init];
    AppointDes.backgroundColor = [UIColor clearColor];
    AppointDes.numberOfLines = 0;
    AppointDes.font = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    AppointDes.textColor =textColor;
    [self.view addSubview:AppointDes];
    
    //    UIImageView *arrowImg = [[UIImageView alloc]init];
    //    arrowImg.frame = CGRectMake(295,40,8, 13);
    //    arrowImg.image = [UIImage imageNamed:@"side_arrow"];
    //    [self.view addSubview:arrowImg];
    
    appLbl = [[UILabel alloc]init];
    appLbl.text = @"My appointment items";
    appLbl.textColor=textColor;
    appLbl.font = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    [self.view addSubview:appLbl];
    
    productTableView = [[UITableView alloc]init];
    productTableView.backgroundColor = [UIColor clearColor];
    productTableView.delegate = self;
    productTableView.showsVerticalScrollIndicator = NO;
    productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    productTableView.dataSource = self;
    [self.view addSubview:productTableView];
    
    appDeletBtn = [[UIButton alloc]init];
    [appDeletBtn setTitle:@"DELETE APPOINTMENT" forState:UIControlStateNormal];
    appDeletBtn.layer.cornerRadius = 5.0f;
    appDeletBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    appDeletBtn.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
    [appDeletBtn addTarget:self action:@selector(deleteAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appDeletBtn];
    
    //    calDateLbl.frame = CGRectMake(5,80,90,20);
    //    storeLbl.frame = CGRectMake(125,80,180,20);
    
  
    
    notifLbl =[[UILabel alloc]init];
    notifLbl.frame=productTableView.frame;
    notifLbl.text=@"No product added";
    notifLbl.textAlignment=NSTextAlignmentCenter;
    notifLbl.hidden=NO;
    [self.view addSubview:notifLbl];
}

-(void)viewWillAppear:(BOOL)animated{
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0,0,200,44);
    titleLbl.text = @"Appointment Details";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    self.navigationItem.titleView = titleLbl;
    [self appointmentDetailsApi];
}

-(void)updateFrame{
    
    reasonValLbl.text = [apptArray valueForKey:@"reason"];
    emailValLbl.text = [apptArray valueForKey:@"email"];
    dateStr = [apptArray valueForKey:@"apptDate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"dd MMM yy"];
    dateStr = [dateFormat stringFromDate:date];
    dateValLbl.text =dateStr;
    
    [dateFormat setDateFormat:@"EEEE"];
    dateStr = [dateFormat stringFromDate:date];
    storeValLbl.text = [apptArray valueForKey:@"locationId"];
    NSString *text = [apptArray valueForKey:@"description"];
    txtSize = [text boundingRectWithSize:CGSizeMake(310.0f, 100.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Semibold" size:20.0]} context:nil];
    AppointDes.text = text;
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init] ;
    [timeFormat setDateFormat:@"HH:mm:ss.zzz"];

    NSDateFormatter *timeZoneFormat = [[NSDateFormatter alloc] init] ;
    [timeZoneFormat setDateFormat:@"hh:mm a"];
    [timeZoneFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

    NSString *datstTime = [apptArray valueForKey:@"endTime"];
    NSDate *datetoStrtime = [timeFormat dateFromString:datstTime];
    NSString *startTime = [timeZoneFormat stringFromDate:datetoStrtime];
    
    NSString *dateEndTime = [apptArray valueForKey:@"startTime"];
    NSDate *datetoEndtime = [timeFormat dateFromString:dateEndTime];
    NSString *endTime = [timeZoneFormat stringFromDate:datetoEndtime];

    strtimeLbl.text = [NSString stringWithFormat:@"%@-%@",endTime,startTime];

    reasonLbl.frame = CGRectMake(10,15,150, 30);
    reasonValLbl.frame = CGRectMake(160,15, 150, 30);
    
    emailLbl.frame=CGRectMake(10, reasonLbl.frame.size.height+reasonLbl.frame.origin.y,110, 50);
    emailValLbl.frame=CGRectMake(120, reasonLbl.frame.size.height+reasonLbl.frame.origin.y,200, 50);
    
    dateLbl.frame = CGRectMake(10, emailLbl.frame.origin.y + emailLbl.frame.size.height,110, 30);
    dateValLbl.frame = CGRectMake(120, emailLbl.frame.origin.y + emailLbl.frame.size.height,200, 30);
    
    timeLbl.frame = CGRectMake(10, dateLbl.frame.origin.y + dateLbl.frame.size.height,110, 30);
    strtimeLbl.frame = CGRectMake(120, dateLbl.frame.origin.y + dateLbl.frame.size.height,200, 30);
    
    storeLbl.frame = CGRectMake(10, timeLbl.frame.origin.y + timeLbl.frame.size.height,110, 30);
    storeValLbl.frame = CGRectMake(120, timeLbl.frame.origin.y + timeLbl.frame.size.height,200, 30);
    
    AppointLbl.frame = CGRectMake(10, storeLbl.frame.origin.y + storeLbl.frame.size.height, 110, 30);
    
    AppointDes.frame = CGRectMake(120, storeLbl.frame.origin.y + storeLbl.frame.size.height+5, 200, txtSize.size.height);
    
    
    appLbl.frame = CGRectMake(5, AppointDes.frame.size.height+AppointDes.frame.origin.y+10, 310, 20);
    
    if (IS_IPHONE4) {
        
        productTableView.frame=CGRectMake(10,appLbl.frame.size.height+appLbl.frame.origin.y,300,150);
        
    }else{
        
        productTableView.frame=CGRectMake(10,appLbl.frame.size.height+appLbl.frame.origin.y+5,300,150);
        
    }
    appDeletBtn.frame=CGRectMake(60,productTableView.frame.origin.y+productTableView.frame.size.height+5,200,35);
}

- (void)menuBtnAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
-(void)backBtnAct{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (apptItemArray.count==0) {
        tableView.hidden=YES;
        return 0;
        
    }else{
        notifLbl.hidden=YES;
        tableView.hidden=NO;
        return apptItemArray.count;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame=CGRectMake(50, 5, 200, 140);
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor=[UIColor whiteColor];
//    colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1
    if ([[apptItemArray objectAtIndex:indexPath.row]valueForKey:@"mainImageId"] != (id) [NSNull null] && ![[[apptItemArray objectAtIndex:indexPath.row]valueForKey:@"mainImageId"]  isEqual: @""]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[apptItemArray objectAtIndex:indexPath.row]valueForKey:@"mainImageId"]]]
                      placeholderImage:[UIImage imageNamed:@"shirt_ref"]];
    }else{
        imageView.image = [UIImage imageNamed:@"shirt_ref"];
    }
    
    UIView *detailView = [[UIView alloc]init];
    detailView.backgroundColor = [UIColor blackColor];
    detailView.layer.opacity = 0.6;
    [cell addSubview:detailView];
    
    UILabel *productName = [[UILabel alloc]init];
    productName.text=[[apptItemArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    productName.textAlignment = NSTextAlignmentCenter;
    productName.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    productName.textColor = [UIColor whiteColor];
    [detailView addSubview:productName];
    
    detailView.frame = CGRectMake(0, 100, 300, 50);
    productName.frame = CGRectMake(25, 0, 250, 25);
    
    
    cell.layer.borderWidth=0.6f;
    cell.layer.borderColor=[[UIColor grayColor]CGColor];
    
    [cell addSubview:imageView];
    [cell sendSubviewToBack:imageView];
    
    return cell;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 101) {
        AppointmentViewController *appObj=[[AppointmentViewController alloc]init];
        [self.navigationController pushViewController:appObj animated:YES];
    }else{
        if (buttonIndex==0) {
            [self cancelAppointment];
        }
    }
}

-(void)appointmentDetailsApi{
    /*
     Payload -
     {
     "appointmentId":"084c04d1-994a-47cf-bbd0-9862552ccca8"
     }
     */
    
    //
    //    apptArray = [[NSMutableArray alloc]initWithCapacity:0];
    //    apptArray = [delegate.dataBaseObj readAppointment];
    //
    //    [apptArray sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
    //        return [a[@"apptDate"] compare:b[@"apptDate"]];
    //    }];
    
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:appId,@"appointmentId",nil];
    
    [activityIndicator showActivityIndicator];
    [APIservice getAppointmentDetailsWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                if ([[resultDic allKeys] containsObject:@"data"])
                    NSLog(@"%@", resultDic);
                appDetailDict = [[resultDic valueForKey:@"data"]mutableCopy];
                apptArray = [appDetailDict valueForKey:@"appointmentObj"];
                apptItemArray = [appDetailDict valueForKey:@"appointmentItemList"];
                
                [self updateFrame];
                [productTableView reloadData];
            }
            else
            {
                
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

-(void)cancelAppointment{
    /*http://apparelqa.ovcdemo.com:8080/POSMClient/json/process/execute/CancelAppointment
     Payload -
     {
     "username": "eCommerce",
     "password": "changeme",
     "deviceId": "dUUID",
     "source": "external",
     "data":
     { "apptId":"0b04a2e1-a5b6-4100-8bd8-cd5d071acc73", "cancelReason":"Decided not to buy" }
     }
     Response - {
     data: {}
     }*/
    
    appointmentApi=1;
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:appId,@"apptId", @"Decided not to buy", @"cancelReason",nil];
    [activityIndicator showActivityIndicator];
    
    [APIservice cancellAppointmentDetailsWithCompletionBlock:^(NSDictionary *resultDic) {
    [activityIndicator hideActivityIndicator];
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                if ([[resultDic allKeys] containsObject:@"data"])
                    NSLog(@"%@", resultDic);
                UIAlertView *alrview=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Appointement was sucessfully deleted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alrview.tag = 101;
                [alrview show];
            }
            else
            {
                
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


-(void)deleteAct{
    UIAlertView *alrview=[[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you sure you want to delete the %@ appointment?",dateValLbl.text] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alrview.tag=15;
    [alrview show];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
