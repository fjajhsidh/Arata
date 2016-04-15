//
//  BillsListViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/25.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"

@interface BillsListViewController : ParentsViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,strong) NSString * titleStr;
@property (nonatomic,strong) NSNumber *undo; // 1：已完成 0：未完成

@end
