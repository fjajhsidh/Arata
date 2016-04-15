//
//  MixiViewController.h
//  Thinkape-iOS
//
//  Created by admin on 16/1/5.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentsViewController.h"
@interface MixiViewController :ParentsViewController
@property(nonatomic,assign)long index;
@property(nonatomic,strong)NSMutableArray *costatrraylost;
@property(nonatomic,strong)NSMutableArray *costarrdate;


@property(nonatomic,strong)NSMutableDictionary *dict2;
//wo
@property(nonatomic,strong)NSString * selectAcceptType;
@property(nonatomic,assign)BOOL hudong;
@property(nonatomic,assign)int indexsele;
@property (nonatomic , strong) UIView * calculatorView;

//删除的字典
@property(nonatomic,strong)NSMutableDictionary *dictarry;

//没改之前的总金额：
@property (nonatomic,copy)NSString *oldMoney;
@property (nonatomic,copy)NSString *preMoney;
//接受上一个界面传进来的哪个按钮的index
@property (nonatomic,assign)NSInteger btnIndex;




@end
