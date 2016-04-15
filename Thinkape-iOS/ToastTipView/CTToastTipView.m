//
//  CTToastTipView.m
//  CTRIP_WIRELESS
//
//  Created by NickJackson on 13-8-27.
//  Copyright (c) 2013年 携程. All rights reserved.
//  Toastu提示框视图类

#import "CTToastTipView.h"
#include <stdlib.h>

@class CTToastMaskWindow;

@interface CTToastTipView()
{
    CTToastMaskWindow *maskWindow_;
}

@property (nonatomic, copy) NSString *tipText;
@property (nonatomic, strong) UILabel *tipLabelView;

- (void)forceHide;

@end

@interface CTToastMaskWindow : UIWindow

@property (nonatomic, strong) CTToastTipView *maskView;

@end

@implementation CTToastMaskWindow

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [(CTToastTipView *)self.maskView forceHide];
}

@end



@implementation CTToastTipView
#pragma mark - --------------------退出清空--------------------

- (void)dealloc
{
    
}
#pragma mark - --------------------初始化--------------------

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBaseView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initBaseView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_tipLabelView) {
        int edge = 10;
        [_tipLabelView setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(edge, edge, edge, edge))];
    }
}

- (void)initBaseView
{
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    
    if (!_tipLabelView) {
        int edge = 10;
        _tipLabelView = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(edge, edge, edge, edge))];
        [_tipLabelView setBackgroundColor:[UIColor clearColor]];
        [_tipLabelView setTextAlignment:NSTextAlignmentCenter];
        [_tipLabelView setTextColor:[UIColor whiteColor]];
        [_tipLabelView setFont:kCTToastTipViewTextFont];
        _tipLabelView.numberOfLines = INT_MAX;
    }
    
    [self addSubview:_tipLabelView];
    
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:5];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (newWindow) {
        if (_tipLabelView) {
            [_tipLabelView setText:self.tipText];
        }
    }
}
#pragma mark - --------------------功能函数--------------------

- (void)showInView:(UIView *)view
{
    if (!maskWindow_) {
        maskWindow_ = [[CTToastMaskWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskWindow_.windowLevel = UIWindowLevelStatusBar + 1;
        [maskWindow_ setBackgroundColor:[UIColor clearColor]];
    }
    maskWindow_.maskView = self;
    [maskWindow_ makeKeyAndVisible];
    view = maskWindow_;
    
    [self setCenter:CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)];
    self.layer.opacity = 0.0;
    [view addSubview:self];
    
    [self fadeInAnimationAfterDelay:kCTToastTipViewDisplayDuration];
}

- (void)fadeInAnimationAfterDelay:(NSTimeInterval)delay
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(fadeOutAnimation) withObject:nil afterDelay:kCTToastTipViewDisplayDuration];
    }];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setDuration:kCTToastTipViewFadeinDuration];
    [fadeInAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    [fadeInAnimation setRemovedOnCompletion:NO];
    [fadeInAnimation setFillMode:kCAFillModeForwards];
    [fadeInAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeInAnimation forKey:@"fadeIn"];
    
    [CATransaction commit];
}

- (void)fadeOutAnimation
{
    maskWindow_.maskView = nil;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self forceHide];
    }];
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setDuration:kCTToastTipViewFadeoutDuration];
    [fadeOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    [fadeOutAnimation setRemovedOnCompletion:NO];
    [fadeOutAnimation setFillMode:kCAFillModeForwards];
    [fadeOutAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    
    [CATransaction commit];
}

#pragma mark - --------------------接口API--------------------
#pragma mark 强制消失
- (void)forceHide
{
    maskWindow_.maskView = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutAnimation) object:nil];
    
    [self removeFromSuperview];
    [maskWindow_ resignKeyWindow];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
}
#pragma mark Toast样式提示自定义内容
+ (void)showTipText:(NSString *)text inView:(UIView *)view
{
    CTToastTipView *toastTipView = [[CTToastTipView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    CGSize textSize = [text sizeWithFont:kCTToastTipViewTextFont constrainedToSize:CGSizeMake(250-30, 320) lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (textSize.height > 20) {
        int viewHeight = 15 + textSize.height + 15;
        CGRect toastFrame = toastTipView.frame;
        toastFrame.size.height = viewHeight;
        toastTipView.frame = toastFrame;
    }
    
    toastTipView.tipText = text;
    [toastTipView showInView:view];
    
}
#pragma mark Toast样式在Window上提示自定义内容
+ (void)showTipText:(NSString *)text
{
    [CTToastTipView showTipText:text inView:[[[UIApplication sharedApplication] delegate] window]];
}

+ (void)showTipTextInRandomLocation:(NSString *)text
{
    CTToastTipView *toastTipView = [[CTToastTipView alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    CGSize textSize = [text sizeWithFont:kCTToastTipViewTextFont constrainedToSize:CGSizeMake(250-30, 320) lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (textSize.height > 20) {
        int viewHeight = 15 + textSize.height + 15;
        CGRect toastFrame = toastTipView.frame;
        toastFrame.size.height = viewHeight;
        toastTipView.frame = toastFrame;
    }
    
    toastTipView.tipText = text;

    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    static NSUInteger lastIndex = 0;
    lastIndex = (++lastIndex) % 8;
    [toastTipView setCenter:CGPointMake(window.bounds.size.width/2.0, 100+lastIndex*50)];
    toastTipView.layer.opacity = 0.0;
    [window addSubview:toastTipView];
    
    [toastTipView fadeInAnimationAfterDelay:4];
}

#pragma mark Toast样式在Window上提示自定义文本“此卡即将过期，请填写新的卡信息”
+ (void)showWillExpireTip
{
    [CTToastTipView showTipText:@"此卡即将过期，请填写新的卡信息"];
}
#pragma mark Toast样式在Window上提示自定义文本“此卡已过期，请填写新的卡信息”
+ (void)showDidExpireTip
{
    [CTToastTipView showTipText:@"此卡已过期，请填写新的"];
}

@end
