//
//  LSPushSenderViewController.m
//  LSPush
//
//  Created by Bobie on 1/13/14.
//  Copyright (c) 2014 Herxun. All rights reserved.
//

#import "LSPushSenderViewController.h"
#import "HXNavItemButton.h"
#import "UICommonUtility.h"

@interface LSPushSenderViewController ()

/* UI elements */
@property (strong) HXNavItemButton* btnLogout;
@property (strong) UIView* sendTextPushView;
@property (strong) UIView* sendLinkPushView;
@property (strong) UIView* sendImagePushView;
@property (strong) UIView* sendInnerLinkPushView;
@property (strong) UIView* sendVideoPushView;

/* controls */
@property (strong) NSMutableArray* arrayTabButtons;

@end

@implementation LSPushSenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self prepareSenderView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Sender";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareSenderView
{
    [self.view setBackgroundColor:[UICommonUtility hexToColor:0xF2F2F2 withAlpha:[NSNumber numberWithFloat:1.0f]]];
    
    if (!self.btnLogout)
    {
        CGFloat fLogoutBtnSize = 44.0f;
        self.btnLogout = [[HXNavItemButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, fLogoutBtnSize, fLogoutBtnSize)];
        [self.btnLogout addTarget:self action:@selector(logoutClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.btnLogout setImage:[UIImage imageNamed:@"navbaricon_logout.png"] forState:UIControlStateNormal];
        [self.btnLogout setImage:[UIImage imageNamed:@"navbaricon_logout.png"] forState:UIControlStateHighlighted];
        
        /* trick: this dummy view is for hacking the origin setting of the buttono */
        UIView* btnDummyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.btnLogout.frame.size.width, self.btnLogout.frame.size.height)];
        [btnDummyView addSubview:self.btnLogout];
        BOOL biOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f);
        btnDummyView.bounds = CGRectOffset(btnDummyView.bounds, (biOS7)? -7.0f : 5.0f, 0.0f);
        
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnDummyView];
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
    
    
    /* buttons for 5 functionalities */
    CGSize screenSize = [UICommonUtility getScreenSize];
    CGFloat fBtnSize = 45.0f, fBtnSideMargin = 13.0f;
    CGFloat fBtnGap = (screenSize.width - 2*fBtnSideMargin - 5*fBtnSize)/4;
    
    if (!self.arrayTabButtons)
    {
        self.arrayTabButtons = [NSMutableArray arrayWithCapacity:0];
    }
    [self.arrayTabButtons removeAllObjects];

    UIButton* btnSendTextPush = [[UIButton alloc] initWithFrame:CGRectMake(fBtnSideMargin, fBtnSideMargin, fBtnSize, fBtnSize)];
    [self.view addSubview:btnSendTextPush];
    [btnSendTextPush setImage:[UIImage imageNamed:@"tabicon_message_up.png"] forState:UIControlStateNormal];
    [btnSendTextPush setImage:[UIImage imageNamed:@"tabicon_message_select.png"] forState:UIControlStateHighlighted];
    [btnSendTextPush setImage:[UIImage imageNamed:@"tabicon_message_select.png"] forState:UIControlStateSelected];
    [btnSendTextPush setTag:0];
    [btnSendTextPush addTarget:self action:@selector(showPushFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrayTabButtons addObject:btnSendTextPush];
    
    UIButton* btnSendLinkPush = [[UIButton alloc] initWithFrame:CGRectMake(fBtnSideMargin+(fBtnSize+fBtnGap), fBtnSideMargin, fBtnSize, fBtnSize)];
    [self.view addSubview:btnSendLinkPush];
    [btnSendLinkPush setImage:[UIImage imageNamed:@"tabicon_link_up.png"] forState:UIControlStateNormal];
    [btnSendLinkPush setImage:[UIImage imageNamed:@"tabicon_link_select.png"] forState:UIControlStateHighlighted];
    [btnSendLinkPush setImage:[UIImage imageNamed:@"tabicon_link_select.png"] forState:UIControlStateSelected];
    [btnSendLinkPush setTag:1];
    [btnSendLinkPush addTarget:self action:@selector(showPushFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrayTabButtons addObject:btnSendLinkPush];
    
    UIButton* btnSendImagePush = [[UIButton alloc] initWithFrame:CGRectMake(fBtnSideMargin+2*(fBtnSize+fBtnGap), fBtnSideMargin, fBtnSize, fBtnSize)];
    [self.view addSubview:btnSendImagePush];
    [btnSendImagePush setImage:[UIImage imageNamed:@"tabicon_image_up.png"] forState:UIControlStateNormal];
    [btnSendImagePush setImage:[UIImage imageNamed:@"tabicon_image_select.png"] forState:UIControlStateHighlighted];
    [btnSendImagePush setImage:[UIImage imageNamed:@"tabicon_image_select.png"] forState:UIControlStateSelected];
    [btnSendImagePush setTag:2];
    [btnSendImagePush addTarget:self action:@selector(showPushFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrayTabButtons addObject:btnSendImagePush];
    
    UIButton* btnSendInnerLinkPush = [[UIButton alloc] initWithFrame:CGRectMake(fBtnSideMargin+3*(fBtnSize+fBtnGap), fBtnSideMargin, fBtnSize, fBtnSize)];
    [self.view addSubview:btnSendInnerLinkPush];
    [btnSendInnerLinkPush setImage:[UIImage imageNamed:@"tabicon_innerlink_up.png"] forState:UIControlStateNormal];
    [btnSendInnerLinkPush setImage:[UIImage imageNamed:@"tabicon_innerlink_select.png"] forState:UIControlStateHighlighted];
    [btnSendInnerLinkPush setImage:[UIImage imageNamed:@"tabicon_innerlink_select.png"] forState:UIControlStateSelected];
    [btnSendInnerLinkPush setTag:3];
    [btnSendInnerLinkPush addTarget:self action:@selector(showPushFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrayTabButtons addObject:btnSendInnerLinkPush];
    
    UIButton* btnSendVideoPush = [[UIButton alloc] initWithFrame:CGRectMake(fBtnSideMargin+4*(fBtnSize+fBtnGap), fBtnSideMargin, fBtnSize, fBtnSize)];
    [self.view addSubview:btnSendVideoPush];
    [btnSendVideoPush setImage:[UIImage imageNamed:@"tabicon_video_up.png"] forState:UIControlStateNormal];
    [btnSendVideoPush setImage:[UIImage imageNamed:@"tabicon_video_select.png"] forState:UIControlStateHighlighted];
    [btnSendVideoPush setImage:[UIImage imageNamed:@"tabicon_video_select.png"] forState:UIControlStateSelected];
    [btnSendVideoPush setTag:4];
    [btnSendVideoPush addTarget:self action:@selector(showPushFunctionView:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrayTabButtons addObject:btnSendVideoPush];
}

#pragma mark - button functions
- (void)logoutClicked
{
    NSLog(@"logout sender");
}

- (void)showPushFunctionView:(id)sender
{
    UIButton* tabButton = (UIButton*)sender;
    NSInteger nBtnIndex = tabButton.tag;

    for (UIButton* button in self.arrayTabButtons)
    {
        [button setSelected:[button isEqual:tabButton]];
    }
    
    switch (nBtnIndex) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
            
        default:
            break;
    }
}

@end
