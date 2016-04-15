//
//  ParentsViewController.h
//  MaiDuoEr
//
//  Created by tixa on 15/4/10.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "BFKit.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "SVProgressHUD.h"
#import "RequestCenter.h"
#import "UIButton+WebCache.h"
#import "DataManager.h"
#import "MacroDefinition.h"
#import "UIImageView+WebCache.h"
#import "CoreDataManager.h"

@interface ParentsViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign,getter=isGestureEnabel) BOOL gestureEnabel; // 是否支持右滑手势
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *ukey;

- (void)showAlertView:(NSString *)message;

- (void)callPhoneNum:(NSString *)num;
- (CGFloat )fixStr:(NSString *)str size:(CGSize)size fontSize:(CGFloat)font;
@end
