//
//  SendMsgViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/9/11.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "SendMsgViewController.h"
#import "IQKeyboardManager.h"
#import "NewsListViewController.h"
#import "ShenPI.h"
@interface SendMsgViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _wasKeyboardManagerEnabled;
}
@property (weak, nonatomic) IBOutlet UITextView *msgText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottonDistance;

@end

@implementation SendMsgViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.msgType == SendMessageWebType) {
        [self.tableView removeFromSuperview];
        self.title = @"详情";
        _web.delegate = self;
        //    web.scalesPageToFit = YES;
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.newsModel.msgurl]]];
    }
    else if (self.msgType == SendMessageTableType){
        [self.web removeFromSuperview];
        self.title = self.model.submituser;
        self.msgText.layer.borderColor = [UIColor hex:@"17b6e4"].CGColor;
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
    self.msgText.delegate =self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)pulltoreturn
{
    
    
    
    [self.msgText resignFirstResponder];
    
    NSArray *temArray =self.navigationController.viewControllers;
    for (UIViewController *ter in temArray) {
        if ([ter isKindOfClass:[NewsListViewController class]]) {
            [self.navigationController popToViewController:ter animated:YES];
        }
    }
    
}
- (void)keyBoardShow:(NSNotification *)noti{
    NSDictionary *userinfo = noti.userInfo;
    NSValue *aValue = [userinfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [aValue CGRectValue];
    self.bottomDistance.constant = rect.size.height + 10;
    self.btnBottonDistance.constant = rect.size.height + 8;
}

- (void)keyboardHidden:(NSNotification *)noti{
    
    self.bottomDistance.constant =  10;
    self.btnBottonDistance.constant = 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMsg:(UIButton *)sender {
    
    if (self.msgText.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"发送的消息不能为空"];
    }
    else{
        if (self.msgType == SendMessageTableType) {
            [self postMsgTableType];
        }
        else
        {
            [self postMsgWebType];
        }
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.msgText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -  CustomMethods

- (void)postMsgWebType{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=UploadInfo&u=1&content=123&title=444&billno=&programid=0&reciveruid=2&billid=0
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=UploadInfo&u=%@&content=%@&title=%@&reciveruid=%@&programid=%@&billid=%@&billno=%@",self.uid,[self.msgText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"",@"",_newsModel.programid,_newsModel.billid,_newsModel.billno]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]){
                              [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                              [self.dataArray addObject:self.msgText.text];
                              [self.tableView reloadData];
                          }
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];

}

- (void)postMsgTableType{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=UploadInfo&u=1&content=123&title=444&billno=&programid=0&reciveruid=2&billid=0
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=UploadInfo&u=%@&content=%@&title=%@&billno=%@&programid=%@&reciveruid=%@&billid=%@",self.uid,[self.msgText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"",self.model.billno,self.model.programid,self.model.submituid,self.model.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]){
                              [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                              [self.dataArray addObject:self.msgText.text];
                              [self.tableView reloadData];
                          }
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];


    
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:11];
    label.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self fixStr:[self.dataArray objectAtIndex:indexPath.row] size:CGSizeMake(SCREEN_WIDTH, 9999999999) fontSize:14] + 15.0f;
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
