//
//  SideOptionViewController.m
//  OVC-MOBILE
//
//  Created by macs on 20/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import "SideOptionViewController.h"
@interface SideOptionViewController (){
    
    int selectedIndex;
}

@end

@implementation SideOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedIndex = 1;
    self.menuContainerViewController.menuWidth = 80;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.view.backgroundColor=[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1];
    self.menuContainerViewController.menuWidth = 80;
    
    unSeleImg = [[NSMutableArray alloc]initWithObjects:@"beacon_unselbtn", @"wishlist_unselbtn",@"appointment_unselbtn",@"shopper_unselbtn",@"scan_unselbtn",@"search_unselbtn",@"logout_unselbtn", nil];
    
    seleImg = [[NSMutableArray alloc]initWithObjects:@"beacon_selbtn", @"wishlist_selbtn",@"appointment_selbtn",@"sho_selbtn",@"scan_selbtn",@"search_selbtn",@"logout_selbtn", nil];
    

    UIImageView *LogoIcon = [[UIImageView alloc]init];
    LogoIcon.image = [UIImage imageNamed:@"logo"];
    LogoIcon.frame = CGRectMake(0,8,80,80);
    [self.view addSubview:LogoIcon];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.frame = CGRectMake(0,88,80,476);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    if (IS_IPHONE4) {
        
        tableView.frame = CGRectMake(0, tableView.frame.origin.y, tableView.frame.size.width,480 - tableView.frame.origin.y);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return seleImg.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 79;
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
    iconView.frame = CGRectMake(0,0,80, 80);
    iconView.backgroundColor = [UIColor whiteColor];
    
    if (selectedIndex == indexPath.row) {
        if ( indexPath.row == 5) {
            iconView.image = [UIImage imageNamed:[unSeleImg objectAtIndex:indexPath.row]];
        }else{
            iconView.image = [UIImage imageNamed:[seleImg objectAtIndex:indexPath.row]];
        }
    }else{
        iconView.image = [UIImage imageNamed:[unSeleImg objectAtIndex:indexPath.row]];
    }
    [cell addSubview:iconView];
    cell.backgroundColor=[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    selectedIndex = (int)indexPath.row;
    [tableView reloadData];
    
    if (indexPath.row==0) {
        
        iBeaconViewController *searchObj = [[iBeaconViewController alloc] init];
       
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:searchObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }else if (indexPath.row==1) {
        
        MyWishViewController *wishObj = [[MyWishViewController alloc] init];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:wishObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }else if (indexPath.row==2){
        
        delegate.naviPath=@"appointment";
        AppointmentViewController *appObj = [[AppointmentViewController alloc] init];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:appObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }else if (indexPath.row==3){
        MyShopperViewController *myShopObj = [[MyShopperViewController alloc] init];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:myShopObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }else if (indexPath.row==4){
        delegate.naviPath=@"scanView";
        ScanViewController *scanObj = [[ScanViewController alloc] init];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:scanObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }else if (indexPath.row==5){
       
        SearchViewController *scanObj = [[SearchViewController alloc] init];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:scanObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    }else{
        [delegate.dataBaseObj deleteAllTables];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstTime"];
        LoginViewController *logObj=[[LoginViewController alloc]init];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:logObj];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        selectedIndex = 1;
    }
}

- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
