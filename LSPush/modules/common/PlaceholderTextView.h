//
//  PlaceholderTextView.h
//  happytime
//
//  Created by Bobie on 5/16/13.
//  Copyright (c) 2013 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end