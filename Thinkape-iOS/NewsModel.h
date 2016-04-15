//
//  NewsModel.h
//  Thinkape-iOS
//
//  Created by tixa on 15/6/19.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *msgid;
@property (nonatomic,strong) NSString *sourcemsgid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *senduid;
@property (nonatomic,strong) NSString *create_date;
@property (nonatomic,strong) NSString *billno;
@property (nonatomic,strong) NSString *billid;
@property (nonatomic,strong) NSString *programid;
@property (nonatomic,strong) NSString *cusername;
@property (nonatomic,strong) NSString *isannounce;
@property (nonatomic,strong) NSString *msgtype;
@property (nonatomic,strong) NSString *msgurl;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *create_uid_show;
@property (nonatomic,strong) NSString *isreaded;
@end
