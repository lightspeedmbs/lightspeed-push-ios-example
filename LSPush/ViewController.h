//
//  ViewController.h
//  LSPush
//
//  Created by Bobie on 4/17/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong) UIButton* btnPush;

- (void)displayResult:(BOOL)success withMessage:(NSString*)message;

@end
