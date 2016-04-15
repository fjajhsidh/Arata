//
//  AboutViewController.m
//  Thinkape-iOS
//
//  Created by 刚刚买的电脑 on 15/11/26.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "AboutViewController.h"
#import "MacroDefinition.h"

@interface AboutViewController ()

{
    
    UIScrollView *_myScrollView;
    UIImageView *_thinkApeImage;
    
    UILabel *_thinkApeLabel;
    UILabel *_openLabel;
    
    UILabel *_versionLabel;
    UILabel *_urlLabel;
    UILabel *_weixinLabel;
    UIImageView *_erweimaImage;
    UILabel *_thinkLabel;
    
    
    NSString *_versionText;
    
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [SVProgressHUD showWithStatus:@"正在加载。。。" maskType:1];
    
    [self createUI];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self requestData];
    
}


- (void)requestData
{
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://itunes.apple.com/lookup?id=1091154692" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *array = responseObject[@"results"];
        
        NSDictionary *dict = [array lastObject];
        
        NSLog(@"当前版本为：%@", dict[@"version"]);
      
        
        _versionText = dict[@"version"];

        _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 280, SCREEN_WIDTH-20, 50)];
        _versionLabel.text = [NSString stringWithFormat:@"当前版本号：%@",_versionText];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        
        [_myScrollView addSubview:_versionLabel];
        [SVProgressHUD dismiss];
        
       
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败！" ];
        
    }];

}
- (void) createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
//    _myScrollView.bounces = NO;
    
    //
    _thinkApeImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 40, 100, 100)];
    _thinkApeImage.image = [UIImage imageNamed:@"logo_thinkape_show"];
    
    //
    _thinkApeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, SCREEN_WIDTH-20, 60)];
    _thinkApeLabel.text = @"思凯普";
    _thinkApeLabel.font = [UIFont systemFontOfSize:20];
    _thinkApeLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _openLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, SCREEN_WIDTH-20, 50)];
    _openLabel.text = @"开启专业、高效、共享、整合的新一代全面预算与费用管控平台";
    _openLabel.textAlignment = NSTextAlignmentCenter;
    _openLabel.numberOfLines = 0;
    
    
    //
    _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 280, SCREEN_WIDTH-20, 50)];
    _versionLabel.text = [NSString stringWithFormat:@"当前版本号：1.1.1"];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 325, SCREEN_WIDTH-20, 50)];
    _urlLabel.text = @"思凯普官网：www.thinkape.com.cn";
    _urlLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, SCREEN_WIDTH-20, 50)];
    _weixinLabel.text = @"思凯普微信公众号：Thinkape思凯普";
    _weixinLabel.textAlignment = NSTextAlignmentCenter;
    
    //
    _erweimaImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 480, 200, 200)];
    _erweimaImage.image = [UIImage imageNamed:@"Thinkapeimage"];
    
    //
    _thinkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 700, SCREEN_WIDTH-20, 50)];
    _thinkLabel.text = @"Thinkape 1998-2016 思凯普中国 版权所有";
    _thinkLabel.font = [UIFont systemFontOfSize:14];
    _thinkLabel.numberOfLines = 0;
    _thinkLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_myScrollView addSubview:_thinkApeImage];
    [_myScrollView addSubview:_thinkApeLabel];
    [_myScrollView addSubview:_openLabel];
    
    [_myScrollView addSubview:_versionLabel];
    
    [_myScrollView addSubview:_urlLabel];
    [_myScrollView addSubview:_weixinLabel];
    [_myScrollView addSubview:_erweimaImage];
    [_myScrollView addSubview:_thinkLabel];
    
    
    _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 810);
    
    [self.view addSubview:_myScrollView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
