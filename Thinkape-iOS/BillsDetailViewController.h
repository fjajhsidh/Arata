//
//  BillsDetailViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/5.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "UnApprovalModel.h"
#import "BillsModel.h"

@interface BillsDetailViewController : ParentsViewController

@property (nonatomic,copy) NSString *billid;
@property (nonatomic,copy) NSString *programeId;
@property (nonatomic,copy) NSString *flowid;
@property (nonatomic,strong) BillsModel *bills;

@property (nonatomic,assign) NSUInteger billType; // 0:普通单据 1:审批单据 default :0
@property (nonatomic,strong) UnApprovalModel *unModel;
@property (nonatomic,copy) void (^reloadData)();
@property(nonatomic,assign)int selectedion2;
@end
