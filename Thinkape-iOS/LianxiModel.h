//
//  LianxiModel.h
//  Thinkape-iOS
//
//  Created by tixa on 15/5/26.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LianxiModel : NSObject

@property (nonatomic,strong) NSString *iuserid;
@property (nonatomic,strong) NSString *cusercode;
@property (nonatomic,strong) NSString *cusername;
@property (nonatomic,strong) NSString *cemail;
@property (nonatomic,strong) NSString *cphone;
@property (nonatomic,strong) NSString *cdepcode;
@property (nonatomic,strong) NSString *cdepname;
@property (nonatomic,strong) NSString *picpath;

@property (nonatomic,assign) BOOL selected;
@end
