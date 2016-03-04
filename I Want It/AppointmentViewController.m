//
//  AppointmentViewController.m
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "AppointmentViewController.h"
@interface AppointmentViewController (){
    UIButton *sideMenuBtn,*addBtn;
    UILabel *titleLbl;
    UIColor *backColor,*textColor,*titColor;
    UITableView *tableView;
    NSMutableArray *apptArray;
    int apiAction;
}

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    apiAction=0;
    
    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];

    APIservice = [[CommonWebServices alloc] init];
    APIservice.delegate = self;
    APIservice.activityIndicator = activityIndicator;

    
    
    apptArray = [[NSMutableArray alloc]initWithCapacity:0];
    textColor = [UIColor colorWithRed:59.0f/255.0f green:59.0f/255.0f blue:59.0f/255.0f alpha:1];
    titColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    backColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0f alpha: 1];
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    

    sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0,0,40,64);
    addBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    
    tableView = [[UITableView alloc]init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden=YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    if (IS_IPHONE4) {
        tableView.frame=CGRectMake(0,5, 320,410);
    }else{
        tableView.frame=CGRectMake(0,5, 320,505);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = NO;
    titleLbl = [[UILabel alloc]init];
    titleLbl.text = @"My Appointment";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.frame = CGRectMake(0,0,200,44);
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
    
    [self appointmentApi];
    
   /* if ([delegate isNetConnected]) {
        [self appointmentApi];
    }else{
        apptArray = [delegate.dataBaseObj readAppointment];
        tableView.hidden=NO;
        [tableView reloadData];
    }*/
}

-(void)menuBtnAction{
    self.menuContainerViewController.menuWidth = 80;
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)addBtnAct{
    AvailableAppointViewController *AvailObj=[[AvailableAppointViewController alloc]init];
    [self.navigationController pushViewController:AvailObj animated:YES];
}

#pragma mark UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (apptArray.count != 0) {
        return apptArray.count;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (apptArray.count != 0) {
        UIView *AppointBackView = [[UIView alloc]init];
        AppointBackView.frame = CGRectMake(05, 0, 310,90);
        AppointBackView.backgroundColor = [UIColor whiteColor];
        AppointBackView.layer.cornerRadius = 8.0f;
        AppointBackView.layer.masksToBounds = YES;
        
        UIView *dummyView = [[UIView alloc]init];
        dummyView.backgroundColor = textColor;
        [AppointBackView addSubview:dummyView];
        
        UILabel *dateLbl = [[UILabel alloc]init];
        dateLbl.textColor = [UIColor colorWithRed:33.0f/255.0f green:166.0f/255.0f  blue:146.0f/255.0f alpha:1];;
        dateLbl.textAlignment = NSTextAlignmentLeft;
        dateLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
        [AppointBackView addSubview:dateLbl];
        
        NSString *dateStr = [[apptArray objectAtIndex:indexPath.row]valueForKey:@"apptDate"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"dd MMM yy"];
        dateStr = [dateFormat stringFromDate:date];
        dateLbl.text =dateStr;
        
        NSString *datstTime = [[apptArray objectAtIndex:indexPath.row]valueForKey:@"endTime"];
        NSDateFormatter *dateFormatterstrt = [[NSDateFormatter alloc] init] ;
        [dateFormatterstrt setDateFormat:@"HH:mm:ss"];
        NSDate *datetoStrtime = [dateFormatterstrt dateFromString:datstTime];
        [dateFormatterstrt setDateFormat:@"hh:mm a"];
        NSString *startTime = [dateFormatterstrt stringFromDate:datetoStrtime];
        
        NSString *dats1 = [[apptArray objectAtIndex:indexPath.row]valueForKey:@"startTime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSDate *datetoTime = [dateFormatter dateFromString:dats1];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *endTime = [dateFormatter stringFromDate:datetoTime];
        
        UILabel *strtimeLbl = [[UILabel alloc]init];
        strtimeLbl.text = [NSString stringWithFormat:@"%@-%@",endTime,startTime];
        strtimeLbl.textColor = textColor;
        strtimeLbl.numberOfLines = 0;
        strtimeLbl.textAlignment = NSTextAlignmentLeft;
        strtimeLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
        [AppointBackView addSubview:strtimeLbl];
        
        UILabel *calDateLbl = [[UILabel alloc]init];
        [dateFormat setDateFormat:@"EEEE"];
        dateStr = [dateFormat stringFromDate:date];
        calDateLbl.text = dateStr;
        calDateLbl.textColor = textColor;
        calDateLbl.numberOfLines = 0;
        calDateLbl.textAlignment = NSTextAlignmentLeft;
        calDateLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
        [AppointBackView addSubview:calDateLbl];
        
        UILabel *storeLbl = [[UILabel alloc]init];
        storeLbl.text = [[apptArray objectAtIndex:indexPath.row]valueForKey:@"locationId"];
        storeLbl.textColor = [UIColor lightGrayColor];
        storeLbl.textAlignment = NSTextAlignmentRight;
        storeLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
        [AppointBackView addSubview:storeLbl];
        
        UILabel *reasonLbl = [[UILabel alloc]init];
        reasonLbl.numberOfLines = 0;
        reasonLbl.textColor = [UIColor darkGrayColor];
        reasonLbl.text = [[apptArray objectAtIndex:indexPath.row]valueForKey:@"reason"];
        reasonLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
        reasonLbl.textAlignment = NSTextAlignmentLeft;
        [AppointBackView addSubview:reasonLbl];
        
        UILabel *AppointDes = [[UILabel alloc]init];
        AppointDes.text = [[apptArray objectAtIndex:indexPath.row]valueForKey:@"description"];
        AppointDes.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
        AppointDes.numberOfLines = 3;
        AppointDes.textColor = [UIColor grayColor];
        AppointDes.textAlignment = NSTextAlignmentLeft;
        [AppointBackView addSubview:AppointDes];
        
        UIImageView *arrowImg = [[UIImageView alloc]init];
        arrowImg.frame = CGRectMake(295,40,8, 13);
        arrowImg.image = [UIImage imageNamed:@"side_arrow"];
        [AppointBackView addSubview:arrowImg];
        
        calDateLbl.frame = CGRectMake(5,05,90,20);
        dateLbl.frame = CGRectMake(5,30,95,25);
        strtimeLbl.frame = CGRectMake(5,55 ,125,25);
        dummyView.frame = CGRectMake(120,10,1,70);
        reasonLbl.frame = CGRectMake(125,05,170,20);
        AppointDes.frame = CGRectMake(125,25,160,40);
        storeLbl.frame = CGRectMake(125,65,180,20);
        
        [cell.contentView addSubview:AppointBackView];
        cell.backgroundColor = [UIColor clearColor];
        cell.userInteractionEnabled = YES;
    }else{
        if (indexPath.row == 1) {
            UILabel *noLbl = [[UILabel alloc]init];
            noLbl.text = @"No Results Found";
            noLbl.textAlignment = NSTextAlignmentCenter;
            noLbl.backgroundColor = [UIColor clearColor];
            noLbl.font = [UIFont boldSystemFontOfSize:15];
            noLbl.frame = CGRectMake(10, 100, 300, 30);
            [cell.contentView addSubview:noLbl];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    delegate.selectedIndex = indexPath.row;
    if ([delegate.naviPath isEqual:@"wishlist"]) {
        apiAction=1;
        NSLog(@"this is productId :%@",delegate.productId);
        NSLog(@"this is navigation from:%@",delegate.naviPath);
//        [self addItemtoAppointment];
    }else{
        AppointDetailViewController *AppDetailObj=[[AppointDetailViewController alloc]init];
        [self.navigationController pushViewController:AppDetailObj animated:YES];
    }
}

#pragma mark - Api Action

-(void)appointmentApi{
    /*
     http://ibmwcs.ovcdemo.com:8080/json/process/execute/GetCustomerAppointments
     GetCustomerAppointments :
     {
     "loyaltyId":"abhijit@oneviewcommerce.com",
     "email":"abhijit@oneviewcommerce.com",
     "retailerId":"defaultRetailer",
     "ovclid":"abhijit@oneviewcommerce.com"
     }
     */
    
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:USERDETAIL];

    NSDictionary *data = @{@"loyaltyId" : [userDetail valueForKey:@"loyaltyId"],
                           @"email" : [userDetail valueForKey:@"email"],
                           @"retailerId" : @"defaultRetailer",
                           @"ovclid": [userDetail valueForKey:@"email"]};

    [activityIndicator showActivityIndicator];
   
    [APIservice getAllAppointmentsWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray *tempArr = [[resultDic objectForKey:@"data"]objectForKey:@"appointmentList"];
                if ([tempArr count]!=0) {
                    [delegate.dataBaseObj deleteAppointmentTable];
                    [delegate.dataBaseObj insertAppointmentData:[[resultDic objectForKey:@"data"]objectForKey:@"appointmentList"]];
                    apptArray = [delegate.dataBaseObj readAppointment];
                    [apptArray sortUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
                        return [a[@"apptDate"] compare:b[@"apptDate"]];
                    }];
                }
                tableView.hidden=NO;
                [tableView reloadData];
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

-(void)addItemtoAppointment{
    /*
     http://demoqa.ovcdemo.com:8080/POSMClient/json/process/execute/UpdateAppointment
     {
         "username": "eCommerce",
         "password": "changeme",
         "deviceId": "dUUID",
         "source": "external",
         "data":{
     "apptEndTime":"14:00:00.000","apptDate":"2014-09-30","ovclid":"rajivpras.bits@gmail.com","apptStartTime":"13:30:00.000","apptDesc":"sdfgsdfgdsfg","appointmentItemList":[{"sku":"1992693"}],"apptId":"98e618c7-b405-4668-92cd-e992aaa1faaa"}
     }
     */
    
    
    NSMutableDictionary *proData=[NSMutableDictionary dictionaryWithObjectsAndKeys:delegate.productId,@"sku",nil];
    
    NSMutableArray *apptItem=[[NSMutableArray alloc]initWithObjects:proData, nil];
    NSMutableDictionary *userData=[NSMutableDictionary dictionaryWithObjectsAndKeys:[[apptArray objectAtIndex:delegate.selectedIndex]objectForKey:@"endTime"],@"apptEndTime",
                                   [[apptArray objectAtIndex:delegate.selectedIndex]objectForKey:@"apptDate"],@"apptDate",
                                   [[NSUserDefaults standardUserDefaults] stringForKey:@"userMail"],@"ovclid",
                                   [[apptArray objectAtIndex:delegate.selectedIndex]objectForKey:@"startTime"],@"apptStartTime",[[apptArray objectAtIndex:delegate.selectedIndex]objectForKey:@"description"],@"apptDesc",apptItem ,@"appointmentItemList",[[apptArray objectAtIndex:delegate.selectedIndex]objectForKey:@"id"],@"apptId",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    
    NSString *link = [NSString stringWithFormat:@"POSMClient/json/process/execute/UpdateAppointment"];
    
    [activityIndicator showActivityIndicator];
    [CommonWebServices postMethodWithUrl:link dictornay:data onSuccess:^(id responseObject)
     {
         [activityIndicator hideActivityIndicator];
         
         if ([CommonWebServices isWebResponseNotEmpty:responseObject])
         {
             if ([responseObject isKindOfClass:[NSDictionary class]])
             {
                 if ([delegate.naviPath isEqual:@"wishlist"]) {
                     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your product successfully added" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
                 NSLog(@"Appt List Data: %@",responseObject);
                 delegate.naviPath=@"";
                 
                 [tableView reloadData];
                 tableView.hidden=NO;
             }
             else
             {
             }
         }
         
     } onFailure:^(NSError *error)
     {
         [activityIndicator hideActivityIndicator];
         NSLog(@"Error Received : %@", error.localizedDescription);
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Reterive Data"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
         
     }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==300) {
        if (buttonIndex==0) {
            [self appointmentApi];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
