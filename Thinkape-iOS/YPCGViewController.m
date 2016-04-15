//
//  YPCGViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/12.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "YPCGViewController.h"
#import "CGModel.h"
#import "StayApprovalViewCell.h"
#import "SubmitApproveViewController.h"

@interface YPCGViewController ()
{
    BOOL isEdit;
    NSMutableArray * _selectArr;
    NSInteger tag;
}
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation YPCGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectArr = [[NSMutableArray alloc] init];
    _bottomView.transform = CGAffineTransformMakeTranslation(0, 150);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshYPCGData];
    }];
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBt setImage:[UIImage imageNamed:@"editItem"] forState:UIControlStateNormal];
    [backBt setFrame:CGRectMake(80, 10, 44, 44)];
    // [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
    self.navigationItem.rightBarButtonItem = back;

    [self.tableView.header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HttpRequest

- (void)refreshYPCGData{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=EnterSspCG&u=9  [NSString stringWithFormat:@"ac=EnterSspCG&u=%@",self.uid]
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=EnterSspCG&u=%@",self.uid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.dataArray removeAllObjects];
                          if ([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]) {
                              NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                              [self.dataArray addObjectsFromArray:[CGModel objectArrayWithKeyValuesArray:dataArr]];
                          }
                          
                          [self.tableView.header endRefreshing];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [self.tableView.header endRefreshing];
                      }
            showLoadingStatus:NO];
}

/**
 *  提交草稿生成单据
 *
 */
- (void)saveCGToBill:(NSString *)sspid ac:(NSString *)ac{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= SspCGToBills &u=9& sspid =3,4,5,6,7
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=%@&u=%@&sspid=%@",ac,self.uid,sspid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSString *msg = [responseObject objectForKey:@"msg"];
                          if ([msg isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                              isEdit = YES;
                              [self.tableView.header beginRefreshing];
                              [self editItem];
                          }
                          else
                              [SVProgressHUD showInfoWithStatus:msg];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
}

#pragma mark - BtnAction
/**
 *  删除多条草稿数据
 *
 */
- (IBAction)deleateMoreData:(UIButton *)sender {
    //DeleteSspCG
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"确定要删除多条信息吗"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 3000000;
    [alert show];
    
}

/**
 *  提交多条草稿数据
 *
 */
- (IBAction)commintMoreData:(UIButton *)sender {

    [self saveCGToBill:[self billsidParamater] ac:@"SspCGToBills"];
}

#pragma mark - CustomMethods

- (NSString *)billsidParamater{
    NSMutableString *sspid = [NSMutableString string];
    for (int i = 0 ; i < _selectArr.count; i ++) {
        CGModel *model = [_selectArr safeObjectAtIndex:i];
        if (i != _selectArr.count - 1) {
            [sspid appendFormat:@"%@,",model.SspID];
        }
        else
            [sspid appendFormat:@"%@",model.SspID];
    }
    return sspid;
}

- (void)selectItem:(CGModel *)model{
    
    if (model.status) {
        [_selectArr addObject:model];
    }
    else
    {
        [_selectArr removeObject:model];
    }
    
    UILabel *label = (UILabel *)[_bottomView viewWithTag:12];
    label.text = [NSString stringWithFormat:@"已选择%ld个项目同时处理",_selectArr.count];
}

- (void)editItem{
    isEdit = isEdit ? NO : YES;
    if (!isEdit) {
        for (CGModel *model in self.dataArray) {
            model.status = NO;
        }
        self.bottomConstraint.constant = 0.0f;
        
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 150);
        
        [self resetStatues];
    }
    else{
        self.bottomConstraint.constant = CGRectGetHeight(_bottomView.frame);
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
    
    [self.tableView reloadData];
}

- (void)resetStatues{
    // 底部视图消失时，重置选择数组
    [_selectArr removeAllObjects];
    _selectLabel.text = [NSString stringWithFormat:@"已选择%ld个项目同时处理",_selectArr.count];
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    StayApprovalViewCell *cell = (StayApprovalViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    
        id unkonwModel = [self.dataArray safeObjectAtIndex:indexPath.row];
        if ([unkonwModel isKindOfClass:[CGModel class]] ) {
            CGModel *model = (CGModel *)unkonwModel;
            if (isEdit) {
                cell.markImage.hidden = !model.status;
                cell.selectBtn.hidden = NO;
            }
            else{
                cell.markImage.hidden = YES;
                cell.selectBtn.hidden = YES;
            }
            [cell resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            cell.category.text = model.cname;
            cell.time.text = model.Create_Date;
            NSString *nameStr = [NSString stringWithFormat:@"%@-%@",model.cusername,model.cdepname];
            cell.nameHeight.constant = [self fixStr:nameStr size:CGSizeMake(SCREEN_WIDTH - 182, 99999) fontSize:13]+13;
            cell.name.text = nameStr;
            cell.money.text = [NSString stringWithFormat:@"￥%@",model.billmoney];
//            cell.decs.text = nil;
            cell.backLabel.text = @"删除";
            cell.agreeLabel.text = @"提交";
            cell.edit = YES;
        }
    
    cell.selectItem = ^(){
        CGModel *model = [self.dataArray objectAtIndex:indexPath.row];
        model.status = model.status ? NO: YES;
        [self selectItem:model];
        [self.tableView reloadData];
    };
    
    cell.backApply = ^(StayApprovalViewCell *cell){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"确定要删除此条信息吗"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = [tableView indexPathForCell:cell].row;
        [alert show];

    };
    cell.agreeApply = ^(StayApprovalViewCell *cell){
        NSIndexPath *index = [tableView indexPathForCell:cell];
        CGModel *model = [self.dataArray safeObjectAtIndex:index.row];
        [self saveCGToBill:model.SspID ac:@"SspCGToBills"];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubmitApproveViewController *subvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCGVC"];
    subvc.type = 1;
    subvc.editModel = [self.dataArray safeObjectAtIndex:indexPath.row];
 
    subvc.callback = ^(){
        [self.tableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:subvc animated:YES];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 3000000) {
            [self saveCGToBill:[self billsidParamater] ac:@"DeleteSspCG"];
        }
        else{
            CGModel *model = [self.dataArray safeObjectAtIndex:alertView.tag];
            [self saveCGToBill:model.SspID ac:@"DeleteSspCG"];
        }
    }
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
