//
//  SendMsgViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/9/11.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"
#import "UnApprovalModel.h"
#import "NewsModel.h"

typedef enum : NSUInteger {
    SendMessageTableType,
    SendMessageWebType,
} SendMessageType;

@interface SendMsgViewController : ParentsViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UnApprovalModel *model;
@property (nonatomic,assign) SendMessageType msgType;
@property (nonatomic,strong) NewsModel *newsModel;
@end
