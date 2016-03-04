//
//  MyWishViewController.m
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//


#import "MyWishViewController.h"

@interface MyWishViewController (){
    NSInteger selectedBtnIndex;
    BOOL isShow;
    UIButton *sideMenuBtn;
    UILabel *titleLbl;
    NSMutableArray *wishListArray;
    NSIndexPath * selIndexPath;
    NSString *productId,*itemId;

}

@end

@implementation MyWishViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }
    
    apiAction = 0;
    isShow = NO;
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    wishListArray = [[NSMutableArray alloc]initWithCapacity:0];
    selectedBtnIndex = -1;
    
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
    
    tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.separatorStyle = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden=YES;
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
    newBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"Create new appoinment" forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(newBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:newBtn];
    
    if (IS_IPHONE4) {
        tableView.frame = CGRectMake(0, 5, 320,475);
        popUpView.frame = CGRectMake(0, 0, 320, 480);
        existBtn.frame = CGRectMake(60, 190, 200, 40);
        newBtn.frame = CGRectMake(60, 250, 200, 40);
    }else{
        tableView.frame = CGRectMake(0, 5, 320,505);
        popUpView.frame = CGRectMake(0, 0, 320, 505);
        existBtn.frame = CGRectMake(60, 234, 200, 40);
        newBtn.frame = CGRectMake(60, 304, 200, 40);
    }
    
    NSMutableDictionary *productDit = [[NSMutableDictionary alloc]init];
    [productDit setValue:@"5C101" forKey:@"productId"];
    [productDit setValue:@"0" forKey:@"itemidx"];
    [productDit setValue:@"http://ecx.images-amazon.com/images/I/610R%2B6uESPL._SL1000_.jpg" forKey:@"image"];
    [productDit setValue:@"Canon EOS 1200D 18MP Digital SLR Camera (Black) with 18-55mm and 55-250mm IS II Lens,8GB card and Carry Bag" forKey:@"description"];
    [productDit setValue:@"25,340.00" forKey:@"amount"];
    
    tableView.hidden = NO;
    [wishListArray addObject:productDit];
    [tableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated{
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    self.menuContainerViewController.rightMenuViewController = nil;
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0,0,200,44);
    titleLbl.text = @"My Wishlist";
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLbl;
    [self wishListApi];
    
    /*  if ([delegate isNetConnected]) {
        [self wishListApi];
    }else{
        wishListArray = [delegate.dataBaseObj readWishlist];
        tableView.hidden=NO;
        [indicatorView stopAnimating];
    }*/
}

- (void)menuBtnAction {
    popUpView.hidden = YES;
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

#pragma mark Tableview Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (wishListArray.count != 0) {
        return wishListArray.count;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (wishListArray.count != 0) {
        UIView *productBackView = [[UIView alloc]init];
        productBackView.layer.borderColor = [[UIColor grayColor]CGColor];
        productBackView.backgroundColor = [UIColor whiteColor];
        productBackView.layer.borderWidth = 0.6f;
        [cell addSubview:productBackView];
        
        UIImageView *productImg = [[UIImageView alloc]init];
        productImg.contentMode = UIViewContentModeScaleAspectFit;
        productImg.clipsToBounds = YES;
        
        if ([[wishListArray objectAtIndex:indexPath.row]valueForKey:@"image"] != (id) [NSNull null] && ![[[wishListArray objectAtIndex:indexPath.row]valueForKey:@"image"]  isEqual: @""]) {
            [productImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[wishListArray objectAtIndex:indexPath.row]valueForKey:@"image"]]]
                          placeholderImage:[UIImage imageNamed:@"shirt_ref"]];
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
        productName.text = [[wishListArray objectAtIndex:indexPath.row]valueForKey:@"description"];
        productName.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
        productName.textColor = [UIColor whiteColor];
        [detailView addSubview:productName];
        
        UILabel *productType = [[UILabel alloc]init];
        productType.text = @"T-shirt";
        productType.font = [UIFont fontWithName:@"Kailasa" size:14.0];
        productType.textColor = [UIColor whiteColor];
        //        [detailView addSubview:productType];
        
        float price = [[[wishListArray objectAtIndex:indexPath.row]valueForKey:@"amount"] floatValue];
        
        UILabel *productPrice = [[UILabel alloc]init];
        productPrice.text = [NSString stringWithFormat:@"$%0.2f",price];
        productPrice.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
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
        [trashBtn addTarget:self action:@selector(removeWishlist:) forControlEvents:UIControlEventTouchUpInside];
        [trashBtn setImage:[UIImage imageNamed:@"trash_btn"] forState:UIControlStateNormal];
        [optionBackview addSubview:trashBtn];
        
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
        infoBtn.frame = CGRectMake(0, 0, 50, 50);
        appBtn.frame = CGRectMake(0, infoBtn.frame.size.height + infoBtn.frame.origin.y, 50, 50);
        trashBtn.frame = CGRectMake(0, appBtn.frame.size.height + appBtn.frame.origin.y, 50, 50);
        closerBtn.frame = CGRectMake(0, trashBtn.frame.size.height + trashBtn.frame.origin.y, 50, 50);
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
    
    if (isShow) {
        
        self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
        selectedBtnIndex = indexPath.row;
        [tableView reloadData];
        
    }else{
        
        apiAction = 1;
        selectedIndex = indexPath.row;
        delegate.productId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
        delegate.itemIdxId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"itemidx"];
        
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

    apiAction = 1;
    delegate.productId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
    delegate.itemIdxId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"itemidx"];
    [self productApi];
    
//    delegate.proAmount = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"amount"];
//    
//    ProductViewController *prodObj=[[ProductViewController alloc]init];
//    [self.navigationController pushViewController:prodObj animated:YES];
}

- (void)apptAction:(id)sender{
    selectedIndex = [sender tag] - 1000;
    delegate.productId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
    delegate.naviPath=@"wishlist";
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


-(void)removeWishlist:(UIButton *)sender{
    apiAction = 2;
    selectedIndex = [sender tag] - 2000;
    
    UIAlertView *confAlert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are You Sure You Want to Delete?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    confAlert.tag = 102;
    [confAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 102) {
        if (buttonIndex == 0) {
            selectedBtnIndex = -1;
            if ([delegate isNetConnected]) {
                
                [self deleleApi];
                
            }else{
                
                [delegate.dataBaseObj removeProductFromWishlist:[[wishListArray objectAtIndex:selectedIndex]valueForKey:@"productId"] tableName:@"wishlist_tbl"];
                wishListArray = [delegate.dataBaseObj readWishlist];
                [tableView reloadData];
                
            }
            //            [self removeShopperList];
        }
    }else if (alertView.tag == 200){
        if (buttonIndex == 1) {
            
            popUpView.hidden = YES;
            AvailableAppointViewController *creatAppt=[[AvailableAppointViewController alloc]init];
            [self.navigationController pushViewController:creatAppt animated:YES];
            
        }else if (alertView.tag==300){
            
            if (buttonIndex==0) {
                
                [self productApi];
                
            }
            
        }else{
            
            popUpView.hidden = YES;
        }
    }
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([[touch view] isKindOfClass:[UIView class]]) {
        if ([touch view].tag==50) {
            popUpView.hidden=YES;
        }
    }
}

#pragma mark -API post and get

-(void)wishListApi{
    /*
     http://sales.ovcdemo.com:8080/json/process/execute/GetWishlistItems
     {
     "retailerId":"defaultRetailer",
     "loyaltyId":"abhijit@oneviewcommerce.com",
     "listType":"WISHLIST",
     "listName":"WishList"
     }
     */
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:USERDETAIL];
    
    NSDictionary *data = @{@"retailerId":@"defaultRetailer",@"loyaltyId":[userDetail valueForKey:@"loyaltyId"],@"listType":@"WISHLIST",@"listName":@"WishList"};
    
    [activityIndicator showActivityIndicator];
    
    [APIservice getWishListApiWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray *tempArr = [[resultDic objectForKey:@"data"]objectForKey:@"data"];
                if ([tempArr count]!=0) {
                    [delegate.dataBaseObj deleteWishListTable];
                    [delegate.dataBaseObj insertWishlistData:resultDic];
                    wishListArray = [delegate.dataBaseObj readWishlist];
                    NSLog(@"This is wish list data:%@",wishListArray);
                }
                tableView.hidden=NO;
                [tableView reloadData];
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

-(void)productApi{
    delegate.proAmount = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"amount"];
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
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[wishListArray objectAtIndex:selectedIndex]valueForKey:@"productId"],@"code",nil];
   
    [activityIndicator showActivityIndicator];
    [APIservice getProductDetailApiWithCompletionBlock:^(NSDictionary *resultDic) {
        [activityIndicator hideActivityIndicator];
        
        if ([CommonWebServices isWebResponseNotEmpty:resultDic])
        {
            if ([resultDic isKindOfClass:[NSDictionary class]])
            {
                delegate.naviPath = @"wishlist";
                delegate.productDict = [resultDic mutableCopy];
                NSMutableArray *tempArr = [[resultDic valueForKey:@"data"]valueForKey:@"SearchObjectList"];
                
                if ([tempArr count] != 0) {
                    
                    ProductViewController *prodObj=[[ProductViewController alloc]init];
                    [self.navigationController pushViewController:prodObj animated:YES];
                    
                }else{
                    
                    UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"selected item details not available" delegate:self cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil];
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

-(void)removeShopperList{
    
    if ([delegate isNetConnected]) {
        
        [self removeApi:productId itemId:itemId];
    }else{
        
        [delegate.dataBaseObj removeProductFromWishlist:productId tableName:@"shopper_tbl"];
    }
}

- (void)removeApi:(NSString *)productId itemId:(NSString *)itemId{
    /*    http://demoqa.ovcdemo.com:8080/POSMClient/json/process/execute/RemoveFromWishlist
     {
     "username": "eCommerce",
     "password": "changeme",
     "deviceId": "dUUID",
     "source": "external",
     "data": {
     "retailerId": "demoRetailer",
     "loyaltyId": "ak1@gmail.com",
     "listType": "WISHLIST",
     "listName": "WishList",
     "productId":  "1934796",
     "itemIdx":"xxx"
     }
     }
     }
     */
    
    apiAction = 2;
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",@"shopper@ovc.com",@"loyaltyId",@"WISHLIST",@"listType",@"WishList",@"listName",productId,@"productId",itemId,@"itemIdx",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link = [NSString stringWithFormat:@"%@POSMClient/json/process/execute/RemoveFromWishlist",[[NSUserDefaults standardUserDefaults] objectForKey:@"SEVERURL"]];
    
    [activityIndicator showActivityIndicator];
    [CommonWebServices postMethodWithUrl:link dictornay:data onSuccess:^(id responseObject)
     {
         [activityIndicator hideActivityIndicator];
         
         if ([CommonWebServices isWebResponseNotEmpty:responseObject])
         {
             if ([responseObject isKindOfClass:[NSDictionary class]])
             {
             }
             else
             {
             }
         }
         
     } onFailure:^(NSError *error)
     {
         [activityIndicator hideActivityIndicator];
         NSLog(@"Error Received : %@", error.localizedDescription);
         
     }];

}

- (void)deleleApi{
    
    productId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"productId"];
    itemId = [[wishListArray objectAtIndex:selectedIndex]valueForKey:@"itemidx"];
    
    NSMutableDictionary *userData=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",[[NSUserDefaults standardUserDefaults] stringForKey:@"userMail"],@"loyaltyId",@"WISHLIST",@"listType",@"WishList",@"listName",productId,@"productId",itemId,@"itemIdx",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link=[NSString stringWithFormat:@"%@POSMClient/json/process/execute/RemoveFromWishlist",[[NSUserDefaults standardUserDefaults] objectForKey:@"SERVERURL"]];
    
    [activityIndicator showActivityIndicator];
    [CommonWebServices postMethodWithUrl:link dictornay:data onSuccess:^(id responseObject)
     {
         [activityIndicator hideActivityIndicator];
         
         if ([CommonWebServices isWebResponseNotEmpty:responseObject])
         {
             if ([responseObject isKindOfClass:[NSDictionary class]])
             {
             }
             else
             {
             }
         }
         
     } onFailure:^(NSError *error)
     {
         [activityIndicator hideActivityIndicator];
         NSLog(@"Error Received : %@", error.localizedDescription);
         
     }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
