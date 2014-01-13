//
//  LSPushGenericNaviController.m
//  LSPush
//
//  Created by Bobie on 1/13/14.
//  Copyright (c) 2014 Herxun. All rights reserved.
//

#import "LSPushGenericNaviController.h"
#import "UICommonUtility.h"

@interface LSPushGenericNaviController ()

@end

@implementation LSPushGenericNaviController

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
    
    if ([self.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        [self.navigationBar setTranslucent:NO];
        [self.navigationBar setBarTintColor:[UICommonUtility hexToColor:0x323232 withAlpha:[NSNumber numberWithFloat:1.0f]]];
    }
    else
    {
        [[[[UIApplication sharedApplication] delegate] window] setBackgroundColor:[UICommonUtility hexToColor:0x323232 withAlpha:[NSNumber numberWithFloat:1.0f]]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    }
    
    /* remove navigation bar shadow */
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    /* remove iOS7 navigation bar border */
    UIView* bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.frame.size.width, 1.0f)];
    [self.navigationBar addSubview:bottomBorderView];
    [bottomBorderView setBackgroundColor:[UICommonUtility hexToColor:0x323232 withAlpha:[NSNumber numberWithFloat:1.0f]]];
    
    /* remove navigation bar title shadow */
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,
                                                                                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                                                                                    nil, UITextAttributeTextShadowOffset,
                                                                                                    [UIFont fontWithName:@"STHeitiTC-Medium" size:17.0f], UITextAttributeFont, nil]];
    
    /* status bar */
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6 or under
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
