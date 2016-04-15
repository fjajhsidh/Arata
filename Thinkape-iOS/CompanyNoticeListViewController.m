//
//  CompanyNoticeListViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/4/24.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "CompanyNoticeListViewController.h"
#import "NoticeListViewCell.h"
#import "NewsModel.h"
#import "NewsDetailViewController.h"

@interface CompanyNoticeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation CompanyNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshNewsListData];
    }];
    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest

- (void)refreshNewsListData{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetInfoList&u=1&ukey=abc&pi=0&ps=20
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetInfoList&u=%@&ukey=%@&pi=0&ps=20",self.uid,self.ukey]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          [self.dataArray removeAllObjects];
                          for (NSDictionary *dic in dataArr) {
                              NewsModel *model = [[NewsModel alloc] init];
                              [model setValuesForKeysWithDictionary:dic];
                              if ([model.isannounce boolValue]) {
                                  [self.dataArray addObject:model];
                              }
                          }
                          [self.tableView.header endRefreshing];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.header endRefreshing];
                      }
            showLoadingStatus:NO];
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    NoticeListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];

    NewsModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.descLabel.text = model.title;
    cell.timeLabel.text = model.create_date;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
