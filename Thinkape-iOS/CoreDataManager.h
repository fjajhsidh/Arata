//
//  CoreDataManager.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <objc/runtime.h>

@interface CoreDataManager : NSObject
// 存储数据.
- (void)saveDataForTable:(NSString *)objectName model:(NSDictionary *)dic sql:(NSString *)key;
// 更新特定的数据
- (void)updateModelForTable:(NSString *)tableName sql:(NSString *)key data:(NSDictionary *)dic;
// 根据dataSource查找当前的版本.
- (NSString *)searchDataVer:(NSString *)dataSource;
// 获取数据
- (NSArray *)fetchDataForTable:(NSString *)tableName sql:(NSString *)sql;
// 删除数据
- (BOOL)deleateDataForTabel:(NSString *)tableName sql:(NSString *)sql;

+ (CoreDataManager *)shareManager;

@end
