//
//  ChatScreen.m
//
//
//  Created by mac4 on 09/10/14.
//  Copyright (c) 2014 Great Innovus Solutions. All rights reserved.
//

#import "ChatScreen.h"

@interface ChatScreen (){
    
    UIButton *backBtn,*sideMenuBtn,*cameraBtn;
    UILabel * titleLbl;
    UIImage *chosenImage;
    BOOL shf,cameraImage;
    int i,k;
    NSMutableArray *opptArray;
    NSString *currentTime;
}

@end

@implementation ChatScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
    }

    shf = YES;
    messageArr = [[NSMutableArray alloc]initWithCapacity:0];
    opptArray = [[NSMutableArray alloc]initWithObjects:@"Yes",@"Ok",@"nice",@"amazing", nil];
    NSLog(@"navigation height:%f , self height:%f",self.navigationController.navigationBar.frame.size.height,self.view.frame.size.height);
    i = 0;
    k = 0;
    
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
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftA = [[UIBarButtonItem alloc]initWithCustomView:sideMenuBtn];
    UIBarButtonItem *leftB = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:leftA,leftB, nil];

    self.view.backgroundColor=[UIColor whiteColor];
    chatTable = [[UITableView alloc]init];
    chatTable.backgroundColor = [UIColor clearColor];
    chatTable.dataSource = self;
    chatTable.delegate = self;
    chatTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:chatTable];
    
    containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1.0f];
    containerView.layer.borderWidth = 0.5f;
    containerView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:containerView];
    
    chatTextView = [[HPGrowingTextView alloc]init];
    chatTextView.backgroundColor = [UIColor whiteColor];
    chatTextView.delegate = self;
    chatTextView.layer.cornerRadius = 5;
    chatTextView.layer.masksToBounds = YES;
    chatTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    chatTextView.isScrollable = NO;
    [containerView addSubview:chatTextView];
    
    
    cameraBtn = [[UIButton alloc]init];
    cameraBtn.frame = CGRectMake(0,5,40,40);
    [cameraBtn setImage:[UIImage imageNamed:@"cameragrey_icon"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraBtnAct) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:cameraBtn];
    
    
    if (IS_IPHONE4) {
        
        chatTable.frame = CGRectMake(0, 0, 320, 415);
        containerView.frame = CGRectMake(0,365, 320, 50);
        chatTextView.frame = CGRectMake(40, 10, 260, 30);
        
        
    }else{
        
        chatTable.frame = CGRectMake(0, 0, 320, 505);
        containerView.frame = CGRectMake(0, 455, 320, 50);
        chatTextView.frame = CGRectMake(40, 10, 260, 30);
        
    }
    
    chatTextView.font = [UIFont fontWithName:@"OpenSans" size:15];
}

-(void)viewWillAppear:(BOOL)animated{
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    self.navigationController.navigationBarHidden = NO;
    
    titleLbl = [[UILabel alloc]init];
    titleLbl.frame = CGRectMake(0, 0, 200, 44);
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:18];
    titleLbl.text = @"My Shopper";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    self.navigationItem.titleView = titleLbl;
}


- (void)backBtnAction{
    [cameraBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction{
   
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    currentTime = [dateFormatter stringFromDate:today];

    if(![chatTextView.text isEqualToString:@""]){
        
        
        NSString *message = chatTextView.text;
        [messageArr addObject:@[@"1",[NSString stringWithFormat:@"%@",message] ,currentTime,@"str"]];
            shf=YES;
 
        [chatTable reloadData];
        [chatTextView resignFirstResponder];
        NSUInteger index = messageArr.count - 1;
        [chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        chatTextView.text = @"";
        [sendBtn removeFromSuperview];
        sendBtn = nil;
        
        if (IS_IPHONE4) {
            containerView.frame = CGRectMake(0, 365, 320, 50);
            chatTextView.frame = CGRectMake(40, 10, 260, 30);
        }else{
            containerView.frame = CGRectMake(0, 455, 320, 50);
            chatTextView.frame = CGRectMake(40, 10, 260, 30);
        }
    }
    [self performSelector:@selector(opptAction) withObject:nil afterDelay:1];
}

-(void)opptAction{
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    currentTime = [dateFormatter stringFromDate:today];

    int randNum = [self randomNumberBetween:0 maxNumber:3];
    
    [messageArr addObject:@[@"0",[NSString stringWithFormat:@"%@",[opptArray objectAtIndex:randNum]] ,currentTime,@"str"]];
    [chatTable reloadData];
    NSUInteger index = messageArr.count - 1;
    [chatTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform(max - min + 1);
}

#pragma mark UITableView Data Source Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messageArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if ([[[messageArr objectAtIndex:indexPath.row]lastObject] isEqualToString:@"img"]) {
        return 270;
    }else{
       
        NSString *body = [[messageArr objectAtIndex:indexPath.row] objectAtIndex:1];
        CGSize size = [body sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height + 40;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *label, *msgTime;
    UIView *message;
    UIImageView *balloonView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        balloonView= [[UIImageView alloc] initWithFrame:CGRectZero];
        balloonView.tag = 1;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentJustified;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        msgTime = [[UILabel alloc]init];
        msgTime.tag = 3;
        msgTime.textAlignment = NSTextAlignmentRight;
        
        if([[[messageArr objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"1"]){
            label.textColor = [UIColor whiteColor];
            msgTime.textColor = [UIColor whiteColor];

        }else{
            label.textColor = [UIColor blackColor];
            msgTime.textColor = [UIColor grayColor];
            
        }

        label.font = [UIFont systemFontOfSize:14];
        msgTime.font = [UIFont systemFontOfSize:10];
        
        message = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, cell.frame.size.height)];
        message.tag = 0;
        [message addSubview:balloonView];
        [message addSubview:msgTime];
        [message addSubview:label];
        [cell.contentView addSubview:message];
    }
    else
    {
        balloonView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
        label = (UILabel *)[[cell.contentView viewWithTag:0] viewWithTag:2];
        msgTime = (UILabel *)[[cell.contentView viewWithTag:0]viewWithTag:3];
    }
    
    NSString *messageText = [[messageArr objectAtIndex:indexPath.row] objectAtIndex:1];
    NSString *messageTime = [[messageArr objectAtIndex:indexPath.row] objectAtIndex:2];
    CGSize msgSize, timeSize;
    msgSize = [messageText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(220.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    timeSize = [messageTime sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(220.0f, 480.0f) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size;
    if (msgSize.width > timeSize.width) {
        size = msgSize;
        size.width = size.width + 40;
    }else{
        size = timeSize;
        size.width = size.width + 40;
    }
    
    UIImage *balloon;
    
    if([[[messageArr objectAtIndex:indexPath.row] objectAtIndex:0] isEqualToString:@"1"]){

        if ([[[messageArr objectAtIndex:indexPath.row]lastObject] isEqualToString:@"img"]) {
           
            balloonView.frame = CGRectMake(50, 2.0, 260,260);

            balloon=[UIImage imageWithContentsOfFile:[[messageArr objectAtIndex:indexPath.row]objectAtIndex:1]];
            msgTime.frame=CGRectMake(235 ,balloonView.frame.size.height-15, 60, 25);
            msgTime.text = [[messageArr objectAtIndex:indexPath.row] objectAtIndex:2];

        }else{
            balloonView.frame = CGRectMake(315 - size.width, 2.0, size.width, size.height + 35);
            balloon = [[UIImage imageNamed:@"chat_bluebubble"]
                       stretchableImageWithLeftCapWidth:24 topCapHeight:15];
            label.frame = CGRectMake(325 - size.width, 7, size.width - 20, size.height);
            label.text = messageText;

            msgTime.frame=CGRectMake(235 ,size.height + 5, 60, 25);
            msgTime.text = [[messageArr objectAtIndex:indexPath.row] objectAtIndex:2];
        }
    }
    else
    {
        balloonView.frame = CGRectMake(5, 5.0, size.width - 15, size.height + 35);
        balloon = [[UIImage imageNamed:@"chat_greybubble"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        label.frame = CGRectMake(20,7, size.width - 40, size.height);
        msgTime.frame=CGRectMake(size.width - 85, size.height + 5, 65, 25);
        msgTime.text = [[messageArr objectAtIndex:indexPath.row] objectAtIndex:2];
        if ([[[messageArr objectAtIndex:indexPath.row]lastObject] isEqualToString:@"img"]) {
            
            balloon=[UIImage imageWithContentsOfFile:[[messageArr objectAtIndex:indexPath.row]objectAtIndex:1]];
            
        }else{
            label.text = messageText;
        }
    }
    
    balloonView.image = balloon;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}



- (void)keyboardWillShow:(NSNotification *)notif {

    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = [UIColor clearColor];
    [sendBtn setTitleColor:[UIColor colorWithRed:18/255.0f green:165/255.0f blue:244/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    if (IS_IPHONE4) {
        containerView.frame = CGRectMake(0, 365, 320, 50);
        chatTextView.frame = CGRectMake(40, 10, 210, 30);
        sendBtn.frame = CGRectMake(260,10,60, 60);
        sendBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:28];
    }else{
        containerView.frame = CGRectMake(0, 505, 320, 50);
        chatTextView.frame = CGRectMake(40,10, 210, 30);
        sendBtn.frame = CGRectMake(260,5,60, 40);
        sendBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
        
    }

    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [containerView addSubview:sendBtn];

    CGRect keyboardBounds;
    [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (chatTextView.frame.size.height - height);
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y+=diff;
    containerView.frame = r;
}

-(void)resignTextView
{
    [chatTextView resignFirstResponder];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    containerView.frame = containerFrame;
}


-(void)cameraBtnAct{
    
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"No camera available" message: @"Failed to take image" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSData *imgData =UIImageJPEGRepresentation(chosenImage,0);
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentdir =[paths objectAtIndex:0];
    NSString *imagePath = [documentdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpeg",k]];
    
    if (![imgData writeToFile:imagePath  atomically:NO]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save image" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        i = 1;
        k = k + 1;
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        currentTime = [dateFormatter stringFromDate:today];

        [messageArr addObject:@[@"1",[NSString stringWithFormat:@"%@",imagePath] ,currentTime,@"img"]];
        shf=YES;
        [chatTable reloadData];

        [self performSelector:@selector(opptAction) withObject:nil afterDelay:1.5];

        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

- (void)menuBtnAction {

    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    self.menuContainerViewController.menuWidth = 80;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
