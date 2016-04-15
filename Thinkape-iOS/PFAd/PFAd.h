//
//  PFAd.h
//  TIXAPlatform
//
//  Created by tixa tixa on 13-5-16.
//  Copyright (c) 2013年 tixa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFAd : NSObject

@property (nonatomic, assign) NSInteger adIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger coding;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *addressName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger enterId;
@property (nonatomic, strong) NSString *webAddress;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger positionId;
@property (nonatomic, strong) NSString *ordered;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, assign) NSInteger clickCount;
@property (nonatomic, assign) NSInteger status;

@end
