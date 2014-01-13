//
//  LSTalkLoadingIndicatorView.m
//  LSIM
//
//  Created by BobieAir on 2013/11/22.
//  Copyright (c) 2013年 Herxun. All rights reserved.
//

#import "LSTalkLoadingIndicatorView.h"
#import "UICommonUtility.h"

@interface LSTalkLoadingIndicatorView ()

@property (nonatomic, strong) UIActivityIndicatorView* loadingIndicator;
@property (nonatomic, strong) UIImageView* doneCheckView;

@end

@implementation LSTalkLoadingIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self prepareLoadingIndicatorView];
    }
    return self;
}

- (void)prepareLoadingIndicatorView
{
    CGFloat fIndicatorViewSize = 80.0f;
    UIImageView* imageIndicatorViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, fIndicatorViewSize, fIndicatorViewSize)];
    [self addSubview:imageIndicatorViewBg];
    imageIndicatorViewBg.image = [UIImage imageNamed:@"loading_indicator_bg.png"];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:self.loadingIndicator];
    CGRect frame = self.loadingIndicator.frame;
    frame.origin.x = (fIndicatorViewSize - frame.size.width)/2;
    frame.origin.y = (fIndicatorViewSize - frame.size.height)/2;
    self.loadingIndicator.frame = frame;
    [self.loadingIndicator setHidesWhenStopped:YES];
    [self.loadingIndicator startAnimating];
    
    self.doneCheckView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, fIndicatorViewSize, fIndicatorViewSize)];
    [self addSubview:self.doneCheckView];
    self.doneCheckView.image = [UIImage imageNamed:@"loading_indicator_done.png"];
    [self.doneCheckView setHidden:YES];
}

- (void)startLoading
{
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimating];
    [self.doneCheckView setHidden:YES];
}

- (void)stopLoading
{
    [self.loadingIndicator stopAnimating];
    [self.doneCheckView setHidden:NO];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.alpha = 1.0f;
            [self removeFromSuperview];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(LSTalkLoadingIndicatorDidDisappear)])
            {
                [self.delegate LSTalkLoadingIndicatorDidDisappear];
            }
        }];
    });
}

@end
