//
//  LinkViewCell.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/24.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;

@property (nonatomic,strong) void (^callNum)(NSString *phoneNum);

@end
