//
//  NewsDetailViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/7/8.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()
{
    UIWebView *web;
}
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
//    [self requestDetailVC];
    // Do any additional setup after loading the view.
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}


- (void)requestDetailVC{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"url :%@",[NSString stringWithFormat:@"%@?ac=GetInfoBody&u=%@&MsgID=%@",Web_Domain,self.uid,_model.msgid]);
   [manager GET:[NSString stringWithFormat:@"%@?ac=GetInfoBody&u=%@&MsgID=%@",Web_Domain,self.uid,_model.msgid]
     parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"class :%@",[responseObject class]);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@" %@",error.localizedDescription);
        }];
    
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
