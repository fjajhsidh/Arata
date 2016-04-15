//
//  Bianjiviewtableview.h
//  Thinkape-iOS
//
//  Created by admin on 16/1/1.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"

@interface Bianjiviewtableview : ParentsViewController
@property(nonatomic,strong)NSMutableArray *costArray;
@property(nonatomic,strong)NSMutableArray *costArr;
@property(nonatomic,assign)long indexto;
@property(nonatomic,strong)NSMutableArray *updateimage;
@property(nonatomic,strong)NSMutableArray *imagedate;
@property(nonatomic,assign)BOOL hudong;
@property (nonatomic , strong) UIView * calculatorView;

@property(nonatomic,assign)int indexsele;
//删除的单据
@property(nonatomic,strong)NSMutableDictionary *dictarry;




@property (nonatomic,assign)int btnIndex;
@end
