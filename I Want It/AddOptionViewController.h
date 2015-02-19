//
//  AddOptionViewController.h
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewController.h"
#import "AppDelegate.h"
#import "MyShopperViewController.h"
@interface AddOptionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate *delegate;
    NSMutableArray *seleImg,*unSeleImg;
}

@end
