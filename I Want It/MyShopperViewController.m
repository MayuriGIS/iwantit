//
//  MyShopperViewController.m
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "MyShopperViewController.h"

@interface MyShopperViewController (){
    UIButton *sideMenuBtn,*cameraBtn,*chatBtn;
    UILabel *titleLbl;
    UIView *optionBackview;
    NSMutableArray *shopperArr;
    UIActivityIndicatorView *indicatorView;
    NSString *productId,*itemId;

}

@end

@implementation MyShopperViewController
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    apiAction = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    self.menuContainerViewController.rightMenuViewController=nil;
    
    shopperArr = [[NSMutableArray alloc]initWithCapacity:0];

    sideMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sideMenuBtn.frame = CGRectMake(0,0,40,64);
    sideMenuBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -15, 0, 0);
    sideMenuBtn.backgroundColor = [UIColor clearColor];
    [sideMenuBtn setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [sideMenuBtn addTarget:self action:@selector(menuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];
    
    cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0,0,40,64);
    cameraBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    cameraBtn.backgroundColor = [UIColor clearColor];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraBtnAct) forControlEvents:UIControlEventTouchUpInside];
    
    chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(0,0,40,64);
    chatBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    chatBtn.backgroundColor = [UIColor clearColor];
    [chatBtn setImage:[UIImage imageNamed:@"chat_icon"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatBtnAct) forControlEvents:UIControlEventTouchUpInside];

//    UIBarButtonItem *leftA = [[UIBarButtonItem alloc]initWithCustomView:cameraBtn];
    UIBarButtonItem *leftB = [[UIBarButtonItem alloc]initWithCustomView:chatBtn];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:leftB, nil];

    tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.hidden=YES;
    [self.view addSubview:tableView];
    
    if (IS_IPHONE4) {
        tableView.frame=CGRectMake(0, 5, 320,475);
            
    }else{
        tableView.frame=CGRectMake(0, 5, 320,505);
    }
    if ([delegate isNetConnected]) {
        apiAction = 0;
        [self myShopperApi];
    }else{
        shopperArr = [delegate.dataBaseObj readShopper];
        tableView.hidden=NO;
        [tableView reloadData];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    titleLbl=[[UILabel alloc]init];
    titleLbl.frame=CGRectMake(0,0,200,40);
    titleLbl.text=@"My Shopper";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textColor=[UIColor whiteColor];
    titleLbl.textAlignment=NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    self.navigationItem.titleView = titleLbl;
}

- (void)menuBtnAction {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)chatBtnAct{
    
    ChatScreen *chatObj=[[ChatScreen alloc]init];
    [self.navigationController pushViewController:chatObj animated:YES];
}

-(void)cameraBtnAct{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No camera available"
                              message: @"Failed to take image"
                              delegate: self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma  mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (shopperArr.count != 0) {
        return shopperArr.count;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        return 210.0;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (shopperArr.count != 0) {
        UIView *productBackView = [[UIView alloc]init];
        productBackView.layer.borderColor = [[UIColor grayColor]CGColor];
//        productBackView.backgroundColor = [UIColor colorWithRed:219.0f/255.0f green:219.0f/255.0f blue:219.0f/255.0f alpha:1];
        productBackView.layer.borderWidth = 0.6f;
        [cell addSubview:productBackView];
        
        
        AsyncImageView *productImg = [[AsyncImageView alloc]init];
        productImg.contentMode = UIViewContentModeScaleAspectFit;
        productImg.clipsToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:productImg];
        
        if ([[shopperArr objectAtIndex:indexPath.row]objectForKey:@"image"] != (id) [NSNull null] && ![[[shopperArr objectAtIndex:indexPath.row]objectForKey:@"image"]  isEqual: @""]) {
            
            [productImg setImageURL:[NSURL URLWithString:[[shopperArr objectAtIndex:indexPath.row]objectForKey:@"image"]]];
        }else{
            productImg.image = [UIImage imageNamed:@"noimage"];
        }

        productImg.userInteractionEnabled = YES;
        [productBackView addSubview:productImg];
        
        UIButton *likeBtn = [[UIButton alloc]init];
        likeBtn.tag = 1000 + indexPath.row;
        [likeBtn setImage:[UIImage imageNamed:@"up_unsel"] forState:UIControlStateNormal];
        [likeBtn addTarget:self action:@selector(addWishlist:) forControlEvents:UIControlEventTouchUpInside];
        [productBackView addSubview:likeBtn];
        
        UIButton *dislikeBtn = [[UIButton alloc]init];
        dislikeBtn.tag = 2000 + indexPath.row;
        [dislikeBtn setImage:[UIImage imageNamed:@"down_unsel"] forState:UIControlStateNormal];
        [dislikeBtn addTarget:self action:@selector(removeWishlist:) forControlEvents:UIControlEventTouchUpInside];
        [productBackView addSubview:dislikeBtn];
        
        UIView *detailView = [[UIView alloc]init];
        detailView.backgroundColor = [UIColor blackColor];
        detailView.layer.opacity = 0.6;
        [productImg addSubview:detailView];
        
        UILabel *productName = [[UILabel alloc]init];
        productName.text = [[shopperArr objectAtIndex:indexPath.row]valueForKey:@"description"];
        productName.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
        productName.textColor = [UIColor whiteColor];
        [detailView addSubview:productName];
        
        UILabel *productType = [[UILabel alloc]init];
        productType.text = [NSString stringWithFormat:@"Qty:%@",[[shopperArr objectAtIndex:indexPath.row]valueForKey:@"quantity"]];
        productType.font = [UIFont fontWithName:@"Kailasa" size:14.0];
        productType.textColor = [UIColor whiteColor];
        [detailView addSubview:productType];
        
        float price = [[[shopperArr objectAtIndex:indexPath.row]valueForKey:@"amount"] floatValue];

        UILabel *productPrice = [[UILabel alloc]init];
        productPrice.text = [NSString stringWithFormat:@"$%0.2f",price];
        productPrice.font = [UIFont fontWithName:@"Kailasa" size:16.0];
        productPrice.textColor = [UIColor colorWithRed:04.0f/255.0f green:247.0f/255.0f  blue:225.0f/255.0f alpha:1];
        productPrice.textAlignment = NSTextAlignmentRight;
        [detailView addSubview:productPrice];
        
        //    for (int i = 0; i< wishListArray.count; i++) {
        //
        //        if ([productName.text isEqualToString:[[wishListArray objectAtIndex:i]valueForKey:@"description"]]) {
        //            [likeBtn setImage:[UIImage imageNamed:@"up_sel"] forState:UIControlStateNormal];
        //        }
        //    }
        
        productBackView.frame = CGRectMake(10, 0, 300, 200);
        productImg.frame = CGRectMake(0, 0, 300, 200);
        likeBtn.frame = CGRectMake(10, 50, 50, 50);
        dislikeBtn.frame = CGRectMake(240, 50, 50, 50);
        detailView.frame = CGRectMake(0, 150, 300, 50);
        productName.frame = CGRectMake(3, 0, 208, 25);
        productType.frame = CGRectMake(3, 30, 255, 20);
        productPrice.frame = CGRectMake(211, 0, 89, 30);
        cell.userInteractionEnabled = YES;

    }else{
        if (indexPath.row == 1) {
            
            NSLog(@"what is this :%@",cell);
            UILabel *noLbl = [[UILabel alloc]init];
            noLbl.text = @"No Results Found";
            noLbl.textAlignment = NSTextAlignmentCenter;
            noLbl.backgroundColor = [UIColor clearColor];
            noLbl.font = [UIFont boldSystemFontOfSize:15];
            noLbl.frame = CGRectMake(10, 0, 300, 30);
            [cell.contentView addSubview:noLbl];
            [cell.contentView bringSubviewToFront:noLbl];
        }
        cell.userInteractionEnabled = NO;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
    
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.view.userInteractionEnabled = NO;
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicatorView startAnimating];
    [indicatorView setCenter:CGPointMake(320/2-4,320/2-1)];
    
    [tableView addSubview:indicatorView];
    
    
    apiAction = 3;
    delegate.selectedIndex=indexPath.row;
    delegate.productId = [[shopperArr objectAtIndex:indexPath.row]valueForKey:@"productId"];
    delegate.proAmount = [[shopperArr objectAtIndex:indexPath.row]valueForKey:@"amount"];
    [self productApi];

}

-(void)addWishlist:(UIButton *)sender{
    
    int tag = [sender tag] - 1000;
    productId = [[shopperArr objectAtIndex:tag]valueForKey:@"productId"];
    itemId = [[shopperArr objectAtIndex:tag]valueForKey:@"itemidx"];
    
    if ([delegate isNetConnected]) {
      
        [self addWishListApi:[shopperArr objectAtIndex:tag]];
        [self removeApi:productId itemId:itemId];


    }else{
        [delegate.dataBaseObj insertWishlistData:[shopperArr objectAtIndex:tag]];
        [delegate.dataBaseObj removeProductFromWishlist:productId tableName:@"shopper_tbl"];

        [tableView reloadData];
    }
//    wishListArray = [delegate.dataBaseObj readWishlist];
}

-(void)removeWishlist:(UIButton *)sender{
    
    int tag = [sender tag] - 2000;
    productId = [[shopperArr objectAtIndex:tag]valueForKey:@"productId"];
    itemId = [[shopperArr objectAtIndex:tag]valueForKey:@"itemidx"];
    if ([delegate isNetConnected]) {
        [self removeApi:productId itemId:itemId];
        [self deleleApi];
    }else{
       
        [delegate.dataBaseObj removeProductFromWishlist:productId tableName:@"shopper_tbl"];
        [delegate.dataBaseObj removeProductFromWishlist:productId tableName:@"wishlist_tbl"];

    }
}


#pragma mark - Image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSData *imgData =UIImagePNGRepresentation(chosenImage);
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentdir =[paths objectAtIndex:0];
    NSLog(@"this is path:%@", [documentdir stringByAppendingPathComponent:[NSString stringWithFormat:@"suresh.png"]]);
    NSString *imagePath = [documentdir stringByAppendingPathComponent:[NSString stringWithFormat:@"suresh.png"]];
    
    if (![imgData writeToFile:imagePath  atomically:NO]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed"message: @"Failed to save image" delegate: self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    else
    {
//        appdele.imagePath = imagePath;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self viewWillDisappear:YES];
    }
    
}

#pragma mark- Api

-(void)myShopperApi{
  
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    [indicatorView setCenter:CGPointMake(320/2-5,320/2-5)];
    [self.view addSubview:indicatorView];

    [shopperArr removeAllObjects];
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"shopper@ovc.com",@"loyaltyId",@"demoRetailer",@"retailerId",@"WISHLIST",@"listType",@"WishList",@"listName",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link = @"POSMClient/json/process/execute/GetWishlistItems";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval=60.0f;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",delegate. SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respose:%@",responseObject);
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled = YES;
        
        if (returnDict != nil && returnDict != (id)[NSNull null]) {
            
            if ([[[returnDict objectForKey:@"data"]objectForKey:@"data"]count] != 0 ) {
                [delegate.dataBaseObj deleteShopperTable];
                [delegate.dataBaseObj insertShopperlistData:returnDict];
                shopperArr = [delegate.dataBaseObj readShopper];
                tableView.hidden=NO;
                [tableView reloadData];

            }else{
                
                tableView.hidden=NO;
                [tableView reloadData];

            }
        }
        [tableView reloadData];
        [indicatorView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
        [indicatorView stopAnimating];
    }];
    
    [operation start];
    

    
}


-(void)addWishListApi:(NSDictionary *)productDict{
    //http://demoqa.ovcdemo.com:8080/POSMClient/json/process/execute/AddToWishlist
    
    /*
     {
     "username": "eCommerce",
     "password": "changeme",
     "deviceId": "dUUID",
     "source": "external",
     "data": {
     "retailerId": "demoRetailer",
     "ovclid": "ak1@gmail.com",
     "listType": "WISHLIST",
     "listName": "WishList",
     "payload": {
     "listItems": [
     {
     "productId": "1934796",
     "productDesc": "PowerShot A480",
     "productQty": "1"
     }
     ]
     }
     }
     }
     */
    apiAction = 1;
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:[productDict objectForKey:@"productId"],@"productId",[productDict objectForKey:@"description"],@"productDesc",[productDict objectForKey:@"quantity"],@"productQty", nil];
    NSMutableArray *prodctArr = [[NSMutableArray alloc]init];
    [prodctArr addObject:prodDict];
    
    NSDictionary *listDict = [NSDictionary dictionaryWithObjectsAndKeys:prodctArr,@"listItems", nil];
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",[[NSUserDefaults standardUserDefaults]stringForKey:@"userMail"],@"ovclid", @"WISHLIST",@"listType",@"WishList",@"listName",listDict, @"payload",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link = @"POSMClient/json/process/execute/AddToWishlist";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval=60.0f;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",delegate. SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respose:%@",responseObject);
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled = YES;
        
        if (returnDict != nil && returnDict != (id)[NSNull null]) {
            
            if ([returnDict objectForKey:@"data"]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Item Successfully Added in WishList!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
        [indicatorView stopAnimating];
    }];
    
    [operation start];
    
}

//remove item from WISHLIST TABLE
- (void)deleleApi{
    self.view.userInteractionEnabled = NO;
    
    apiAction=2;
    NSMutableDictionary *userData=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",[[NSUserDefaults standardUserDefaults] stringForKey:@"userMail"],@"loyaltyId",@"WISHLIST",@"listType",@"WishList",@"listName",productId,@"productId",itemId,@"itemIdx",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link=@"POSMClient/json/process/execute/RemoveFromWishlist";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    //                NSURLRequest  *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",delegate.SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation1.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respose:%@",responseObject);
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled = YES;
        
        if (returnDict != nil && returnDict != (id)[NSNull null]) {
            delegate.productDict = returnDict;
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
        [indicatorView stopAnimating];
    }];
    
    [operation1 start];
}

//remove item from SHOPPER LIST
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
    NSString *link = @"POSMClient/json/process/execute/RemoveFromWishlist";
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval=60.0f;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",delegate. SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respose:%@",responseObject);
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled = YES;
        
        if ([[[returnDict objectForKey:@"data"]objectForKey:@"data"]count]==0) {
           
            if (shopperArr.count<=1) {
                MyShopperViewController *shopObj=[[MyShopperViewController alloc]init];
                [self.navigationController pushViewController:shopObj animated:NO];
                
            }else{
                
                [self myShopperApi];

            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
        [indicatorView stopAnimating];
    }];
    [tableView reloadData];
    [operation start];

}

-(void)productApi{
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
    
    
    delegate.naviPath=@"shopperview";
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:delegate.productId,@"code",nil];
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link = @"POSMClient/json/process/execute/ProductSearch";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval=60.0f;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",delegate. SER,link]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"respose:%@",responseObject);
        NSMutableDictionary *returnDict=responseObject;
        self.view.userInteractionEnabled = YES;
        
        if (returnDict != nil && returnDict != (id)[NSNull null]) {
            delegate.productDict = returnDict;
            if (![[[returnDict valueForKey:@"data"]valueForKey:@"SearchObjectList"]count]==0) {
                
                ProductViewController *prodObj=[[ProductViewController alloc]init];
                [self.navigationController pushViewController:prodObj animated:YES];
                
            }else{
                
                UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"selected item details not available" delegate:self cancelButtonTitle:@"DISMISS" otherButtonTitles:nil, nil];
                [alrView show];
            }
            
        }
        [tableView reloadData];
        [indicatorView stopAnimating];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
        [indicatorView stopAnimating];
    }];
    
    [operation start];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==300) {
        
        if (buttonIndex==0) {
            [self myShopperApi];
        }
    }
}



@end
