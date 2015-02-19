//
//  AddOptionViewController.m
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "AddOptionViewController.h"
#import "MFSideMenu.h"
@interface AddOptionViewController (){
    int selectedIndex,apiAction;

}

@end

@implementation AddOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"addblackbar"]];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.menuContainerViewController.menuWidth = 60;
    selectedIndex = -1;
    
    UIButton *closureBtn = [[UIButton alloc]init];
    closureBtn.frame = CGRectMake(0,-05,80,70);
    closureBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"addminus_icon"]];
    [closureBtn addTarget:self action:@selector(closeBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closureBtn];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(0,64,80,570);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    if ([delegate.naviPath isEqualToString:@"shopperview"]) {
        
        unSeleImg = [[NSMutableArray alloc]initWithObjects:@"like_btn",@"dislike_btn", nil];
        seleImg = [[NSMutableArray alloc]initWithObjects:@"up_unsel",@"down_unsel",nil];
        
    }else if ([delegate.naviPath isEqualToString:@"scanView"] || [delegate.naviPath isEqualToString:@"searchView"]){
      
        unSeleImg = [[NSMutableArray alloc]initWithObjects:@"addappointment_unselbtn",@"addlike_unselbtn", nil];
        seleImg = [[NSMutableArray alloc]initWithObjects:@"addappointment_selbtn",@"addlike_selbtn",nil];
        
    }else
    {
        
        unSeleImg = [[NSMutableArray alloc]initWithObjects:@"addappointment_unselbtn",@"addtrash_unselbtn", nil];
        seleImg = [[NSMutableArray alloc]initWithObjects:@"addappointment_selbtn",@"addtrash_selbtn",nil];

  
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return seleImg.count;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 56;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(0,0,60, 56);
    iconView.backgroundColor = [UIColor clearColor];
    
    if (selectedIndex == indexPath.row) {
        iconView.image=[UIImage imageNamed:[seleImg objectAtIndex:indexPath.row]];
    }else{
        
        iconView.image=[UIImage imageNamed:[unSeleImg objectAtIndex:indexPath.row]];
    }
    [cell addSubview:iconView];
 
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.textLabel.textColor = [UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.view.userInteractionEnabled=false;

    if (indexPath.row == 0) {
        if ([delegate.naviPath isEqualToString:@"shopperview"]) {
           
            NSMutableArray *shopperArr;
            shopperArr = [delegate.dataBaseObj readShopper];
           
            NSLog(@"this is product dici:%d",delegate.selectedIndex);
            
            if ([delegate isNetConnected]) {
              
                [self addWishListApi:[shopperArr objectAtIndex:delegate.selectedIndex]];
                [self removeApishoperList:delegate.productId itemId:delegate.itemIdxId];

                
            }else{

                
                [delegate.dataBaseObj insertWishlistData:[shopperArr objectAtIndex:delegate.selectedIndex]];
                
                [tableView reloadData];
                
            }
            
            
        }else{
            
            delegate.popUpEnable=YES;
            
            
//            ProductViewController *proObj = [[ProductViewController alloc] init];
//            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//            NSArray *controllers = [NSArray arrayWithObject:proObj];
//            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
   
        }
        

    }else if (indexPath.row == 1){
        
        delegate.popUpEnable=NO;

        if ([delegate.naviPath isEqualToString:@"scanView"] || [delegate.naviPath isEqualToString:@"searchView"]){
            
            NSMutableArray *shopperArr;
            shopperArr = [delegate.dataBaseObj readShopper];
            
            NSLog(@"this is product dici:%d",delegate.selectedIndex);
            
            if ([delegate isNetConnected]) {
                
                if ([delegate.naviPath isEqualToString:@"scanView"]) {
                    
                    [self addWishListApi:[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0]];

                    
                }else{
                   
                    [self addWishListApi:[shopperArr objectAtIndex:delegate.selectedIndex]];

                }
                
                
            }else{
                
                
                [delegate.dataBaseObj insertWishlistData:[shopperArr objectAtIndex:delegate.selectedIndex]];
                
                [tableView reloadData];
                
            }

            
        }else{
          
            UIAlertView *confAlert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are You Sure? You Want to Delete?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            confAlert.tag = 102;
            [confAlert show];

        }
        

        
    }else{

    }
    selectedIndex = indexPath.row;
    [tableView reloadData];
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
    self.view.userInteractionEnabled=true;
}

-(void)closeBtnAct{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"theChange" object:nil];
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];

    ProductViewController *productObj=[[ProductViewController alloc]init];
    [productObj.view bringSubviewToFront:productObj.addBtn];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 102) {
        if (buttonIndex == 0) {
            if ([delegate isNetConnected]) {
                [self deleleApi];
            }else{
               
                [delegate.dataBaseObj removeProductFromWishlist:delegate.productId tableName:@"wishlist_tbl"];
                
                [delegate.dataBaseObj removeProductFromWishlist:delegate.productId tableName:@"shopper_tbl"];
                
            }
        }
    }else if (alertView.tag==103){
       
        NSLog(@"%@",delegate.naviPath);
        
        if ([delegate.naviPath isEqualToString:@"searchView"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}

-(void)addWishListApi:(NSMutableDictionary *)productDict{
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
     
     
     data =     {
     listName = WishList;
     listType = WISHLIST;
     ovclid = "test@ovc.com";
     payload =         {
     listItems =             (
     {
     productDesc = "- 12.1 effective megapixels resolution for very high quality imaging and detail-packed enlargements.<br/>- 4x optical zoom Carl Zeiss Vario-Tessar lens.<br/>- 720p HD movie recording captures crisp, detail-packed HD video clips plus stereo sound at 30 fra";
     productId = 1992693;
     productQty = 1;
     }
     );
     };
     retailerId = demoRetailer;
     };
     deviceId = dUUID;
     password = changeme;
     source = external;
     username = eCommerce;
     }

     */
    NSMutableDictionary *data;
    NSDictionary *prodDict;
    apiAction = 1;
    if ([delegate.naviPath isEqualToString:@"scanView"]) {
    
        NSLog(@"%@",[[[productDict objectForKey:@"data"]objectForKey:@"SearchObjectList"]objectForKey:@"description"]);
        prodDict = [NSDictionary dictionaryWithObjectsAndKeys:[productDict objectForKey:@"sku"],@"productId",[productDict objectForKey:@"name"],@"productDesc",[productDict objectForKey:@"allowDiscounts"],@"productQty", nil];

        
    }else{
        
        prodDict = [NSDictionary dictionaryWithObjectsAndKeys:[productDict objectForKey:@"productId"],@"productId",[productDict objectForKey:@"description"],@"productDesc",[productDict objectForKey:@"quantity"],@"productQty", nil];
    }

    NSMutableArray *prodctArr = [[NSMutableArray alloc]init];
    [prodctArr addObject:prodDict];

    NSDictionary *listDict = [NSDictionary dictionaryWithObjectsAndKeys:prodctArr,@"listItems", nil];
    
    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",[[NSUserDefaults standardUserDefaults]stringForKey:@"userMail"],@"ovclid", @"WISHLIST",@"listType",@"WishList",@"listName",listDict, @"payload",nil];
    data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    
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
        self.view.userInteractionEnabled = YES;
        
        UIAlertView *alrView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"your product sucessfully added to wishlist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alrView.tag=103;
        [alrView show];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
    }];
    
    [operation start];

    

}

// remove item from WishList
- (void)deleleApi{
    self.view.userInteractionEnabled = NO;
    
    NSString *productId = delegate.productId;
    NSString *itemId = delegate.itemIdxId;
    NSMutableDictionary *userData;
    if ([delegate.naviPath isEqualToString:@"shopperview"]) {
      
       userData=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",[[NSUserDefaults standardUserDefaults] stringForKey:@"userMail"],@"loyaltyId",@"WISHLIST",@"listType",@"WishList",@"listName",productId,@"productId",itemId,@"itemIdx",nil];

    }else{
        userData=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"demoRetailer",@"retailerId",[[NSUserDefaults standardUserDefaults] stringForKey:@"userMail"],@"loyaltyId",@"WISHLIST",@"listType",@"WishList",@"listName",productId,@"productId",itemId,@"itemIdx",nil];
 
    }
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eCommerce",@"username",@"changeme",@"password",@"dUUID",@"deviceId",@"external",@"source",userData,@"data",nil];
    NSString *link=@"POSMClient/json/process/execute/RemoveFromWishlist";
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    //                NSURLRequest  *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
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
       
        [self removeApi:delegate.productId itemId:delegate.itemIdxId];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
    }];
    
    [operation start];
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
        
        if ([delegate.naviPath isEqualToString:@"shopperview"]) {
            
            [delegate.dataBaseObj removeProductFromWishlist:delegate.productId tableName:@"shopper_tbl"];
            
            MyShopperViewController *shopperObj=[[MyShopperViewController alloc]init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:shopperObj];
            navigationController.viewControllers = controllers;
            
            
        }else{
            
            [delegate.dataBaseObj removeProductFromWishlist:delegate.productId tableName:@"wishlist_tbl"];
            
            MyWishViewController *wishObj=[[MyWishViewController alloc]init];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:wishObj];
            navigationController.viewControllers = controllers;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Connected Failed:%@",error.localizedDescription);
        self.view.userInteractionEnabled=YES;
        UIAlertView *alertObj = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertObj show];
    }];
    
    [operation start];

   

}
//remove item from SHOPPER LIST
- (void)removeApishoperList:(NSString *)productId itemId:(NSString *)itemId{
    
    
    
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
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn) {
        
        NSLog(@"Connection Successful");
        
    } else {
        
        NSLog(@"Connection could not be made");
        
    }
    
   /*
   */
}




-(void)viewWillDisappear:(BOOL)animated{
    self.menuContainerViewController.menuWidth = 80;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
