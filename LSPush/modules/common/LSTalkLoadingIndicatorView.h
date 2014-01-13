//
//  LSTalkLoadingIndicatorView.h
//  LSIM
//
//  Created by BobieAir on 2013/11/22.
//  Copyright (c) 2013年 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSTalkLoadingIndicatorDelegate <NSObject>

@optional
- (void)LSTalkLoadingIndicatorDidDisappear;

@end

@interface LSTalkLoadingIndicatorView : UIView

@property (nonatomic, strong) id<LSTalkLoadingIndicatorDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;

@end
