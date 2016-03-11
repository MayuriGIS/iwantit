//
//  AvailableAppointViewController.m
//  OVC-MOBILE
//
//  Created by macs on 22/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "AvailableAppointViewController.h"

@interface AvailableAppointViewController (){
    
    UITextField *zipTxt;
    UITextView *reasonTxt;
    UIButton *backBtn,*addBtn,*sideMenuBtn,*findNearBtn,*nextBtn,*creatApptBtn,*dateBtn,*closeBtn,*temBtn,*zipSearBtn;
    UILabel *titleLbl,*reasonBtnLbl,*dateBtnLbl;
    NSInteger selectedIndex;
    UITableView *appTimeTblView;
    UIColor *backColor,*maxColor,*textColor,*titColor,*lineColor,*borderColor,*titBackcolor,*btnColor;
    UIScrollView *scrollView;
    UIView *view,*view2section,*view3,*pickerView, *view4section;
    
    UIPickerView *myPickerView;
    NSArray *pickerArray,*reasonArray, *timeArr;
    NSInteger picker_num;
    UIDatePicker *dateObj;
    BOOL btnSelected;
    
}

@end

@implementation AvailableAppointViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    activityIndicator = [[ActivityIndicatorController alloc] init];
    [activityIndicator initWithViewController:self.navigationController];

    APIservice = [[CommonWebServices alloc] init];
    APIservice.delegate = self;
    APIservice.activityIndicator = activityIndicator;
    
    
    btnSelected=YES;
    selectedIndex = 0;
    picker_num = 0;
    maxColor = [UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1];
    backColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    textColor = [UIColor whiteColor];
    titColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    titBackcolor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f blue:99.0f/255.0f alpha:1];
    
    lineColor = [UIColor colorWithRed:212.0f/255.0f green:212.0f/255.0f blue:212.0f/255.0f alpha:1];
    borderColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1];
    btnColor = [UIColor colorWithRed:200.0f/255.0f green:239.0f/255.0f blue:255.0f/255.0f alpha:1];
    
    pickerArray = [[NSArray alloc]initWithObjects:
                   @[@"OvcStore",@"+81 1988 3600",@"Waseda Dori"],
                   @[@"Nakano",@"+81 1988 3600",@"Waseda Dori"],
                   @[@"Shinbashi",@"+81 4649 8891",@"Hibiya Dori"],
                   @[@" Cerulean Tower",@"+81 5141 3298",@"Shibuya"],nil];
    
    reasonArray = [[NSArray alloc]initWithObjects:@"Training",
                   @"Consultation",@"Repair",@"Personal Shopping", nil];
    
    timeArr = [[NSArray alloc]initWithObjects:@"09:30 to 10:30",@"10:30 to 11:30",@"11:30 to 12:30",@"12:30 to 13:30",@"13:30 to 14:30",@"14:30 to 15:30",@"15:30 to 16:30",@"16:30 to 17:30",@"17:30 to 18:30",@"18:30 to 19:30",@"19:30 to 20:30",@"20:30 to 21:30", nil];
    
    NSString *timeStr = [timeArr objectAtIndex:0];
    NSArray *tempArr = [timeStr componentsSeparatedByString:@" to "];
    startTime = [tempArr objectAtIndex:0];
    endTime = [tempArr objectAtIndex:1];
    
    
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
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    view = [[UIView alloc]init];
    view.frame = CGRectMake(0,0,320,300);
    view.backgroundColor = backColor;
    [scrollView addSubview:view];
    
    UILabel *findStoreLbl = [[UILabel alloc]init];
    findStoreLbl.text = @"  Find a Store";
    findStoreLbl.textColor = titColor;
    findStoreLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    findStoreLbl.backgroundColor = backColor;
    [view addSubview:findStoreLbl];
    
    UILabel *zipLbl = [[UILabel alloc]init];
    zipLbl.backgroundColor = titBackcolor;
    zipLbl.textColor = textColor;
    zipLbl.text = @"  Postcode / Town";
    zipLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [view addSubview:zipLbl];
    
    UIView *zipView = [[UIView alloc]init];
    zipView.backgroundColor = [UIColor whiteColor];
    zipView.layer.borderColor = [borderColor CGColor];
    zipView.layer.borderWidth = 0.5f;
    [view addSubview:zipView];
    
    zipTxt = [[UITextField alloc]init];
    zipTxt.delegate = self;
    zipTxt.backgroundColor = [UIColor clearColor];
    zipTxt.placeholder = @"Enter zip code";
    zipTxt.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [zipView addSubview:zipTxt];
    
    zipSearBtn = [[UIButton alloc]init];
    [zipSearBtn setTitle:@"SEARCH" forState:UIControlStateNormal];
    zipSearBtn.layer.cornerRadius = 5.0f;
    zipSearBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
    zipSearBtn.backgroundColor = btnColor;
    [zipSearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [zipSearBtn addTarget:self action:@selector(findBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:zipSearBtn];
    
    UIView *dummy_Line_view3 = [[UILabel alloc]init];
    dummy_Line_view3.backgroundColor = maxColor;
    [view addSubview:dummy_Line_view3];
    
    UILabel *dummyLbl = [[UILabel alloc]init];
    dummyLbl.text = @"or";
    dummyLbl.textAlignment = NSTextAlignmentCenter;
    dummyLbl.font = [UIFont fontWithName:@"Kailasa" size:12.0];
    dummyLbl.backgroundColor = backColor;
    [view addSubview:dummyLbl];
    
    findNearBtn = [[UIButton alloc]init];
    [findNearBtn setTitle:@"FIND STORES NEAR ME" forState:UIControlStateNormal];
    findNearBtn.layer.cornerRadius = 5.0f;
    findNearBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
    findNearBtn.backgroundColor = btnColor;
    [findNearBtn addTarget:self action:@selector(findBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [findNearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:findNearBtn];
    
    UIImageView *findNearImgLbl = [[UIImageView alloc]init];
    findNearImgLbl.image = [UIImage imageNamed:@"location_icon"];
    [findNearBtn addSubview:findNearImgLbl];
    
    findStoreLbl.frame = CGRectMake(0, 0, 320, 35);
    zipLbl.frame = CGRectMake(0,findStoreLbl.frame.origin.y + findStoreLbl.frame.size.height,320,35);
    zipView.frame = CGRectMake(0, zipLbl.frame.origin.y + zipLbl.frame.size.height, 320, 45);
    zipTxt.frame = CGRectMake(5, 0, 310, 45);
    zipSearBtn.frame = CGRectMake(90, zipView.frame.origin.y + zipView.frame.size.height+20, 140, 35);
    dummy_Line_view3.frame = CGRectMake(5, zipSearBtn.frame.origin.y + zipSearBtn.frame.size.height + 20, 310, 1);
    dummyLbl.frame = CGRectMake(150, dummy_Line_view3.frame.size.height +dummy_Line_view3.frame.origin.y-12, 20, 20);
    
    findNearBtn.frame = CGRectMake(10, dummyLbl.frame.origin.y + dummyLbl.frame.size.height+20, 300, 46);
    findNearImgLbl.frame = CGRectMake(35, 10, 21, 26);
    
    //    ---------------- Select Store--------------
    
    view2section = [[UIView alloc]init];
    view2section.backgroundColor = backColor;
    view2section.hidden = YES;
    [scrollView addSubview:view2section];
    
    UILabel *storeLbl = [[UILabel alloc]init];
    storeLbl.backgroundColor = titBackcolor;
    storeLbl.text = @"  Store List";
    storeLbl.textColor = [UIColor whiteColor];
    storeLbl.layer.borderColor = [borderColor CGColor];
    storeLbl.layer.borderWidth = 0.5f;
    storeLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [view2section addSubview:storeLbl];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    storeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,250,310,200) collectionViewLayout:layout];
    [storeCollectionView setDataSource:self];
    [storeCollectionView setDelegate:self];
    storeCollectionView.backgroundColor = [UIColor clearColor];
    [storeCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [view2section addSubview:storeCollectionView];
    
    view2section.frame = CGRectMake(0,view.frame.origin.y+view.frame.size.height-15,320,235);
    storeLbl.frame = CGRectMake(0, 0, 320, 35);
    storeCollectionView.frame = CGRectMake(5, storeLbl.frame.origin.y+storeLbl.frame.size.height - 0.5f, 310, 200);
    
    
    //    -------- Scedule appointment------------
    
    view4section = [[UIView alloc]init];
    view4section.backgroundColor = backColor;
    [scrollView addSubview:view4section];
    view4section.hidden = YES;
    
    UILabel *reasonLbl = [[UILabel alloc]init];
    reasonLbl.text = @"  Select Reason for Appointment";
    reasonLbl.textColor = [UIColor whiteColor];
    reasonLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    reasonLbl.backgroundColor = titBackcolor;
    [view4section addSubview:reasonLbl];
    
    UIButton *reasonBtn = [[UIButton alloc]init];
    reasonBtn.backgroundColor = [UIColor whiteColor];
    reasonBtn.layer.borderColor = [borderColor CGColor];
    reasonBtn.layer.borderWidth = 0.5f;
    reasonBtn.tag = 102;
    [reasonBtn addTarget:self action:@selector(pickerAct:) forControlEvents:UIControlEventTouchUpInside];
    [reasonBtn setTitleColor:maxColor forState:UIControlStateNormal ];
    [view4section addSubview:reasonBtn];
    
    UIImageView *reasonBtnImgIcon = [[UIImageView alloc]init];
    reasonBtnImgIcon.image = [UIImage imageNamed:@"dropdown_arrow"];
    [reasonBtn addSubview:reasonBtnImgIcon];
    
    reasonBtnLbl = [[UILabel alloc]init];
    reasonBtnLbl.backgroundColor = [UIColor clearColor];
    reasonBtnLbl.text = @"Training";
    reasonBtnLbl.textColor = [UIColor grayColor];
    reasonBtnLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [reasonBtn addSubview:reasonBtnLbl];
    
    UILabel *specReasonLbl = [[UILabel alloc]init];
    specReasonLbl.text = @"  Specify Reason";
    specReasonLbl.textColor = titColor;
    specReasonLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    specReasonLbl.backgroundColor = backColor;
    [view4section addSubview:specReasonLbl];
    
    reasonTxt = [[UITextView alloc]init];
    reasonTxt.delegate = self;
    reasonTxt.backgroundColor = [UIColor whiteColor];
    reasonTxt.layer.borderWidth = 1.0f;
    reasonTxt.layer.borderColor = [maxColor CGColor];
    reasonTxt.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [view4section addSubview:reasonTxt];
    
    nextBtn =[[UIButton alloc]init];
    [nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    nextBtn.backgroundColor=btnColor;
    [nextBtn addTarget:self action:@selector(nextAct) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view4section addSubview:nextBtn];
    
    view4section.frame = CGRectMake(0,view2section.frame.origin.y+view2section.frame.size.height,320,270);
    reasonLbl.frame = CGRectMake(0, 0 , 320,35);
    reasonBtn.frame = CGRectMake(0, reasonLbl.frame.origin.y+reasonLbl.frame.size.height-0.5f,320,35);
    reasonBtnImgIcon.frame = CGRectMake(300,13, 13, 8);
    reasonBtnLbl.frame = CGRectMake(10,0,300,35);
    
    specReasonLbl.frame = CGRectMake(0,reasonBtn.frame.origin.y+reasonBtn.frame.size.height , 320,35);
    reasonTxt.frame = CGRectMake(05,specReasonLbl.frame.origin.y+specReasonLbl.frame.size.height,310,100);
    nextBtn.frame = CGRectMake(70,reasonTxt.frame.origin.y+reasonTxt.frame.size.height+15, 180,45);
    
    /*   ----------------Select Date View-------------- */
    
    view3 = [[UIView alloc]init];
    view3.backgroundColor = backColor;
    view3.hidden = YES;
    [scrollView addSubview:view3];
    
    UILabel *wishLbl = [[UILabel alloc]init];
    wishLbl.text = @"  When do you want to come in ?";
    wishLbl.textColor = titColor;
    wishLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    wishLbl.backgroundColor = backColor;
    [view3 addSubview:wishLbl];
    
    UILabel *dateLbl = [[UILabel alloc]init];
    dateLbl.text = @"  Select Date";
    dateLbl.textColor = titColor;
    dateLbl.textColor = [UIColor whiteColor];
    dateLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    dateLbl.backgroundColor = titBackcolor;
    [view3 addSubview:dateLbl];
    
    dateBtn = [[UIButton alloc]init];
    dateBtn.tag = 103;
    dateBtn.backgroundColor = [UIColor whiteColor];
    dateBtn.layer.borderColor = [borderColor CGColor];
    dateBtn.layer.borderWidth = 0.5f;
    [dateBtn setTitleColor:maxColor forState:UIControlStateNormal ];
    [dateBtn addTarget:self action:@selector(dateAct) forControlEvents:UIControlEventTouchUpInside];
    dateBtn.selected = YES;
    [view3 addSubview:dateBtn];
    
    dateBtnLbl = [[UILabel alloc]init];
    dateBtnLbl.backgroundColor = [UIColor clearColor];
    
    NSDate *date =[NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"dd MMM yyyy"];
    dateBtnLbl.text=[df stringFromDate:date];
    
    dateBtnLbl.textColor = [UIColor lightGrayColor];
    dateBtnLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [dateBtn addSubview:dateBtnLbl];
    
    UIImageView *dateImgIcon = [[UIImageView alloc]init];
    dateImgIcon.image = [UIImage imageNamed:@"calendar_icon"];
    [dateBtn addSubview:dateImgIcon];
    
    UILabel *timeLbl = [[UILabel alloc]init];
    timeLbl.text = @"  Select available times";
    timeLbl.textColor = textColor;
    timeLbl.backgroundColor = titBackcolor;
    timeLbl.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    [view3 addSubview:timeLbl];
    
    appTimeTblView = [[UITableView alloc]init];
    appTimeTblView.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:216.0f/255.0f];
    appTimeTblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appTimeTblView.delegate = self;
    appTimeTblView.dataSource = self;
    [view3 addSubview:appTimeTblView];
    
    creatApptBtn = [[UIButton alloc]init];
    [creatApptBtn setTitle:@"CREATE APPOINTMENT" forState:UIControlStateNormal];
    creatApptBtn.layer.cornerRadius = 5.0f;
    creatApptBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
    creatApptBtn.backgroundColor = btnColor;
    [creatApptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [creatApptBtn addTarget:self action:@selector(createBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:creatApptBtn];
    
    view3.frame = CGRectMake(0, view4section.frame.size.height + view4section.frame.origin.y, 320, 410);
    wishLbl.frame = CGRectMake(0, 0, 320, 45);
    dateLbl.frame = CGRectMake(0, wishLbl.frame.origin.y + wishLbl.frame.size.height, 320, 35);
    
    dateBtn.frame = CGRectMake(0, dateLbl.frame.origin.y + dateLbl.frame.size.height ,320, 35);
    dateBtnLbl.frame = CGRectMake(10, 0, 300, 35);
    dateImgIcon.frame = CGRectMake(290, 10, 15, 17);
    
    timeLbl.frame = CGRectMake(0, dateBtn.frame.origin.y + dateBtn.frame.size.height,320, 35);
    
    appTimeTblView.frame = CGRectMake(0, timeLbl.frame.size.height + timeLbl.frame.origin.y, 320, 200);
    creatApptBtn.frame = CGRectMake(70, appTimeTblView.frame.origin.y + appTimeTblView.frame.size.height+10, 180, 45);
    
    //    ------------ Picker View------------------
    
    pickerView = [[UIView alloc]init];
    pickerView.backgroundColor = [UIColor lightGrayColor];
    pickerView.hidden = YES;
    [self.view addSubview:pickerView];
    
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.backgroundColor = [UIColor whiteColor];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden = YES;
    [pickerView addSubview:myPickerView];
    
    closeBtn = [[UIButton alloc]init];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.frame = CGRectMake(275,-10,50,50);
    [closeBtn setImage:[UIImage imageNamed:@"cancel-icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(pickerAct:) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:closeBtn];
    
    //--------DATE PICKER ACTION-----------
    
    dateObj = [[UIDatePicker alloc]init];
    dateObj.date = [NSDate date];
    dateObj.backgroundColor = [UIColor whiteColor];
    dateObj.minimumDate = [NSDate date];
    dateObj.datePickerMode = UIDatePickerModeDate;
    [dateObj addTarget:self action:@selector(dateChang:) forControlEvents:UIControlEventValueChanged];
    dateObj.hidden=YES;
    [pickerView addSubview:dateObj];
    
    
    if (IS_IPHONE4) {
        scrollView.frame = CGRectMake(0,0,320,480);
        pickerView.frame = CGRectMake(0,234,320,246);
        myPickerView.frame = CGRectMake(0,30,320,216);
        dateObj.frame=CGRectMake(0,30,320,216);
        
        
    }else{
        scrollView.frame = CGRectMake(0,0,320,505);
        pickerView.frame = CGRectMake(0,327,320,246);
        myPickerView.frame = CGRectMake(0,30,320,216);
        dateObj.frame=CGRectMake(0,30,320,216);
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0,0,200,44);
    titleLbl.font = [UIFont fontWithName:@"Kailasa" size:18.0];
    titleLbl.text = @"Create Appointment";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    self.navigationItem.titleView = titleLbl;
}

-(void)backBtnAct{
    if ([delegate.naviPath  isEqual: @"wishlist"]) {
        
        delegate.naviPath=@"";
        MyWishViewController *mywishObj=[[MyWishViewController alloc]init];
        [self.navigationController pushViewController:mywishObj animated:NO];
        
    }else if ([delegate.naviPath isEqual: @"shopperview"]){
        
        delegate.naviPath=@"";
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)menuBtnAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark-Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=[UIColor colorWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:216.0f/255.0f];
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *AppointBackView = [[UIView alloc]init];
    AppointBackView.frame = CGRectMake(0, 0, 320,45);
    AppointBackView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1];
    
    
    UIImageView *radioBtn = [[UIImageView alloc]init];
    radioBtn.userInteractionEnabled = YES;
    
    if (selectedIndex == indexPath.row) {
        radioBtn.image = [UIImage imageNamed:@"radiobtn_selbtn"];
    }else{
        radioBtn.image = [UIImage imageNamed:@"radiobtn_unselbtn"];
    }
    radioBtn.frame = CGRectMake(10,13,18,18);
    [AppointBackView addSubview:radioBtn];
    
    
    UILabel *dateLbl = [[UILabel alloc]init];
    dateLbl.tag = 200 + indexPath.row;
    dateLbl.text = [timeArr objectAtIndex:indexPath.row];
    dateLbl.frame = CGRectMake(20,0,280, 45);
    dateLbl.textAlignment = NSTextAlignmentCenter;
    dateLbl.textColor = [UIColor lightGrayColor];
    dateLbl.font = [UIFont fontWithName:@"Kailasa" size:12.0];
    [AppointBackView addSubview:dateLbl];
    [cell addSubview:AppointBackView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    NSString *timeStr = [timeArr objectAtIndex:indexPath.row];
    NSArray *tempArr = [timeStr componentsSeparatedByString:@" to "];
    startTime = [tempArr objectAtIndex:0];
    endTime = [tempArr objectAtIndex:1];
    scrollView.contentSize=CGSizeMake(320,view4section.frame.origin.y+view4section.frame.size.height+self.view.frame.size.height+200);
    
    NSLog(@"startTime: %@, endTime: %@",startTime,endTime);
    [appTimeTblView reloadData];
}


#pragma mark - UICollectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return pickerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor blackColor].CGColor;
    [cell addSubview:backView];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"StoreOvcHome.jpeg"];
    [backView addSubview:imgView];
    
    UILabel *storeName = [[UILabel alloc]init];
    storeName.text = [[pickerArray objectAtIndex:indexPath.row]objectAtIndex:0];
    storeName.font = [UIFont fontWithName:@"Kailasa" size:12.0];
    storeName.numberOfLines = 0;
    storeName.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:storeName];
    
    UILabel *phoneNum = [[UILabel alloc]init];
    phoneNum.text = [[pickerArray objectAtIndex:indexPath.row]objectAtIndex:1];
    phoneNum.font = [UIFont fontWithName:@"Kailasa" size:12.0];
    phoneNum.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:phoneNum];
    
    UILabel *storeLoc = [[UILabel alloc]init];
    storeLoc.text = [[pickerArray objectAtIndex:indexPath.row]objectAtIndex:2];
    storeLoc.textAlignment = NSTextAlignmentCenter;
    storeLoc.font = [UIFont fontWithName:@"Kailasa" size:10.0];
    [backView addSubview:storeLoc];
    
    
    backView.frame = CGRectMake(0, 5,150, 90);
    imgView.frame = CGRectMake(5,5,60, 60);
    storeName.frame = CGRectMake(65,5,85,40);
    storeLoc.frame = CGRectMake(65,35,85,25);
    phoneNum.frame = CGRectMake(10,62, 130,28);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 90);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    view4section.hidden = NO;
    scrollView.contentSize=CGSizeMake(320,view4section.frame.origin.y+view4section.frame.size.height+10);
    if (IS_IPHONE4) {
        scrollView.contentSize=CGSizeMake(320,view4section.frame.origin.y+view4section.frame.size.height+100);
        
        [UIView animateWithDuration:0.55 animations:^{scrollView.contentOffset=CGPointMake(0,view2section.frame.origin.y+view2section.frame.size.height);}];
        
    }else{
        
        [UIView animateWithDuration:0.55 animations:^{scrollView.contentOffset=CGPointMake(0,view2section.frame.origin.y+view2section.frame.size.height);}];
    }
}

-(void)findBtnAct{
    
    [zipTxt resignFirstResponder];
    [reasonTxt resignFirstResponder];
    
    findNearBtn.alpha = 0.6f;
    zipSearBtn.alpha = 0.6f;
    findNearBtn.userInteractionEnabled=NO;
    zipSearBtn.userInteractionEnabled=NO;
    view2section.hidden = NO;
    scrollView.contentSize = CGSizeMake(320,view2section.frame.origin.y+view2section.frame.size.height+20);
    
    if (IS_IPHONE4) {
        
        scrollView.contentSize = CGSizeMake(320,view2section.frame.origin.y+view2section.frame.size.height+100);
        
        [UIView animateWithDuration:0.55 animations:^{
            
            scrollView.contentOffset=CGPointMake(0,view.frame.origin.y+view.frame.size.height);
        }];
        
    }else{
        
        [UIView animateWithDuration:0.55 animations:^{
            
            scrollView.contentOffset=CGPointMake(0,view.frame.origin.y+view.frame.size.height-100);
        }];
    }
}

-(void)nextAct{
    [zipTxt resignFirstResponder];
    [reasonTxt resignFirstResponder];
    
    nextBtn.alpha = 0.6f;
    view3.hidden = NO;
    scrollView.contentSize = CGSizeMake(320,view3.frame.origin.y+view3.frame.size.height+20);
    if (IS_IPHONE4) {
        scrollView.contentSize = CGSizeMake(320,view3.frame.origin.y+view3.frame.size.height+100);
        
        [UIView animateWithDuration:0.55 animations:^{scrollView.contentOffset=CGPointMake(0,view4section.frame.origin.y+view4section.frame.size.height);}];
    }else{
        
        [UIView animateWithDuration:0.55 animations:^{scrollView.contentOffset=CGPointMake(0,view4section.frame.origin.y+view4section.frame.size.height);}];
    }
}

-(void)createBtnAct{
    
    if ([reasonTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Title" message:@"Enter Reason" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self addAppoinmentApi];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            [self saveAct];
        }
    }
}

#pragma mark - Appointment Api

- (void)addAppoinmentApi{
    /*
     http://ibmwcs.ovcdemo.com:8080/json/process/execute/CreateAppointment
     
     Create Appointment :
     {
     "appointmentObj":{
     "status":"New",
     "startTime":"13:00:00",
     "apptDate":"2016-01-13",
     "email":"abhijit@oneviewcommerce.com",
     "loyaltyId":"abhijit@oneviewcommerce.com",
     "loyaltyFName":"Abhijit",
     "loyaltyLName":"killedar",
     "description":"aa",
     "locationId":"OvcStore",
     "retailerId":"defaultRetailer",
     "reason":"Personal Shopping",
     "endTime":"13:20:00"
     },
     "appointmentItemList":[
     {
     "sku":"300026672"
     }
     ],
     "ovclid":"abhijit@oneviewcommerce.com"
     }*/
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [dateFormat dateFromString:dateBtnLbl.text];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    dateStr = [dateFormat stringFromDate:date];
    
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:USERDETAIL];

    NSMutableDictionary *appointmentObjDict = [[NSMutableDictionary alloc]init];
    [appointmentObjDict setValue:@"New" forKey:@"status"];
    [appointmentObjDict setValue:startTime forKey:@"startTime"];
    [appointmentObjDict setValue:dateStr forKey:@"apptDate"];
    [appointmentObjDict setValue:[userDetail valueForKey:@"email"] forKey:@"email"];
    [appointmentObjDict setValue:[userDetail valueForKey:@"loyaltyId"] forKey:@"loyaltyId"];
    [appointmentObjDict setValue:[userDetail valueForKey:@"firstName"] forKey:@"loyaltyFName"];
    [appointmentObjDict setValue:[userDetail valueForKey:@"lastName"] forKey:@"loyaltyLName"];
    [appointmentObjDict setValue:reasonTxt.text forKey:@"description"];
    [appointmentObjDict setValue:@"OvcStore" forKey:@"locationId"];
    [appointmentObjDict setValue:@"defaultRetailer" forKey:@"retailerId"];
    [appointmentObjDict setValue:reasonBtnLbl.text forKey:@"reason"];
    [appointmentObjDict setValue:endTime forKey:@"endTime"];
    [appointmentObjDict setValue:reasonTxt.text forKey:@"description"];
    
    NSMutableDictionary *productDict;
    NSArray *productArray;
    if ([delegate.productId isEqualToString:@""]) {
        
    }else{
        productDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"1312564",@"sku", nil];
        productArray = [[NSArray alloc]initWithObjects:productDict, nil];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    [data setValue:appointmentObjDict forKey:@"appointmentObj"];
    [data setValue:productArray forKey:@"appointmentItemList"];
    [data setValue:[userDetail valueForKey:@"loyaltyId"] forKey:@"ovclid"];
    
    [activityIndicator showActivityIndicator];
    
    [APIservice createAppointmentWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                if ([[resultDic objectForKey:@"errorCode"]isEqualToString:@"InternalError"]) {
                    UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Can't Create Appointment" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil, nil];
                    [alrView show];
                }else{
                    UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Appointment Confirmation" message:[NSString stringWithFormat:@"Congratulation ! Your appointment at the OvcStore , Store address was successfully Scheduled for %@ \n %@ to %@",dateStr,startTime,endTime] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    alrView.tag = 10;
                    [alrView show];
                }
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Inserting Data"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
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


#pragma mark - Text field delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    view2section.hidden = YES;
    view3.hidden = YES;
    view4section.hidden = YES;
    findNearBtn.alpha = 1.0f;
    zipSearBtn.alpha = 1.0f;
    nextBtn.alpha = 1.0f;
    scrollView.contentSize = CGSizeMake(320, view.frame.origin.y + view.frame.size.height+10);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    creatApptBtn.alpha=1.0f;
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (IS_IPHONE4) {
        
        scrollView.contentOffset=CGPointMake(0,reasonTxt.frame.origin.y+reasonTxt.frame.size.height+400);
        
    }else{
        
        scrollView.contentOffset=CGPointMake(0,reasonTxt.frame.origin.y+reasonTxt.frame.size.height+300);
    }
    return YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Picker View Data source
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [reasonArray count];
    
}


#pragma mark- Picker View Delegate

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    reasonBtnLbl.text=[NSString stringWithFormat:@"%@",[reasonArray objectAtIndex:row]];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [reasonArray objectAtIndex:row];
}


#pragma mark- Function
-(void)pickerAct:(UIButton *)Btn{
    
    if (btnSelected==YES) {
        dateObj.hidden=YES;
        myPickerView.hidden=NO;
        pickerView.hidden=NO;
        btnSelected=NO;
        
    }else{
        myPickerView.hidden=YES;
        pickerView.hidden=YES;
        btnSelected=YES;
        
    }
    
}

-(void)dateAct{
    
    
    if (btnSelected==YES) {
        
        pickerView.hidden=NO;
        dateObj.hidden=NO;
        btnSelected=NO;
        
    }else{
        pickerView.hidden=YES;
        dateObj.hidden=YES;
        btnSelected=YES;
        
    }
    
    
}

-(void)dateChang:(UIDatePicker *)sender{
    
    
    UIDatePicker *dateObjj=(UIDatePicker *)sender;
    NSDate *date =[dateObjj date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"dd MMM yyyy"];
    dateBtnLbl.text=[df stringFromDate:date];
    
}

-(void)saveAct{
    AppointmentViewController *appViewObj=[[AppointmentViewController alloc]init];
    [self.navigationController pushViewController:appViewObj animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.view removeFromSuperview];
    [view2section removeFromSuperview];
    [view removeFromSuperview];
    
    delegate.naviPath=@"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
