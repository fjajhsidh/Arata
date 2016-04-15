//
//  HistoryViewCell.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/5.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *advice;
@property (weak, nonatomic) IBOutlet UILabel *stepName;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
