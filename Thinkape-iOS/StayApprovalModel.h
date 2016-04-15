//
//  StayApprovalModel.h
//  Thinkape-iOS
//
//  Created by tixa on 15/4/27.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StayApprovalModel : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *billid;
@property (nonatomic,strong) NSString *billno;
@property (nonatomic,strong) NSString *pagename;
@property (nonatomic,strong) NSString *programid;
@property (nonatomic,strong) NSString *flowstatus;
@property (nonatomic,strong) NSString *billmoney;
@property (nonatomic,strong) NSString *submituser;
@property (nonatomic,strong) NSString *deptid;
@property (nonatomic,strong) NSString *currencyid;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *billscount;
@property (nonatomic,strong) NSString *paymentstatus;
@property (nonatomic,strong) NSString *create_uid;
@property (nonatomic,strong) NSString *create_date;
@property (nonatomic,strong) NSString *approve_uid;
@property (nonatomic,strong) NSString *approve_date;
@property (nonatomic,strong) NSString *update_uid;
@property (nonatomic,strong) NSString *memo;
@property (nonatomic,strong) NSString *cdefine1;
@property (nonatomic,strong) NSString *cdefine2;
@property (nonatomic,strong) NSString *cdefine3;
@property (nonatomic,strong) NSString *stepid;
@property (nonatomic,strong) NSString *stepname;
@property (nonatomic,strong) NSString *option;
@property (nonatomic,strong) NSString *result;
@property (nonatomic,strong) NSString *opdate;
@property (nonatomic,strong) NSString *approveDate;

@property (nonatomic,assign) BOOL status;

@end
