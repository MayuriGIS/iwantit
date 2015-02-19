//
//  ProductViewController.m
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController (){
    UIScrollView *itemScroll;
    UIButton *backBtn,*sideMenuBtn;
    UILabel *titleLbl,*productPrice;
    UIView *popUpView;
    int i;
}

@end

@implementation ProductViewController
@synthesize addBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeTheChange) name:@"theChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBtn) name:@"removeBtn" object:nil];
    NSLog(@"product:%@",delegate.productDict);
    self.view.backgroundColor = [UIColor whiteColor];
    AddOptionViewController *AddObjMenu = [[AddOptionViewController alloc]init];
    self.menuContainerViewController.rightMenuViewController = AddObjMenu;
   
    
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

    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0,0,40,64);
    addBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    
    itemScroll = [[UIScrollView alloc]init];
    itemScroll.backgroundColor = [UIColor whiteColor];
    itemScroll.showsVerticalScrollIndicator= NO;
    [self.view addSubview:itemScroll];
  
    
    AsyncImageView *imageView = [[AsyncImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    
    if ([[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0] objectForKey:@"mainImageId"] != (id) [NSNull null] && ![[[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0] objectForKey:@"mainImageId"]  isEqual: @""] ) {
        
        [imageView setImageURL:[NSURL URLWithString:[[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0] objectForKey:@"mainImageId"]]];
    }else{
        imageView.image = [UIImage imageNamed:@"noimg"];
    }
    [itemScroll addSubview:imageView];
    
    UILabel *productName = [[UILabel alloc]init];
    productName.numberOfLines = 0;
    productName.text = [[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0] objectForKey:@"name"];
    productName.font = [UIFont fontWithName:@"Kailasa" size:16.0];
    [itemScroll addSubview:productName];
    
    float price = [delegate.proAmount floatValue];
    productPrice = [[UILabel alloc]init];
    productPrice.text = [NSString stringWithFormat:@"$%0.2f",price];
    productPrice.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16.0];
    productPrice.textAlignment=NSTextAlignmentCenter;
    productPrice.textColor = [UIColor colorWithRed:33.0f/255.0f green:164.0f/255.0f  blue:144.0f/255.0f alpha:1];
    [itemScroll addSubview:productPrice];
    if ([delegate.naviPath isEqualToString:@"scanView"]){
        productPrice.hidden=YES;
    }else{
        productPrice.hidden=NO;
    }
    
    UILabel *productDetailLbl = [[UILabel alloc]init];
    productDetailLbl.text = @"Description:";
    productDetailLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
    [itemScroll addSubview:productDetailLbl];
    
    UITextView *productDetail = [[UITextView alloc]init];
    
    NSString *htmlString = [[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0] objectForKey:@"description"];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    productDetail.userInteractionEnabled = NO;
    [itemScroll addSubview:productDetail];
    
    CGRect txtSize =
    [attributedString boundingRectWithSize:CGSizeMake(300.f, 480)
                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 context:nil];
    productDetail.attributedText = attributedString;
    productDetail.font = [UIFont fontWithName:@"Kailasa" size:12.0];

    if (IS_IPHONE4) {
       
        itemScroll.frame = CGRectMake(0, 0, 320, 480);
        
    }else{
        
        itemScroll.frame = CGRectMake(0, 0, 320, 505);

    }
//    [itemScroll addParallaxWithView:imageView andHeight:177];
    
    
    imageView.frame = CGRectMake(0, 0, 320, 180);
    
    CGRect nameSize = [[[[[delegate.productDict objectForKey:@"data"] objectForKey:@"SearchObjectList"] objectAtIndex:0] objectForKey:@"name"] boundingRectWithSize:CGSizeMake(250.0f, 480.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Kailasa" size:16.0]} context:nil];

    productName.frame = CGRectMake(10, imageView.frame.origin.y + imageView.frame.size.height + 5, 240, nameSize.size.height + 10);
    productPrice.frame = CGRectMake(230, imageView.frame.origin.y + imageView.frame.size.height + 5, itemScroll.frame.size.width - productName.frame.size.width+30, productName.frame.size.height);
    productDetailLbl.frame = CGRectMake(10, productName.frame.origin.y + productName.frame.size.height,250, 30);
    productDetail.frame = CGRectMake(10, productDetailLbl.frame.size.height+productDetailLbl.frame.origin.y-5, 300, txtSize.size.height+220);
    itemScroll.contentSize = CGSizeMake(320, productDetail.frame.size.height+productDetail.frame.origin.y+20);
    
    popUpView = [[UIView alloc]init];
    popUpView.hidden = YES;
    popUpView.tag = 50;
    popUpView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.view addSubview:popUpView];
    
    existBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    existBtn.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
    [existBtn setTitle:@"Add to existing appoinment" forState:UIControlStateNormal];
    existBtn.titleLabel.font = [UIFont fontWithName:@"Kailasa" size:15.0];
    [existBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [existBtn addTarget:self action:@selector(existBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:existBtn];
    
    newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:66.0f/255.0f  blue:99.0f/255.0f alpha:1];
    newBtn.titleLabel.font = [UIFont fontWithName:@"Kailasa" size:15.0];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"Create new appoinment" forState:UIControlStateNormal];
    [newBtn addTarget:self action:@selector(newBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:newBtn];


    if (IS_IPHONE4) {
        
        popUpView.frame = CGRectMake(0, 0, 320, 480);
        existBtn.frame = CGRectMake(60, 190, 200, 40);
        newBtn.frame = CGRectMake(60, 250, 200, 40);

    }else{
        
        popUpView.frame = CGRectMake(0, 0, 320, 568);
        existBtn.frame = CGRectMake(60, 234, 200, 40);
        newBtn.frame = CGRectMake(60, 304, 200, 40);

    }

    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0,0,200,44);
    titleLbl.text = @"Item Name";
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18.0];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    self.navigationItem.titleView = titleLbl;

}

- (void)menuBtnAction {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}


-(void)backBtnAct{
    if ([delegate.naviPath isEqual:@"shopperview"]) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if ([delegate.naviPath isEqual:@"searchView"]){
        
        [self.navigationController popViewControllerAnimated:YES];

    }else{
       
        MyWishViewController *myObj = [[MyWishViewController alloc]init];
        [self.navigationController pushViewController:myObj animated:NO];

    }
    
}

-(void)addBtnAct{
    
    [addBtn setHidden:YES];
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)newBtnAction{
    
    popUpView.hidden = YES;
    delegate.popUpEnable=NO;

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
    delegate.popUpEnable=NO;

}

- (void)hideBtn{
    
    [addBtn setHidden:YES];
    
}

- (void)makeTheChange{
   
    [addBtn setHidden:NO];
    if ([delegate.naviPath isEqual:@"shopperview"] || [delegate.naviPath isEqual:@""] ) {
        
    }else{
    
    if (delegate.popUpEnable) {
        
        popUpView.hidden = NO;
        
    }else{
        
        popUpView.hidden = YES;
        
    }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"theChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeBtn" object:nil];
    self.menuContainerViewController.rightMenuViewController=nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
