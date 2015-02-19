//
//  ChatScreen.h
//  TeleDoutor
//
//  Created by mac4 on 09/10/14.
//  Copyright (c) 2014 Great Innovus Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "MFSideMenu.h"
@interface ChatScreen : UIViewController<HPGrowingTextViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UITableView *chatTable;
    HPGrowingTextView *chatTextView;
    UIView *containerView;
    NSMutableArray *messageArr;
    UIButton *sendBtn;
}

@end
