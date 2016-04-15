//
//  BorrowView.h
//  Thinkape-iOS
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"
/**
 *  点击借款冲销之后弹出这个选框：
 */
@class BorrowView;

@protocol BorrowViewDelegate <NSObject>

- (void)selectBorrowArray:(NSArray *)array view:(BorrowView *)view;
//- (void)selectBorrowItem:(NSString *)name ID:(NSString *)ID view:(BorrowView *)view;

@end


@interface BorrowView : UIView < UITableViewDelegate,UITableViewDataSource >

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *dataArray;
@property (nonatomic,strong)BorrowModel *model;
@property (nonatomic,strong) void (^selectBorrowItem)(NSString *name ,NSString *ID);
@property (nonatomic ,weak) id <BorrowViewDelegate> delegate;
- (void)close;

@end
