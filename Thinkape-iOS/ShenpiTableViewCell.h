//
//  ShenpiTableViewCell.h
//  Thinkape-iOS
//
//  Created by admin on 16/4/9.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShenpiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

@end
