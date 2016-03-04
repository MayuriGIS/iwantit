//
//  ProductViewController.h
//  OVC-MOBILE
//
//  Created by macs on 21/11/14.
//  Copyright (c) 2014 macs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddOptionViewController.h"
#import "MyWishViewController.h"
#import "AppDelegate.h"
@interface ProductViewController : UIViewController{
    AppDelegate *delegate;
    UIButton *existBtn, *newBtn;
    UITextView *productDetail;
}
@property (nonatomic) UIButton *addBtn;

@end
