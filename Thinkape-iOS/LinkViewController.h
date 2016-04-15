//
//  LinkViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/24.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//
#import "LianxiModel.h"
#import "ParentsViewController.h"

@interface LinkViewController : ParentsViewController <UITextFieldDelegate>

@property (nonatomic,assign) NSInteger linkStyle; // 0:默认 1：转批 2：加签
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) void (^selectPerson)(NSArray *selectArr ,NSInteger type);

- (IBAction)backVC:(id)sender;

@end
