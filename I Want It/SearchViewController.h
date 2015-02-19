//
//  SearchViewController.h
//  OVC-MOBILE
//
//  Created by macs on 25/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ProductViewController.h"
#import "SideOptionViewController.h"

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchDisplayController *searchDisplay;
    NSMutableArray *prodArray;
    NSMutableArray *searchResults;
    BOOL isSearch;
    AppDelegate *delegate;
}

@end
