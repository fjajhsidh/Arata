//
//  StatementViewController.m
//  Thinkape-iOS
//
//  Created by 刚刚买的电脑 on 15/11/18.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "StatementViewController.h"

@interface StatementViewController ()

@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.opaque = NO;
    NSString *url = @"http://27.115.23.126:5032/Mobile/report/report_lead.html";
    //http://27.115.23.126:5032/Mobile/report/report_lead.html
//    NSString *url = [NSString stringWithFormat:@"%@/Mobile/report/report_lead.html",[DataManager shareManager].webDomain];
    NSLog(@"url : %@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    // Do any additional setup after loading the view.
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
