//
//  BillsModel.m
//  Thinkape-iOS
//
//  Created by tixa on 15/5/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "BillsModel.h"

@implementation BillsModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"approveDate" : @"_approve_date",
             @"ID":@"_id",
             };
}
@end
