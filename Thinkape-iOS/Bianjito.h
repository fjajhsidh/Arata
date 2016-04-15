//
//  Bianjito.h
//  Thinkape-iOS
//
//  Created by admin on 15/12/29.
//  Copyright © 2015年 TIXA. All rights reserved.
//



#import <UIKit/UIKit.h>
@interface Bianjito : UIViewController
@property (nonatomic,strong) NSMutableArray *costLayoutArray;

@property (nonatomic,strong) NSMutableArray *costDataArr;
@property(nonatomic,strong)NSMutableArray *updateimage;
@property(nonatomic,strong)NSMutableArray *imagedate;

@property (nonatomic,assign) int index;
//wo
@property(nonatomic,strong) NSString * selectType;
@property(nonatomic,strong)NSMutableDictionary * acceptAddDict;//新增明细接收的字典
@property(nonatomic,strong)NSMutableDictionary * acceptEditorDict;//编辑明细接受的字典

@property(nonatomic,assign)BOOL editstart;
@property(nonatomic,strong)NSMutableDictionary *datar;
@property(nonatomic,strong)NSMutableDictionary *editnew;
@property(nonatomic,assign)BOOL isstrart;
@property(nonatomic,strong)NSMutableDictionary *editxiao;
@property(nonatomic,assign)NSInteger indexRow;
@property(nonatomic,assign)NSInteger indexRowss;
@property(nonatomic,assign)BOOL isPage;
//点击cell的行数
@property(nonatomic,assign)int iscellindes;
@property(nonatomic,strong)NSMutableDictionary *dilct;


@property (nonatomic,copy)NSString *oldMoney;
@end
