
//
//  StayApprovalModel.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "StayApprovalModel.h"

@implementation StayApprovalModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"approveDate" : @"_approve_date",
             @"ID":@"_id",
             };
}

@end
