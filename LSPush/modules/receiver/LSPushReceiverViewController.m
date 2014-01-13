//
//  LSPushReceiverViewController.m
//  LSPush
//
//  Created by Bobie Chen on 2014/1/13.
//  Copyright (c) 2014年 Herxun. All rights reserved.
//

#import "LSPushReceiverViewController.h"
#import "HXNavItemButton.h"
#import "UICommonUtility.h"
#import "LSPushAppDelegate.h"

@interface LSPushReceiverViewController ()

@property (strong) HXNavItemButton* btnNews;
@property (strong) HXNavItemButton* btnLogout;

@end

@implementation LSPushReceiverViewController

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
    
    [self prepareReceiverView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Receiver";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareReceiverView
{
    [self.view setBackgroundColor:[UICommonUtility hexToColor:0xF2F2F2 withAlpha:[NSNumber numberWithFloat:1.0f]]];
    
    if (!self.btnNews)
    {
        CGFloat fNewsBtnSize = 44.0f;
        self.btnNews = [[HXNavItemButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, fNewsBtnSize, fNewsBtnSize)];
        [self.btnNews addTarget:self action:@selector(newsClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.btnNews setImage:[UIImage imageNamed:@"navbaricon_news.png"] forState:UIControlStateNormal];
        [self.btnNews setImage:[UIImage imageNamed:@"navbaricon_news.png"] forState:UIControlStateHighlighted];
        
        /* trick: this dummy view is for hacking the origin setting of the buttono */
        UIView* btnDummyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.btnNews.frame.size.width, self.btnNews.frame.size.height)];
        [btnDummyView addSubview:self.btnNews];
        BOOL biOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f);
        btnDummyView.bounds = CGRectOffset(btnDummyView.bounds, (biOS7)? 16.0f : 5.0f, 0.0f);
        
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnDummyView];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    
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
        btnDummyView.bounds = CGRectOffset(btnDummyView.bounds, (biOS7)? -16.0f : -5.0f, 0.0f);
        
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnDummyView];
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)handleRemoteNotificationUnregistrationResult:(NSNotification*)notification
{
    NSString* strResultError = (NSString*)(notification.object);
    if (strResultError && ![strResultError isEqualToString:@""])
    {
        NSLog(@"fail to (unregister) logout receiver");
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - button functions
- (void)newsClicked
{
    NSLog(@"receiver news");
}

- (void)logoutClicked
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNotificationUnregistrationResult:)
                                                 name:@"co.herxun.LSPush.unregisterRemoteNotificationResult" object:nil];
    
    LSPushAppDelegate* delegate = (LSPushAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate unregisterRemoteNotifications];
}

@end
