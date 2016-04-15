//
//  LinkViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/24.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "LinkViewController.h"
#import "LinkViewCell.h"

@interface LinkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraints;
@property (weak, nonatomic) IBOutlet UIButton *bottomSureBtn;

@end

@implementation LinkViewController

{
    int page;
    NSMutableArray *sortArray;
    NSMutableArray *selectArr;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    self.titleLabel.text = self.titleStr;
    sortArray = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self refreashNetData];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [self.tableView.header beginRefreshing];
    if (self.linkStyle == 0) {
        self.bottomSureBtn.transform = CGAffineTransformMakeTranslation(0, 80);
    }
    else{
        self.tableViewBottomConstraints.constant += 40;
        selectArr = [[NSMutableArray alloc] init];
    }
    // Do any additional setup after loading the view.
}

#pragma mark - RequestDataSource

- (void)refreashNetData{
    page = 0;
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetPerson&u=%@&ukey=%@&pi=%d&ps=200&q=%@",[DataManager shareManager].uid,[DataManager shareManager].ukey,page,[_searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.dataArray removeAllObjects];
                          NSDictionary *msgDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[LianxiModel objectArrayWithKeyValuesArray:[msgDic objectForKey:@"data"]]];
                          [self.tableView.header endRefreshing];
                          [self fixData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.header endRefreshing];
                      }
            showLoadingStatus:NO];
}

- (void)loadMoreData{
    page += 1;
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetPerson&u=%@&ukey=%@&pi=%d&ps=200&q=%@",[DataManager shareManager].uid,[DataManager shareManager].ukey,page,[_searchText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                         
                          NSDictionary *msgDic = [responseObject objectForKey:@"msg"];
                          [self.dataArray addObjectsFromArray:[LianxiModel objectArrayWithKeyValuesArray:[msgDic objectForKey:@"data"]]];
                          [self.tableView.footer endRefreshing];
                          [self fixData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.footer endRefreshing];
                      }
            showLoadingStatus:NO];
}

- (void)fixData{
    [sortArray removeAllObjects];
    NSLog(@"nsdate%f",[[NSDate date] timeIntervalSince1970]);
    for (LianxiModel *model in self.dataArray)
    {
        BOOL flag = NO;
        for (int i = 0;i < sortArray.count; i ++)
        {
            NSMutableDictionary *dic = [sortArray objectAtIndex:i];
            if ([model.cdepcode isEqualToString:[dic objectForKey:@"code"]])
            {
                NSMutableArray *array = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
                [array addObject:model];
                [dic setObject:array forKey:@"list"];
                [sortArray replaceObjectAtIndex:i withObject:dic];
                flag = YES;
            }
        }
        if (!flag) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:model.cdepcode forKey:@"code"];
            [dic setObject:model.cdepname forKey:@"name"];
            NSArray *array = [NSArray arrayWithObjects:model, nil];
            [dic setObject:array forKey:@"list"];
            [sortArray addObject:dic];
        }
    }
    
    [self.tableView reloadData];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sortArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [sortArray objectAtIndex:section];
    NSArray *listArray = [dic objectForKey:@"list"];
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    LinkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *dic = [sortArray objectAtIndex:indexPath.section];
    NSArray *listArray = [dic objectForKey:@"list"];
    
    LianxiModel *model = [listArray safeObjectAtIndex:indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.picpath] placeholderImage:Default_Head_Image];
    cell.nameLabel.text = model.cusername;
    cell.zhiweiLabel.text = model.cdepname;
    cell.phoneNum.text = model.cphone;
    cell.callNum = ^(NSString *phoneNum){
        [self callPhoneNum:phoneNum];
    };
    if (_linkStyle == 0) {
        cell.markImage.hidden = YES;
    }
    else{
        cell.markImage.hidden = !model.selected;
        cell.phoneBtn.hidden = YES;
    }
    
    return cell;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 33)];
    view.backgroundColor = RGB(239, 239, 239);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, SCREEN_WIDTH, 14)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"2f64b3"];
    label.text = [[sortArray objectAtIndex:section] objectForKey:@"name"];
    [view addSubview:label];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.linkStyle != 0) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[sortArray objectAtIndex:indexPath.section]];
        NSMutableArray *listArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"list"]];
        LianxiModel *model = [listArray objectAtIndex:indexPath.row];
        model.selected = !model.selected;
        [listArray replaceObjectAtIndex:indexPath.row withObject:model];
        [dic setObject:listArray forKey:@"list"];
        [sortArray replaceObjectAtIndex:indexPath.section withObject:dic];
        [self fixModel:model];
        [tableView reloadData];
    }
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

- (void)fixModel:(LianxiModel *)model{
    
    if (model.selected) {
        [selectArr addObject:model];
        if (self.linkStyle == 2) {
            [self selectCallBack:nil];
        }
    }
    else
        [selectArr removeObject:model];
    
}
- (IBAction)selectCallBack:(id)sender {
    if (self.selectPerson) {
        self.selectPerson(selectArr,self.linkStyle);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tableView.header beginRefreshing];
    [textField resignFirstResponder];
    return YES;
    
}

- (IBAction)doSearch:(id)sender {
    [_searchText resignFirstResponder];
    [self.tableView.header beginRefreshing];
}


- (IBAction)backVC:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
