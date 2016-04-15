//
//  NewsDetailViewController.h
//  Thinkape-iOS
//
//  Created by tixa on 15/7/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"

#import "NewsModel.h"

@interface NewsDetailViewController : ParentsViewController <UIWebViewDelegate>

@property (nonatomic,strong) NewsModel *model;

@end
