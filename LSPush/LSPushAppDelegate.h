//
//  LSPushAppDelegate.h
//  LSPush
//
//  Created by Bobie@herxun.co on 4/17/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnPush.h"

@interface LSPushAppDelegate : UIResponder <UIApplicationDelegate, AnPushDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
