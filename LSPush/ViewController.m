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

@interface ViewController () <UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, retain) UIView* loginView;
@property (nonatomic, retain) IBOutlet UITextField* textEmail;
@property (nonatomic, retain) IBOutlet UITextField* textPassword;
@property (nonatomic, retain) UILabel* labelAPIResult;
@property (nonatomic, retain) UIActivityIndicatorView* actIndicator;
@property (nonatomic, retain) UIView* welcomeView;

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
    bgView.image = [UIImage imageNamed:(screenHeight == IPHONE5_SCREEN_HEIGHT)? @"bg_640x1136.png" : @"bg_640x960.png"];
    [self.view addSubview:bgView];
    [bgView release];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self prepareLoginView];
    
    [self performSelectorInBackground:@selector(prepareWelcomeView) withObject:nil];
}

- (void)prepareLoginView
{
    if (!self.loginView)
    {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        self.loginView = [[[UIView alloc] initWithFrame:CGRectMake(LOGINVIEW_X_OFFSET,
                                                                  (screenHeight == IPHONE5_SCREEN_HEIGHT)? LOGINVIEW_Y_OFFSET_4IN : LOGINVIEW_Y_OFFSET,
                                                                  LOGINVIEW_WIDTH, LOGINVIEW_HEIGHT)] autorelease];
        self.loginView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.loginView];
    }
    
    UIView* dummyViewEmail = [[UIView alloc] initWithFrame:CGRectMake(LOGINVIEW_ICON_WIDTH, 0,
                                                                      LOGINVIEW_WIDTH-LOGINVIEW_ICON_WIDTH, LOGINVIEW_TEXTFIELD_HEIGHT)];
    NSArray* arrayRGB = [self hexToRGB:LOGINVIEW_TEXTFIELD_BGCOLOR];
    dummyViewEmail.backgroundColor = [UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                     green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                      blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0];
    [self.loginView addSubview:dummyViewEmail];
    [dummyViewEmail release];
    
    UIView* dummyViewPassword = [[UIView alloc] initWithFrame:CGRectMake(LOGINVIEW_ICON_WIDTH, LOGINVIEW_TEXTFIELD_HEIGHT+LOGINVIEW_ITEM_GAP,
                                                                         LOGINVIEW_WIDTH-LOGINVIEW_ICON_WIDTH, LOGINVIEW_TEXTFIELD_HEIGHT)];
    arrayRGB = [self hexToRGB:LOGINVIEW_TEXTFIELD_BGCOLOR];
    dummyViewPassword.backgroundColor = [UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                        green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                         blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0];
    [self.loginView addSubview:dummyViewPassword];
    [dummyViewPassword release];
    
    UIImageView* iconEmail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LOGINVIEW_ICON_WIDTH, LOGINVIEW_TEXTFIELD_HEIGHT)];
    iconEmail.image = [UIImage imageNamed:@"bu_email.png"];
    [self.loginView addSubview:iconEmail];
    [iconEmail release];
    
    UIImageView* iconPassword = [[UIImageView alloc] initWithFrame:CGRectMake(0, LOGINVIEW_TEXTFIELD_HEIGHT+LOGINVIEW_ITEM_GAP,
                                                                              LOGINVIEW_ICON_WIDTH, LOGINVIEW_TEXTFIELD_HEIGHT)];
    iconPassword.image = [UIImage imageNamed:@"bu_password.png"];
    [self.loginView addSubview:iconPassword];
    [iconPassword release];
    
    if (!self.textEmail)
    {
        self.textEmail = [[UITextField alloc] initWithFrame:CGRectMake(LOGINVIEW_ICON_WIDTH+LOGINVIEW_ITEM_GAP, 0,
                                                                       LOGINVIEW_WIDTH-LOGINVIEW_ICON_WIDTH-LOGINVIEW_ITEM_GAP, LOGINVIEW_TEXTFIELD_HEIGHT)];
        NSArray* arrayRGB = [self hexToRGB:LOGINVIEW_TEXTFIELD_BGCOLOR];
        self.textEmail.backgroundColor = [UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                         green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                          blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0];
        
        self.textEmail.placeholder = @"mymail@mail.com";
        UIFont* fontAvenirNext = [UIFont fontWithName:LOGINVIEW_TEXTFIELD_FONTNAME size:LOGINVIEW_TEXTFIELD_FONTSIZE];
        [self.textEmail setFont:fontAvenirNext];
        arrayRGB = [self hexToRGB:LOGINVIEW_TEXTFIELD_TEXTCOLOR];;
        [self.textEmail setTextColor:[UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                     green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                      blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0]];

        self.textEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textEmail.delegate = self;
        [self.loginView addSubview:self.textEmail];
    }
    
    if (!self.textPassword)
    {
        self.textPassword = [[UITextField alloc] initWithFrame:CGRectMake(LOGINVIEW_ICON_WIDTH+LOGINVIEW_ITEM_GAP, LOGINVIEW_TEXTFIELD_HEIGHT+LOGINVIEW_ITEM_GAP,
                                                                          LOGINVIEW_WIDTH-LOGINVIEW_ICON_WIDTH-LOGINVIEW_ITEM_GAP, LOGINVIEW_TEXTFIELD_HEIGHT)];
        NSArray* arrayRGB = [self hexToRGB:LOGINVIEW_TEXTFIELD_BGCOLOR];
        self.textPassword.backgroundColor = [UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                            green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                             blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0];
        
        self.textPassword.secureTextEntry = YES;
        self.textPassword.placeholder = @"password";
        UIFont* fontAvenirNext = [UIFont fontWithName:LOGINVIEW_TEXTFIELD_FONTNAME size:LOGINVIEW_TEXTFIELD_FONTSIZE];
        [self.textPassword setFont:fontAvenirNext];
        arrayRGB = [self hexToRGB:LOGINVIEW_TEXTFIELD_TEXTCOLOR];;
        [self.textPassword setTextColor:[UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                        green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                         blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0]];
        
        self.textPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textPassword.delegate = self;
        [self.loginView addSubview:self.textPassword];
    }
    
    UIButton* btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(LOGINVIEW_WIDTH-LOGINVIEW_BUTTON_WIDTH,
                                                                    2*(LOGINVIEW_TEXTFIELD_HEIGHT+LOGINVIEW_ITEM_GAP),
                                                                    LOGINVIEW_BUTTON_WIDTH, LOGINVIEW_BUTTON_HEIGHT)];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_up.png"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"login_down.png"] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(loginLightspeed:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:btnLogin];
    [btnLogin release];
    
    if (!self.labelAPIResult)
    {
        self.labelAPIResult = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)] autorelease];
        UIFont* fontAvenirNext = [UIFont fontWithName:LOGINVIEW_TEXTFIELD_FONTNAME
                                                 size:LOGINVIEW_TEXTFIELD_FONTSIZE];
        [self.labelAPIResult setFont:fontAvenirNext];
        NSArray* arrayRGB = [self hexToRGB:0xFFFFFF];
        [self.labelAPIResult setTextColor:[UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                          green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                           blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0
                                                          alpha:1.0]];
        
        self.labelAPIResult.numberOfLines = 2;
    }
    [self.labelAPIResult setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)prepareWelcomeView
{
    if (!self.welcomeView)
    {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        self.welcomeView = [[[UIView alloc] initWithFrame:CGRectMake(IPHONE_SCREEN_WIDTH,
                                                                    (screenHeight == IPHONE5_SCREEN_HEIGHT)? LOGINVIEW_Y_OFFSET_4IN : LOGINVIEW_Y_OFFSET,
                                                                    LOGINVIEW_WIDTH, LOGINVIEW_HEIGHT)] autorelease];
        self.welcomeView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.welcomeView];
    }
    
    UILabel* labelWelcome = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    labelWelcome.numberOfLines = 0;
    labelWelcome.text = [NSString stringWithFormat:@"Welcome to\nLightspeed Demo"];
    [labelWelcome setTextAlignment:NSTextAlignmentCenter];
    [labelWelcome setBackgroundColor:[UIColor clearColor]];
    
    UIFont* fontAvenirNext = [UIFont fontWithName:LOGINVIEW_TEXTFIELD_FONTNAME size:18.0f];
    [labelWelcome setFont:fontAvenirNext];
    NSArray* arrayRGB = [self hexToRGB:0x46AAB9];;
    [labelWelcome setTextColor:[UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                               green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0 alpha:1.0]];
    
    [labelWelcome sizeToFit];
    CGRect frame = labelWelcome.frame;
    frame.origin.x = (self.welcomeView.frame.size.width - frame.size.width)/2;
    frame.origin.y = (self.welcomeView.frame.size.height - LOGINVIEW_BUTTON_HEIGHT - LOGINVIEW_ITEM_GAP - frame.size.height)/2;
    labelWelcome.frame = frame;
    
    [self.welcomeView addSubview:labelWelcome];
    [labelWelcome release];
    
    self.btnPush = [[[UIButton alloc] initWithFrame:CGRectMake((self.welcomeView.frame.size.width - LOGINVIEW_BUTTON_WIDTH)/2,
                                                                   2*(LOGINVIEW_TEXTFIELD_HEIGHT+LOGINVIEW_ITEM_GAP),
                                                                   LOGINVIEW_BUTTON_WIDTH, LOGINVIEW_BUTTON_HEIGHT)] autorelease];
    
    [self.btnPush setBackgroundImage:[UIImage imageNamed:@"push_up.png"] forState:UIControlStateNormal];
    [self.btnPush setBackgroundImage:[UIImage imageNamed:@"push_down.png"] forState:UIControlStateHighlighted];
    [self.btnPush setBackgroundImage:[UIImage imageNamed:@"push_gray.png"] forState:UIControlStateDisabled];
    [self.btnPush addTarget:self action:@selector(sendPushNotification:) forControlEvents:UIControlEventTouchUpInside];
    self.btnPush.enabled = NO;
    [self.welcomeView addSubview:self.btnPush];
    
    self.welcomeView.alpha = 0;
}

- (void)displayResult:(BOOL)success withMessage:(NSString*)message
{
    if (!self.labelAPIResult)
    {
        self.labelAPIResult = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)] autorelease];
        UIFont* fontAvenirNext = [UIFont fontWithName:LOGINVIEW_TEXTFIELD_FONTNAME
                                                 size:LOGINVIEW_TEXTFIELD_FONTSIZE];
        [self.labelAPIResult setFont:fontAvenirNext];
        NSArray* arrayRGB = [self hexToRGB:0xFFFFFF];
        [self.labelAPIResult setTextColor:[UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                          green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                           blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0
                                                          alpha:1.0]];
        
        self.labelAPIResult.numberOfLines = 2;
    }
    
    self.labelAPIResult.text = message;
    
    CGRect textSize = [self.labelAPIResult textRectForBounds:CGRectMake(0, 0, 320, 50) limitedToNumberOfLines:2];
    self.labelAPIResult.frame = textSize;
    
    if (!success)
    {
        NSArray* arrayRGB = [self hexToRGB:0x00676F];
        [self.labelAPIResult setTextColor:[UIColor colorWithRed:[(NSNumber*)(arrayRGB[0]) floatValue]/255.0
                                                          green:[(NSNumber*)(arrayRGB[1]) floatValue]/255.0
                                                           blue:[(NSNumber*)(arrayRGB[2]) floatValue]/255.0
                                                          alpha:1.0]];
    }
    
    CGRect frame = self.labelAPIResult.frame;
    frame.origin.x = (IPHONE_SCREEN_WIDTH - self.labelAPIResult.frame.size.width) / 2;
    frame.origin.y = (self.view.frame.size.height - 50) + (50 - self.labelAPIResult.frame.size.height)/2;
    self.labelAPIResult.frame = frame;
    [self.labelAPIResult setBackgroundColor:[UIColor clearColor]];
    
    [self.actIndicator stopAnimating];
    [self.view addSubview:self.labelAPIResult];
    [self.labelAPIResult setHidden:NO];
}

- (void)keyboardShowNotification:(NSNotification*)notification
{
    NSValue* value = [[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGFloat keyboardHeight = [value CGRectValue].size.height;
    
    CGFloat fToShift = self.view.frame.size.height -
                        (self.loginView.frame.origin.y + self.loginView.frame.size.height + LOGINVIEW_ITEM_GAP);
    fToShift = keyboardHeight - fToShift;
    
    [UIView animateWithDuration:0.3f
                     animations:^
     {
         CGRect frame = self.view.frame;
         frame.origin.y -= fToShift;
         self.view.frame = frame;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginLightspeed:(id)sender
{
    NSLog(@"loginLightspeed");
    if (self.labelAPIResult && !self.labelAPIResult.isHidden)
        [self.labelAPIResult setHidden:YES];
    
    if (!self.actIndicator)
    {
        self.actIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        self.actIndicator.hidesWhenStopped = YES;
        CGRect frame = self.actIndicator.frame;
        frame.origin.x = (IPHONE_SCREEN_WIDTH - frame.size.width)/2;
        frame.origin.y = self.view.frame.size.height - 33;
        self.actIndicator.frame = frame;
        [self.view addSubview:self.actIndicator];
    }
    
    if (self.textPassword.isFirstResponder)
        [self textFieldShouldReturn:self.textPassword];
    else
        [self textFieldShouldReturn:self.textEmail];
    
    [self.actIndicator startAnimating];
    [self loginLightspeedWithEmail:self.textEmail.text andPassword:self.textPassword.text];
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
    
    [[AnPush shared] register:arrayChannels overwrite:YES];
    
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

#pragma mark - Lightspeed API functions
- (void)loginLightspeedWithEmail:(NSString*)strEmail andPassword:(NSString*)strPassword
{
    m_receivedData = [[NSMutableData data] retain];
    
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
    NSString* strData = [NSString stringWithFormat:@"payload={ios:{alert:%@,badge:1,sound:%@}}", strAlertMessage, strSound];
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
    [connection release];
    [m_receivedData release];
    
    NSLog(@"Connection error: %@", error);
    [self displayResult:NO withMessage:[error localizedDescription]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection finishes loading");
    [connection release];
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
            if ([(NSString*)[dictMeta objectForKey:@"method_name"] isEqualToString:@"login"])
            {
                BOOL success = YES;
                [self displayResult:success withMessage:@"Login Successful!!"];
                [self performSelector:@selector(changeViewAfterLoginSuccessfully) withObject:nil afterDelay:0.5f];
            }
            else if ([(NSString*)[dictMeta objectForKey:@"method_name"] isEqualToString:@"SendMessage"])
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.placeholder = nil;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f
                     animations:^
     {
         CGRect frame = self.view.frame;
         frame.origin.y = 0;
         self.view.frame = frame;
     }];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textEmail && [textField.text isEqualToString:@""])
        textField.placeholder = @"mymail@mail.com";
    else if (textField == self.textPassword && !textField.text)
        textField.placeholder = @"password";
}

#pragma mark - utility functions
- (NSArray*)hexToRGB:(NSUInteger)hexValue
{
    NSNumber* red = [NSNumber numberWithInt:(hexValue>>16)];
    NSNumber* green = [NSNumber numberWithInt:((hexValue >> 8) & 0xFF)];
    NSNumber* blue = [NSNumber numberWithInt:(hexValue & 0xFF)];
    NSArray* arrayRGB = [[NSArray alloc] initWithObjects:red, green, blue, nil];
    
    return [arrayRGB autorelease];
}

@end
