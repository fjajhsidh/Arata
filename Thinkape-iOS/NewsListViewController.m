//
//  NewsListViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/19.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsModel.h"
#import "NewsListViewCell.h"
#import "SendMsgViewController.h"

@interface NewsListViewController ()
{
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self refreshNewsListData];
    }];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        _page +=1;
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
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetInfoList&u=%@&ukey=%@&pi=%ld&ps=20",self.uid,self.ukey,_page]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          if (_page == 0) {
                              [self.dataArray removeAllObjects];
                          }
                          for (NSDictionary *dic in dataArr) {
                              NewsModel *model = [[NewsModel alloc] init];
                              [model setValuesForKeysWithDictionary:dic];
                              if (![model.isannounce boolValue]) {
                                  [self.dataArray addObject:model];
                              }
                            
                          }
                          if (_page == 0) {
                              [self.tableView.header endRefreshing];
                          }
                          else
                          {
                              [self.tableView.footer endRefreshing];
                          }
                          
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
    NewsListViewCell *cell = (NewsListViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    
    NewsModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    cell.time.text = model.create_date;
    cell.userName.text = model.create_uid_show;
    cell.tiele.text = model.content;
    cell.isReadLabel.text = [model.isreaded isEqualToString:@"True"]? @"已读":@"未读";
//   // [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:model.msgurl]
//                      placeholderImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
    SendMsgViewController *detailVC = (SendMsgViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SendMsgVC"];
    detailVC.msgType = SendMessageWebType;
    detailVC.newsModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
