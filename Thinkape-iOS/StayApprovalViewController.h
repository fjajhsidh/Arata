//
//  StayApprovalViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"

@interface StayApprovalViewController : ParentsViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
