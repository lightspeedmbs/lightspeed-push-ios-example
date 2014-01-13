//
//  LSPushSendTextPushView.m
//  LSPush
//
//  Created by Bobie on 1/13/14.
//  Copyright (c) 2014 Herxun. All rights reserved.
//

#import "LSPushSendTextPushView.h"
#import "PlaceholderTextView.h"
#import "UICommonUtility.h"

@interface LSPushSendTextPushView () <UITextViewDelegate>

/* UI elements */
@property (strong) UIScrollView* baseScroll;
@property (strong) PlaceholderTextView* textInputField;
@property (strong) UIButton* btnPush;

@end

@implementation LSPushSendTextPushView {
    float m_fKeyboardHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotificationHandler:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotificationHandler:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotificationHandler:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignKeyboard) name:@"co.herxun.LSPush.dismissKeyboard" object:nil];
        
        [self prepareSendTextPushView];
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

- (void)prepareSendTextPushView
{
    CGSize screenSize = [UICommonUtility getScreenSize];
    CGFloat fTextviewLeftMargin = 13.0f;
    CGFloat fTextviewWidth = screenSize.width - 2*fTextviewLeftMargin;
    CGFloat fTextviewHeight = (screenSize.height > 480.0f)? 150.0f : 80.0f;
    CGFloat fBtnPushWidth = screenSize.width - 2*fTextviewLeftMargin, fBtnPushHeight = 44.0f;
    CGFloat fBtnPushTop = fTextviewHeight + 10.0f;
    
    if (!self.baseScroll)
    {
        self.baseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.baseScroll];
        [self.baseScroll setContentSize:CGSizeMake(screenSize.width, fTextviewHeight + 2*10.0f + fBtnPushHeight)];
        [self.baseScroll setDelaysContentTouches:NO];
    }
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    if (!self.textInputField)
    {
        self.textInputField = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(fTextviewLeftMargin, 0.0f, fTextviewWidth, fTextviewHeight)];
        [self.baseScroll addSubview:self.textInputField];
        self.textInputField.delegate = self;
        [self.textInputField setBackgroundColor:[UIColor clearColor]];
        [self.textInputField setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0f]];
        [self.textInputField setTextColor:[UICommonUtility hexToColor:0x444444 withAlpha:[NSNumber numberWithFloat:1.0f]]];
        [self.textInputField setScrollEnabled:YES];
        [self.textInputField setUserInteractionEnabled:YES];
        self.textInputField.placeholder = @"message";
        self.textInputField.placeholderColor = [UICommonUtility hexToColor:0x999890 withAlpha:[NSNumber numberWithFloat:1.0f]];
        
        [self.textInputField.layer setBorderWidth:1.0f];
        [self.textInputField.layer setBorderColor:[UICommonUtility hexToColor:0x28ABB9 withAlpha:[NSNumber numberWithFloat:1.0f]].CGColor];
    }
    
    if (!self.btnPush)
    {
        self.btnPush = [[UIButton alloc] initWithFrame:CGRectMake(fTextviewLeftMargin, fBtnPushTop, fBtnPushWidth, fBtnPushHeight)];
        [self.baseScroll addSubview:self.btnPush];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu01_up.png"] forState:UIControlStateNormal];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu01_down.png"] forState:UIControlStateHighlighted];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu01_disable.png"] forState:UIControlStateDisabled];
        [self.btnPush addTarget:self action:@selector(btnPushClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.btnPush setEnabled:NO];
    }
}

- (void)resignKeyboard
{
    [self.textInputField resignFirstResponder];
}

#pragma mark - button functions
- (void)btnPushClicked
{
    NSLog(@"sending text push");
    [self resignKeyboard];
}

#pragma mark - UITextViewDelegate & keyboard-show notification hanlder
- (void)keyboardShowNotificationHandler:(NSNotification*)notification
{
    NSDictionary* dictKeyboardInfo = [notification userInfo];
    CGRect keyboardFrame = [[dictKeyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    m_fKeyboardHeight = keyboardFrame.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.baseScroll.frame;
        frame.size.height = [UICommonUtility getScreenSize].height - 64.0f - (26.0f + 45.0f) - m_fKeyboardHeight;
        self.baseScroll.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardHideNotificationHandler:(NSNotification*)notification
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.baseScroll.frame;
        frame.size.height = [UICommonUtility getScreenSize].height - 64.0f - (26.0f + 45.0f);
        self.baseScroll.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSRange range = NSMakeRange([self.textInputField.text length], 1);
    [self.textInputField scrollRangeToVisible:range];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSRange range = NSMakeRange(0, 1);
    [self.textInputField scrollRangeToVisible:range];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSRange range = NSMakeRange([self.textInputField.text length], 1);
    [self.textInputField scrollRangeToVisible:range];

#warning - remember to check if SDK is ready to send push
    BOOL bAnPushReady = YES;
    [self.btnPush setEnabled:([self.textInputField.text length] > 0 && bAnPushReady)];
}

@end
