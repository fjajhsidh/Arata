//
//  ParentsViewController.m
//  MaiDuoEr
//
//  Created by tixa on 15/4/10.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ParentsViewController.h"


@interface ParentsViewController ()

@end

@implementation ParentsViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"name : %@",[self class]);
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (IOS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = self.gestureEnabel;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.gestureEnabel = YES;
    if (self.navigationController.viewControllers.count>1) {
        UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBt setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        [backBt setFrame:CGRectMake(20, 10, 70, 44)];
        [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        [backBt addTarget:self action:@selector(Goback) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:backBt]];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
        self.navigationItem.backBarButtonItem = back;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        //        self.navigationController.interactivePopGestureRecognizer.enabled = _enabled;
    }
    
    // Do any additional setup after loading the view.
}

-(void)Goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertView:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - UITableView Delegate && DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (NSString *)uid{
    return [DataManager shareManager].uid;
}

- (NSString *)ukey{
    return [DataManager shareManager].ukey;
}

- (void)callPhoneNum:(NSString *)num{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSMutableString *phonenum = [NSMutableString stringWithFormat:@"tel:%@",num];
    NSURL *telURL =[NSURL URLWithString:phonenum];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}
// 调整字符串
- (CGFloat )fixStr:(NSString *)str size:(CGSize)size fontSize:(CGFloat)font{
    CGRect frame = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    return frame.size.height;
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
