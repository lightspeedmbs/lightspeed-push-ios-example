//
//  LSPushSendVideoPushView.m
//  LSPush
//
//  Created by Bobie on 1/13/14.
//  Copyright (c) 2014 Herxun. All rights reserved.
//

#import "LSPushSendVideoPushView.h"
#import "UICommonUtility.h"

@interface LSPushSendVideoPushView () <UITextFieldDelegate>

/* UI elements */
@property (strong) UITextField* textInputField;
@property (strong) UIButton* btnPush;

/* controls */
@property (strong) NSString* strTextfieldResult;

@end

@implementation LSPushSendVideoPushView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignKeyboard) name:@"co.herxun.LSPush.dismissKeyboard" object:nil];
        
        [self prepareSendVideoPushView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareSendVideoPushView
{
    CGSize screenSize = [UICommonUtility getScreenSize];
    CGFloat fTextviewLeftMargin = 13.0f;
    CGFloat fTextviewWidth = screenSize.width - 2*fTextviewLeftMargin, fTextviewHeight = 44.0f;
    CGFloat fBtnPushWidth = screenSize.width - 2*fTextviewLeftMargin, fBtnPushHeight = 44.0f;
    CGFloat fBtnPushTop = fTextviewHeight + 10.0f;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    if (!self.textInputField)
    {
        UIView* textinputBaseview = [[UIView alloc] initWithFrame:CGRectMake(fTextviewLeftMargin, 0.0f, fTextviewWidth, fTextviewHeight)];
        [self addSubview:textinputBaseview];
        [textinputBaseview.layer setBorderWidth:1.0f];
        [textinputBaseview.layer setBorderColor:[UICommonUtility hexToColor:0xEC4F54 withAlpha:[NSNumber numberWithFloat:1.0f]].CGColor];
        
        CGFloat fTextFieldLeftInset = 10.0f;
        self.textInputField = [[UITextField alloc] initWithFrame:CGRectMake(fTextFieldLeftInset, 0.0f, 274.0f, fTextviewHeight)];
        [textinputBaseview addSubview:self.textInputField];
        self.textInputField.delegate = self;
        self.textInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.textInputField setBackgroundColor:[UIColor clearColor]];
        [self.textInputField setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0f]];
        [self.textInputField setTextColor:[UICommonUtility hexToColor:0x444444 withAlpha:[NSNumber numberWithFloat:1.0f]]];
        [self.textInputField setUserInteractionEnabled:YES];
        self.textInputField.placeholder = @"http://example.com/demo.mp4";
    }
    
    if (!self.btnPush)
    {
        self.btnPush = [[UIButton alloc] initWithFrame:CGRectMake(fTextviewLeftMargin, fBtnPushTop, fBtnPushWidth, fBtnPushHeight)];
        [self addSubview:self.btnPush];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu05_up.png"] forState:UIControlStateNormal];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu05_down.png"] forState:UIControlStateHighlighted];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu05_disable.png"] forState:UIControlStateDisabled];
        [self.btnPush addTarget:self action:@selector(btnPushClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.btnPush setEnabled:NO];
    }
}

- (void)resignKeyboard
{
    [self.textInputField resignFirstResponder];
}

- (void)checkIfShouldEnablePushBtn
{
#warning - remember to check if SDK is ready to send push
    BOOL bAnPushReady = YES;
    BOOL bBtnPushEnabled = (self.textInputField.text && ![self.textInputField.text isEqualToString:@""]) && bAnPushReady;
    [self.btnPush setEnabled:bBtnPushEnabled];
}

#pragma mark - button functions
- (void)btnPushClicked
{
    NSLog(@"sending text push");
    [self resignKeyboard];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
#warning - check with Ting for color code
    [self.textInputField setTextColor:[UICommonUtility hexToColor:0x605F5B withAlpha:[NSNumber numberWithFloat:1.0f]]];
    [self.textInputField setText:self.strTextfieldResult];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /* update subtitle */
    [self _updateInputFieldText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self _updateInputFieldText];
    [self.textInputField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self checkIfShouldEnablePushBtn];
    });
    
    return YES;
}

- (void)_updateInputFieldText
{
    if (self.textInputField.text && ![self.textInputField.text isEqualToString:@""])
    {
        self.strTextfieldResult = self.textInputField.text;
    }
    else
    {
        self.strTextfieldResult = @"";
    }
    
#warning - check with Ting for color code
    [self.textInputField setTextColor:[UICommonUtility hexToColor:0x999890 withAlpha:[NSNumber numberWithFloat:1.0f]]];
}

@end
