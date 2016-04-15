//
//  ChangePasswordViewController.m
//  Thinkape-iOS
//
//  Created by 刚刚买的电脑 on 15/11/26.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)changePassword:(id)sender {
    
    if (_oldPassword.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if (_password.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if (![_password.text isEqualToString:_surePassword.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    /*UserCode			用户编码
     OldPwd			旧密码
     NewPwd			新密码*/
    
    [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"%@/ashx/mobile.ashx?ac=ModifyPwd&UserCode=%@&OldPwd=%@&NewPwd=%@",[DataManager shareManager].webDomain,[[DataManager shareManager] account].UserCode,_oldPassword.text,_password.text]
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             
                                            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"msg"]];
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:@"网络错误"];
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
