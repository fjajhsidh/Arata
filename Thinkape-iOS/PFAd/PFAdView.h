//
//  PFAdView.h
//  TIXAPlatform
//
//  Created by tixa tixa on 13-4-12.
//  Copyright (c) 2013年 tixa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFAdView : UIView<UIScrollViewDelegate>

@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , strong) NSDictionary *styleDic;
@property (nonatomic , strong) UIViewController * parent;

@end
