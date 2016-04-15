//
//  LinkViewCell.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/24.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "LinkViewCell.h"

@implementation LinkViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)callPhoneNum:(id)sender {
    
    if (self.callNum) {
        self.callNum(self.phoneNum.text);
    }
    
}

@end
