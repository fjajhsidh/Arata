//
//  StayApprovalDetailViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/11.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "UnApprovalModel.h"


@interface StayApprovalDetailViewController : ParentsViewController

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *billid;
@property (nonatomic,strong) NSString *programeId;
@property (nonatomic,strong) NSString *flowid;

@property (nonatomic,strong) UnApprovalModel *unModel;
@property (nonatomic,strong) void (^reloadData)();
@end


