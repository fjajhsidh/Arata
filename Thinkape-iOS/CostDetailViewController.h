//
//  CostDetailViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/6.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"

@interface CostDetailViewController : ParentsViewController

@property (nonatomic,strong) NSArray *costLayoutArray;
@property (nonatomic,strong) NSMutableArray *costDataArr;

@property (nonatomic,assign) int index;
@property (nonatomic,strong) NSArray *costLayoutArray2;
@property (nonatomic,strong) NSArray *costDataArr2;

@property (nonatomic,assign) int index2;
@property(nonatomic,assign)int selecter;//0是单据界面；1是编辑界面

@end

