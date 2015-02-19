//
//  SearchViewController.m
//  OVC-MOBILE
//
//  Created by macs on 25/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController (){
    int selectedBtnIndex;
    BOOL isShow;
    UITableView *tableView;
    UIButton *sideMenuBtn,*existBtn,*newBtn;
    UILabel *titleLbl;
    int selectedIndex;
    UIActivityIndicatorView *indicatorView;
    UIView *popUpView;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"The shopper array:%@",[delegate.dataBaseObj readShopper]);
    selectedBtnIndex = -1;
    isSearch = NO;
    isShow = NO;
    self.view.backgroundColor=[UIColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f alpha:1];
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    self.menuContainerViewController.rightMenuViewController=nil;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    
    prodArray=[[NSMutableArray alloc]initWithCapacity:0];
    prodArray=[delegate.dataBaseObj readShopper];
    searchResults = [[NSMutableArray alloc]init];
    
    sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];

    UISearchBar *itemSearch = [[UISearchBar alloc]init];
    itemSearch.placeholder = @"item name/item code";
    itemSearch.frame = CGRectMake(0,0,320,50);
    itemSearch.barTintColor = [UIColor whiteColor];
    itemSearch.backgroundColor = [UIColor whiteColor];
    itemSearch.delegate = self;
    itemSearch.barTintColor = [UIColor whiteColor];
    [self.view addSubview:itemSearch];
    
    
    tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    popUpView = [[UIView alloc]init];
    popUpView.hidden = YES;
    popUpView.tag = 50;
    popUpView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.view addSubview:popUpView];
  
    existBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    existBtn.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];;
    [existBtn setTitle:@"Add to existing appoinment" forState:UIControlStateNormal];
    existBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    [existBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [existBtn addTarget:self action:@selector(existBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:existBtn];
    
    newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
    newBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15.0];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"Create new appoinment" forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(newBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:newBtn];
    


    if (IS_IPHONE4) {
        itemSearch.frame = CGRectMake(0,0,320,40);
        tableView.frame = CGRectMake(0, itemSearch.frame.origin.y+itemSearch.frame.size.height, 320,376);
        popUpView.frame = CGRectMake(0, 0, 320, 480);
        existBtn.frame = CGRectMake(60, 190, 200, 40);
        newBtn.frame = CGRectMake(60, 250, 200, 40);


    }else{
        itemSearch.frame = CGRectMake(0, 0,320,40);
        tableView.frame = CGRectMake(0, itemSearch.frame.origin.y+itemSearch.frame.size.height, 320,468);
        popUpView.frame = CGRectMake(0, 0, 320, 505);
        existBtn.frame = CGRectMake(60, 234, 200, 40);
        newBtn.frame = CGRectMake(60, 304, 200, 40);

    }
}

-(void)viewWillAppear:(BOOL)animated{
//    [self appointmentApi];
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(80,0,150,40);
    titleLbl.text = @"Item Search";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
}

- (void)menuBtnAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch) {
        return searchResults.count;
    }else{
        return prodArray.count;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (prodArray.count != 0) {
        UIView *productBackView = [[UIView alloc]init];
        productBackView.layer.borderColor = [[UIColor grayColor]CGColor];
        productBackView.backgroundColor = [UIColor whiteColor];
        productBackView.layer.borderWidth = 0.6f;
        [cell addSubview:productBackView];
        
        AsyncImageView *productImg = [[AsyncImageView alloc]init];
        productImg.contentMode = UIViewContentModeScaleAspectFit;
        productImg.clipsToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:productImg];
        
        if ([[prodArray objectAtIndex:indexPath.row]valueForKey:@"image"] != (id) [NSNull null] && ![[[prodArray objectAtIndex:indexPath.row]valueForKey:@"image"]  isEqual: @""]) {
            
            [productImg setImageURL:[NSURL URLWithString:[[prodArray objectAtIndex:indexPath.row]valueForKey:@"image"]]];
        }else{
            productImg.image = [UIImage imageNamed:@"shirt_ref"];
        }
        
        productImg.userInteractionEnabled = YES;
        [productBackView addSubview:productImg];
        
        UIView *detailView = [[UIView alloc]init];
        detailView.backgroundColor = [UIColor blackColor];
        detailView.layer.opacity = 0.6;
        [productImg addSubview:detailView];
        
        UILabel *productName = [[UILabel alloc]init];
        productName.text = [[prodArray objectAtIndex:indexPath.row]valueForKey:@"description"];
        productName.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
        productName.textColor = [UIColor whiteColor];
        [detailView addSubview:productName];
        
        UILabel *productType = [[UILabel alloc]init];
        productType.text = @"T-shirt";
        productType.font = [UIFont fontWithName:@"Kailasa" size:14.0];
        productType.textColor = [UIColor whiteColor];
        //        [detailView addSubview:productType];
        
        float price = [[[prodArray objectAtIndex:indexPath.row]valueForKey:@"amount"] floatValue];
        
        UILabel *productPrice = [[UILabel alloc]init];
        productPrice.text = [NSString stringWithFormat:@"$%0.2f",price];
        productPrice.font = [UIFont fontWithName:@"Kailasa" size:16.0];
        productPrice.textColor = [UIColor colorWithRed:04.0f/255.0f green:247.0f/255.0f  blue:225.0f/255.0f alpha:1];
        productPrice.textAlignment = NSTextAlignmentRight;
        [detailView addSubview:productPrice];
        
        UIButton *productOptBtn = [[UIButton alloc]init];
        productOptBtn.tag = 100+indexPath.row;
        [productOptBtn setImage:[UIImage imageNamed:@"swipe_btn"] forState:UIControlStateNormal];
        [productOptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [productOptBtn addTarget:self action:@selector(cellOption:) forControlEvents:UIControlEventTouchUpInside];
        [detailView addSubview:productOptBtn];
        
        UIView *optionBackview = [[UIView alloc]init];
        optionBackview.backgroundColor = [UIColor whiteColor];
        [productBackView addSubview:optionBackview];
        
        UIButton *appBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        appBtn.backgroundColor = [UIColor clearColor];
        appBtn.tag = 1000 + indexPath.row;
        [appBtn addTarget:self action:@selector(apptAction:) forControlEvents:UIControlEventTouchUpInside];
        [appBtn setImage:[UIImage imageNamed:@"appointment_btn"] forState:UIControlStateNormal];
        [optionBackview addSubview:appBtn];
        
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        infoBtn.backgroundColor = [UIColor clearColor];
        [infoBtn addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
        infoBtn.tag=3000+indexPath.row;
        [infoBtn setImage:[UIImage imageNamed:@"info_btn"] forState:UIControlStateNormal];
        [optionBackview addSubview:infoBtn];
        
        UIButton *trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        trashBtn.backgroundColor = [UIColor clearColor];
        trashBtn.tag = 2000 + indexPath.row;
        [trashBtn setImage:[UIImage imageNamed:@"trash_btn"] forState:UIControlStateNormal];
//        [optionBackview addSubview:trashBtn];
        
        UIButton *closerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closerBtn.backgroundColor = [UIColor clearColor];
        closerBtn.tag = 200 + indexPath.row;
        [closerBtn addTarget:self action:@selector(closeBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [closerBtn setImage:[UIImage imageNamed:@"swipe_icon"] forState:UIControlStateNormal];
        [optionBackview addSubview:closerBtn];
        
        
        productBackView.frame = CGRectMake(10, 0, 300,200);
        productImg.frame = CGRectMake(0, 0, 300,200);
        detailView.frame = CGRectMake(0, 150, 300, 50);
        productName.frame = CGRectMake(3, 0, 250, 25);
        productType.frame = CGRectMake(3, 25, 170, 20);
        productPrice.frame = CGRectMake(173, 20, 77, 25);
        productOptBtn.frame = CGRectMake(250, 0, 50, 50);
        
        optionBackview.frame = CGRectMake(320, 0, 0, 200);
        infoBtn.frame = CGRectMake(0, 10, 50, 50);
        appBtn.frame = CGRectMake(0, infoBtn.frame.size.height + infoBtn.frame.origin.y+10, 50, 50);
        trashBtn.frame = CGRectMake(0, appBtn.frame.size.height + appBtn.frame.origin.y, 50, 50);
        closerBtn.frame = CGRectMake(0,150, 50, 50);
        optionBackview.hidden = YES;
        if (selectedBtnIndex == indexPath.row) {
            if (!isShow) {
                optionBackview.hidden = NO;
                [UIView animateWithDuration:0.25 animations:^{
                    optionBackview.frame =  CGRectMake(250,0,50,200);
                    isShow = YES;
                }];
            }else{
                optionBackview.hidden = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    optionBackview.frame =  CGRectMake(320,0,0,200);
                    isShow = NO;
                }];
            }
        }
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
        [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeGesture];
        
        swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
        [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [cell addGestureRecognizer:swipeGesture];
        cell.userInteractionEnabled = YES;
        
    }else{
        if (indexPath.row == 1) {
            UILabel *noLbl = [[UILabel alloc]init];
            noLbl.text = @"No Results Found";
            noLbl.textAlignment = NSTextAlignmentCenter;
            noLbl.backgroundColor = [UIColor clearColor];
            noLbl.font = [UIFont boldSystemFontOfSize:15];
            noLbl.frame = CGRectMake(10, 0, 300, 30);
            [cell.contentView addSubview:noLbl];
        }
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    delegate.selectedIndex=indexPath.row;
    if (isShow) {
        
        self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
        selectedBtnIndex = indexPath.row;
        [tableView reloadData];
    }else{
//        self.view.userInteractionEnabled = NO;
       selectedIndex = indexPath.row;
        delegate.productId = [[prodArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
        delegate.itemIdxId = [[prodArray objectAtIndex:selectedIndex]valueForKey:@"itemidx"];
        
        [self productApi];

    }
}

- (void)cellOption:(id)sender{
    isShow = NO;
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    selectedBtnIndex = [sender tag] - 100;
    [tableView reloadData];
}

- (void)closeBtnAct:(id)sender{
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    selectedBtnIndex = [sender tag] - 200;
    [tableView reloadData];
    
}

- (void)cellSwiped:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
        UITableViewCell *cell = (UITableViewCell *)gestureRecognizer.view;
        NSIndexPath* indexPath1 = [tableView indexPathForCell:cell];
        selectedBtnIndex = (int)indexPath1.row;
        [tableView reloadData];
        
    }else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
        if (isShow) {
            self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
            UITableViewCell *cell = (UITableViewCell *)gestureRecognizer.view;
            NSIndexPath* indexPath1 = [tableView indexPathForCell:cell];
            selectedBtnIndex = (int)indexPath1.row;
            [tableView reloadData];
            self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
            
        }else{
            self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
        }
        NSLog(@"swipe right");
    }
    
}


- (void)infoAction:(id)sender{

    selectedIndex = [sender tag] - 3000;
    delegate.selectedIndex=[sender tag]-3000;
    delegate.productId = [[prodArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
    delegate.itemIdxId = [[prodArray objectAtIndex:selectedIndex]valueForKey:@"itemidx"];
    [self productApi];
    
    
}

- (void)apptAction:(id)sender{
    selectedIndex = [sender tag] - 1000;
    delegate.productId = [[prodArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
    
    popUpView.hidden = NO;
}

- (void)newBtnAction{
    
    popUpView.hidden = YES;
    AvailableAppointViewController *creatAppt=[[AvailableAppointViewController alloc]init];
    [self.navigationController pushViewController:creatAppt animated:YES];
}

- (void)existBtnAction{
    
    NSMutableArray *apptArr = [delegate.dataBaseObj readAppointment];
    if (apptArr.count != 0) {
        
        popUpView.hidden = YES;
        
        AppointmentViewController *ApptObj = [[AppointmentViewController alloc]init];
        [self.navigationController pushViewController:ApptObj animated:YES];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Appointments Available!!! Do you want to Creat New one?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 200;
        [alert show];
    }
}




#pragma mark - Api Action
-(void)productApi{
    self.view.userInteractionEnabled=NO;
    delegate.proAmount = [[prodArray objectAtIndex:selectedIndex]valueForKey:@"amount"];
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView startAnimating];
    [indicatorView setCenter:CGPointMake(320/2-4,320/2-1)];
    
    [tableView addSubview:indicatorView];
    
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
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[prodArray objectAtIndex:selectedIndex]valueForKey:@"productId"],@"code",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link = @"POSMClient/json/process/execute/ProductSearch";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,delegate.SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respose:%@",responseObject);
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled=NO;
        delegate.naviPath=@"searchView";
        delegate.productDict = returnDict;
        [indicatorView stopAnimating];
        ProductViewController *prodObj=[[ProductViewController alloc]init];
        [self.navigationController pushViewController:prodObj animated:YES];
        self.view.userInteractionEnabled=YES;
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
        [indicatorView stopAnimating];
    }];
    
    [operation start];
    

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    isSearch = YES;
    [searchResults removeAllObjects];
    NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchBar.text];
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i=0; i<prodArray.count; i++) {
        
        [tempArray addObject:[[prodArray objectAtIndex:i]valueForKey:@"description"]];
        
    }
    NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:0];
    [temp addObjectsFromArray:[tempArray filteredArrayUsingPredicate:searchSearch]];
    
    
    for (int i=0; i<temp.count; i++) {
        
        for (int j=0; j<prodArray.count; j++) {
            
            if ([temp objectAtIndex:i] == [[prodArray objectAtIndex:j]valueForKey:@"description"]) {
                
                [searchResults addObject:[prodArray objectAtIndex:j]];
                
            }
            
        }
        
    }
    
    
    [tableView reloadData];
    
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch = NO;
    [tableView reloadData];
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    isSearch = YES;
    [searchResults removeAllObjects];
    NSPredicate *searchSearch = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", text];
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithCapacity:0];
   
    for (int i=0; i<prodArray.count; i++) {
        
        [tempArray addObject:[[prodArray objectAtIndex:i]valueForKey:@"description"]];

    }
    NSMutableArray *temp=[[NSMutableArray alloc]initWithCapacity:0];
    [temp addObjectsFromArray:[tempArray filteredArrayUsingPredicate:searchSearch]];
    
    
    for (int i=0; i<temp.count; i++) {

        for (int j=0; j<prodArray.count; j++) {
            
            if ([temp objectAtIndex:i] == [[prodArray objectAtIndex:j]valueForKey:@"description"]) {
                
                [searchResults addObject:[prodArray objectAtIndex:j]];
                
            }
            
        }
        
    }
    

    [tableView reloadData];
    return YES;

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([[touch view] isKindOfClass:[UIView class]]) {
        NSLog(@"[touch view].tag = %d", [touch view].tag);
        if ([touch view].tag==50) {
            popUpView.hidden=YES;
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
