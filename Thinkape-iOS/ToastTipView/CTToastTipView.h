//
//  CTToastTipView.h
//  CTRIP_WIRELESS
//
//  Created by NickJackson on 13-8-27.
//  Copyright (c) 2013年 携程. All rights reserved.
//  Toastu提示框视图类

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

//渐入动画时间
#define kCTToastTipViewFadeinDuration 0.2
//停留显示时间
#define kCTToastTipViewDisplayDuration 2.5
//渐出动画时间
#define kCTToastTipViewFadeoutDuration 0.3
//提示文本字体
#define kCTToastTipViewTextFont [UIFont systemFontOfSize:15]

/**
	Toastu提示框视图类
 */
@interface CTToastTipView : UIView

/**
	Toast样式提示自定义内容
 
	@param text 自定义文本
	@param view 要显示的父视图
 */
+ (void)showTipText:(NSString *)text inView:(UIView *)view;
/**
	Toast样式在Window上提示自定义内容
 
	@param text 自定义文本
 */
+ (void)showTipText:(NSString *)text;

/**
 Toast样式在Window上提示自定义内容，位置随机
 
 @param text 自定义文本
 */
+ (void)showTipTextInRandomLocation:(NSString *)text;

/**
	Toast样式在Window上提示自定义文本“此卡即将过期，请填写新的卡信息”
 */
+ (void)showWillExpireTip;

/**
	Toast样式在Window上提示自定义文本“此卡已过期，请填写新的卡信息”
 */
+ (void)showDidExpireTip;

@end
