//
//  ShenPI.h
//  Thinkape-iOS
//
//  Created by admin on 16/4/8.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "UnApprovalModel.h"
#import "BillsModel.h"
#import "XYPieChart.h"
#import "SimpleBarChart.h"
@interface ShenPI :  ParentsViewController
@property (nonatomic,copy) NSString *billid;
@property (nonatomic,copy) NSString *programeId;
@property (nonatomic,copy) NSString *flowid;
@property (nonatomic,strong) BillsModel *bills;

@property (nonatomic,assign) NSUInteger billType; // 0:普通单据 1:审批单据 default :0
@property (nonatomic,strong) UnApprovalModel *unModel;
@property (nonatomic,copy) void (^reloadData)();
@property(nonatomic,assign)int selectedion2;
//5s适配
//审批
@property (weak, nonatomic) IBOutlet UIButton *miseru;
@property (weak, nonatomic) IBOutlet UIButton *chisan;
@property (weak, nonatomic) IBOutlet UIButton *shisa;
@property (weak, nonatomic) IBOutlet UIButton *tokei;
//重新定义约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miserulay;
//line长度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *misetulead;


@end
