//
//  ViewController.m
//  LSPush
//
//  Created by Bobie on 4/17/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import "ViewController.h"
#import "AnPush.h"
#import "LightspeedCredentials.h"
#import "LSPushGenericNaviController.h"
#import "LSPushSenderViewController.h"
#import "UICommonUtility.h"
#import "LightspeedAPIManager.h"

#define IPHONE_SCREEN_WIDTH                 320.0f
#define IPHONE_SCREEN_HEIGHT                480.0f
#define IPHONE5_SCREEN_HEIGHT               568.0f

#define LOGINVIEW_X_OFFSET                  25.0f
#define LOGINVIEW_Y_OFFSET                  255.0f
#define LOGINVIEW_Y_OFFSET_4IN              335.0f
#define LOGINVIEW_WIDTH                     270.0f
#define LOGINVIEW_HEIGHT                    148.0f
#define LOGINVIEW_TEXTFIELD_HEIGHT          45.0f
#define LOGINVIEW_TEXTFIELD_BGCOLOR         0x323232
#define LOGINVIEW_TEXTFIELD_TEXTCOLOR       0x939393
#define LOGINVIEW_TEXTFIELD_FONTSIZE        14.0f
#define LOGINVIEW_TEXTFIELD_FONTNAME        @"Avenir Next"
#define LOGINVIEW_ICON_WIDTH                38.0f
#define LOGINVIEW_ITEM_GAP                  7.0f
#define LOGINVIEW_BUTTON_WIDTH              105.f
#define LOGINVIEW_BUTTON_HEIGHT             44.f

#define LIGHTSPEED_API_BASEURL              @"http://api.lightspeedmbs.com/v1"
#define LIGHTSPEED_API_HTTP_METHOD          @"POST"
#define LIGHTSPEED_API_LOGIN                @"admins/login.json"
#define LIGHTSPEED_API_SEND_PUSH            @"push_notification/send.json"

#define USERDEFAULTS_USERNAME               @"LSUsername"
#define USERDEFAULTS_PASSWORD               @"LSPassword"

@interface ViewController () <UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong) UIView* loginView;
@property (strong) UILabel* labelAPIResult;
@property (strong) UIActivityIndicatorView* actIndicator;
@property (strong) UIView* welcomeView;

@property (strong) LSPushGenericNaviController* senderNavController;

@end

@implementation ViewController
{
    NSMutableData* m_receivedData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenBound.size.height;
    
    UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, screenHeight)];
    bgView.image = [UIImage imageNamed:(screenHeight == IPHONE5_SCREEN_HEIGHT)? @"640x1136.png" : @"640x960.png"];
    [self.view addSubview:bgView];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self prepareLoginView];
}

- (void)prepareLoginView
{
    CGSize screenSize = [UICommonUtility getScreenSize];
    
    BOOL biOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);
    CGFloat fBtnTop = (biOS7)? 373.0f : 302.0f;
    CGFloat fBtnWidth = 270.0f, fBtnHeight = 45.0f;

    /* receiver login button */
    UIButton* btnLoginReceiver = [[UIButton alloc] initWithFrame:CGRectMake((screenSize.width - fBtnWidth)/2, fBtnTop, fBtnWidth, fBtnHeight)];
    [self.view addSubview:btnLoginReceiver];
    [btnLoginReceiver setImage:[UIImage imageNamed:@"login_bu_up.png"] forState:UIControlStateNormal];
    [btnLoginReceiver setImage:[UIImage imageNamed:@"login_bu_down.png"] forState:UIControlStateHighlighted];
    [btnLoginReceiver addTarget:self action:@selector(loginReceiver) forControlEvents:UIControlEventTouchUpInside];

    UILabel* labelBtnReceiver = [[UILabel alloc] initWithFrame:CGRectZero];
    [btnLoginReceiver addSubview:labelBtnReceiver];
    [labelBtnReceiver setBackgroundColor:[UIColor clearColor]];
    [labelBtnReceiver setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
    [labelBtnReceiver setTextColor:[UIColor whiteColor]];
    [labelBtnReceiver setNumberOfLines:0];
    [labelBtnReceiver setTextAlignment:NSTextAlignmentCenter];
    [labelBtnReceiver setText:@"Receiver"];
    [labelBtnReceiver sizeToFit];
    
    CGRect frame = labelBtnReceiver.frame;
    frame.origin.x = (fBtnWidth - frame.size.width)/2;
    frame.origin.y = (fBtnHeight - frame.size.height)/2;
    labelBtnReceiver.frame = frame;
    
    
    /* sender login button */
    UIButton* btnLoginSender = [[UIButton alloc] initWithFrame:CGRectMake((screenSize.width - fBtnWidth)/2, fBtnTop + 10.0f + fBtnHeight, fBtnWidth, fBtnHeight)];
    [self.view addSubview:btnLoginSender];
    [btnLoginSender setImage:[UIImage imageNamed:@"login_bu_up.png"] forState:UIControlStateNormal];
    [btnLoginSender setImage:[UIImage imageNamed:@"login_bu_down.png"] forState:UIControlStateHighlighted];
    [btnLoginSender addTarget:self action:@selector(loginSender) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* labelBtnSender = [[UILabel alloc] initWithFrame:CGRectZero];
    [btnLoginSender addSubview:labelBtnSender];
    [labelBtnSender setBackgroundColor:[UIColor clearColor]];
    [labelBtnSender setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:14.0f]];
    [labelBtnSender setTextColor:[UIColor whiteColor]];
    [labelBtnSender setNumberOfLines:0];
    [labelBtnSender setTextAlignment:NSTextAlignmentCenter];
    [labelBtnSender setText:@"Sender"];
    [labelBtnSender sizeToFit];
    
    frame = labelBtnSender.frame;
    frame.origin.x = (fBtnWidth - frame.size.width)/2;
    frame.origin.y = (fBtnHeight - frame.size.height)/2;
    labelBtnSender.frame = frame;
    
    
    if (!self.labelAPIResult)
    {
        self.labelAPIResult = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        [self.labelAPIResult setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:13.0f]];
        [self.labelAPIResult setTextColor:[UIColor whiteColor]];
        
        self.labelAPIResult.numberOfLines = 2;
    }
    [self.labelAPIResult setHidden:YES];
}

- (void)displayResult:(BOOL)success withMessage:(NSString*)message
{
    self.labelAPIResult.text = message;
    
    CGRect textSize = [self.labelAPIResult textRectForBounds:CGRectMake(0, 0, 320, 50) limitedToNumberOfLines:2];
    self.labelAPIResult.frame = textSize;
    
    CGRect frame = self.labelAPIResult.frame;
    frame.origin.x = (IPHONE_SCREEN_WIDTH - self.labelAPIResult.frame.size.width) / 2;
    frame.origin.y = (self.view.frame.size.height - 50) + (50 - self.labelAPIResult.frame.size.height)/2;
    self.labelAPIResult.frame = frame;
    [self.labelAPIResult setBackgroundColor:[UIColor clearColor]];
    
    [self.actIndicator stopAnimating];
    [self.view addSubview:self.labelAPIResult];
    [self.labelAPIResult setHidden:NO];
}

- (void)updateLoginCredentials:(NSString*)strUsername andPassword:(NSString*)strPassword
{
    [[NSUserDefaults standardUserDefaults] setValue:strUsername forKey:USERDEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] setValue:strPassword forKey:USERDEFAULTS_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button functions
- (void)loginReceiver
{
    
}

- (void)loginSender
{
    [self.labelAPIResult setHidden:YES];
    
    if (!self.actIndicator)
    {
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.actIndicator.hidesWhenStopped = YES;
        CGRect frame = self.actIndicator.frame;
        frame.origin.x = (IPHONE_SCREEN_WIDTH - frame.size.width)/2;
        frame.origin.y = self.view.frame.size.height - 35.0f;
        self.actIndicator.frame = frame;
        [self.view addSubview:self.actIndicator];
    }
    
    [self.actIndicator startAnimating];
    
    LightspeedAPIManager* lightspeedAPIManager = [LightspeedAPIManager sharedLightspeedAPIManager];
    if (lightspeedAPIManager)
    {
        NSString* strData = [NSString stringWithFormat:@"email=%@&password=%@", kstrLightspeedUsername, kstrLightspeedPassword];
        [lightspeedAPIManager sendHTTPRequest:@"admins/login.json" payload:strData completion:^(BOOL bSuccess, NSDictionary* dictMeta, NSError* error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.actIndicator stopAnimating];
                
                if (!self.senderNavController)
                {
                    LSPushSenderViewController* senderVC = [[LSPushSenderViewController alloc] init];
                    self.senderNavController = [[LSPushGenericNaviController alloc] initWithRootViewController:senderVC];
                }
                [self presentViewController:self.senderNavController animated:YES completion:nil];
            });
        }];
    }
}

- (IBAction)loginLightspeed:(id)sender
{
    if (!self.actIndicator)
    {
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.actIndicator.hidesWhenStopped = YES;
        CGRect frame = self.actIndicator.frame;
        frame.origin.x = (IPHONE_SCREEN_WIDTH - frame.size.width)/2;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        self.actIndicator.frame = frame;
        [self.view addSubview:self.actIndicator];
    }
    
//    [self loginLightspeedWithEmail:self.textEmail.text andPassword:self.textPassword.text];
}

- (IBAction)sendPushNotification:(id)sender
{
    NSLog(@"sendLightspeedPushNotification");
    if (self.labelAPIResult && !self.labelAPIResult.isHidden)
        [self.labelAPIResult setHidden:YES];
    self.btnPush.enabled = NO;
    [self.actIndicator startAnimating];
    [self sendLightspeedPushNotification];
}

- (void)changeViewAfterLoginSuccessfully
{
    /* Setup channel names to register to your own Lightspeed application */
    NSArray* arrayChannels = [NSArray arrayWithObjects:@"BroadcastMessage", @"LightspeedNews", nil ];
//    [self updateLoginCredentials:self.textEmail.text andPassword:self.textPassword.text];
    
    AnPush* anPush;
    @try {
        anPush = [AnPush shared];
    }
    @catch (NSException *exception) {
        anPush = nil;
    }
    @finally {
        
    }
    
    if (anPush)
    {
        [anPush register:arrayChannels overwrite:YES];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             CGRect frame = self.loginView.frame;
                             CGRect frame2 = self.welcomeView.frame;
                             frame2.origin.x = frame.origin.x;
                             frame.origin.x = -500;
                             self.loginView.frame = frame;
                             self.welcomeView.frame = frame2;
                             self.welcomeView.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        [self displayResult:NO withMessage:@"Lightspeed Push might not have been properly set up"];
    }
}

#pragma mark - Lightspeed API functions
- (void)loginLightspeedWithEmail:(NSString*)strEmail andPassword:(NSString*)strPassword
{
    m_receivedData = [NSMutableData data];
    
    NSString* strData = [NSString stringWithFormat:@"email=%@&password=%@", strEmail, strPassword];
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", LIGHTSPEED_API_BASEURL, LIGHTSPEED_API_LOGIN]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:LIGHTSPEED_API_HTTP_METHOD];
    [request setHTTPBody:[strData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)sendLightspeedPushNotification
{
    NSString* strAlertMessage = [NSString stringWithFormat:@"\"%@\"", @"This is a Lightspeed Push Notification"];
    NSString* strSound = [NSString stringWithFormat:@"\"%@\"", @"default"];
    NSString* strData = [NSString stringWithFormat:@"payload={\"ios\":{\"alert\":%@,\"badge\":1,\"sound\":%@}}", strAlertMessage, strSound];
    NSURL* requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?key=%@", LIGHTSPEED_API_BASEURL, LIGHTSPEED_API_SEND_PUSH, kArrownockAppKey]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:LIGHTSPEED_API_HTTP_METHOD];
    NSData* postData = [strData dataUsingEncoding:NSUTF8StringEncoding];
    NSString* postDataLengthString = [NSString stringWithFormat:@"%d", [postData length]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [m_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [m_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    NSLog(@"Connection error: %@", error);
    [self displayResult:NO withMessage:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finishes loading");
    [self.actIndicator stopAnimating];

    NSDictionary* dictData = [NSJSONSerialization JSONObjectWithData:m_receivedData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:nil];
    
    NSDictionary* dictMeta = [dictData objectForKey:@"meta"];
    if (dictMeta)
    {
        [self.labelAPIResult setHidden:NO];
        
        if ([[dictMeta objectForKey:@"code"] intValue] == 200)
        {
            if ([(NSString*)[dictMeta objectForKey:@"method"] isEqualToString:@"loginAdmin"])
            {
                BOOL success = YES;
                [self displayResult:success withMessage:@"Login Successful!!"];
//                [self performSelector:@selector(changeViewAfterLoginSuccessfully) withObject:nil afterDelay:0.5f];
                
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if (!self.senderNavController)
                    {
                        LSPushSenderViewController* senderVC = [[LSPushSenderViewController alloc] init];
                        self.senderNavController = [[LSPushGenericNaviController alloc] initWithRootViewController:senderVC];
                        [self presentViewController:self.senderNavController animated:YES completion:nil];
                    }
                });
            }
            else if ([(NSString*)[dictMeta objectForKey:@"method"] isEqualToString:@"SendMessage"])
            {
                BOOL success = YES;
                [self displayResult:success withMessage:@"Push Sent Successfully!!"];
                if (!self.btnPush.enabled)
                    self.btnPush.enabled = YES;
            }
        }
        else
        {
            BOOL success = NO;
            [self displayResult:success withMessage:(NSString*)[dictMeta objectForKey:@"message"]];
            if (!self.btnPush.enabled)
                self.btnPush.enabled = YES;
        }
    }

}

@end
