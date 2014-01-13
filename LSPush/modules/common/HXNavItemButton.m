//
//  HXNavItemButton.m
//  LSIM
//
//  Created by Bobie on 11/19/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import "HXNavItemButton.h"

@implementation HXNavItemButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self bindButtonTouchEvents];
    }
    return self;
}

- (void)bindButtonTouchEvents
{
    [self addTarget:self action:@selector(tabBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(tabBtnPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(tabBtnReleased:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(tabBtnReleased:) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(tabBtnReleased:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)tabBtnPressed:(id)sender
{
    self.alpha = 0.5f;
}

- (IBAction)tabBtnReleased:(id)sender
{
    /* nothing to do here */
    self.alpha = 1.0f;
}

- (void)setButtonEnabled:(BOOL)enabled
{
    self.enabled = enabled;
    
    self.alpha = enabled? 1.0f : 0.5f;
}

@end
