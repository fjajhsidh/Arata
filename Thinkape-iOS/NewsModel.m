//
//  NewsModel.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/19.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
   
}


@end
