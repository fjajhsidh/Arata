//
//  KindsPickerView.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/17.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KindsModel;
@interface KindsPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) void(^selectItemCallBack)(KindsModel *model);

@end
