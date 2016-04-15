//
//  StayApprovalDetailViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/5/11.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "StayApprovalDetailViewController.h"
#import "LayoutModel.h"
#import "CostLayoutModel.h"
#import "BillsDetailViewCell.h"
#import "CostDetailViewController.h"
#import "LinkViewController.h"
#import "SDPhotoBrowser.h"

@interface StayApprovalDetailViewController () <SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopConsraint;
@property (strong,nonatomic) NSMutableArray *mainLayoutArray; // 主表 布局视图
@property (strong,nonatomic) NSMutableArray *costLayoutArray; // 花费 布局视图
@property (nonatomic,strong) NSMutableArray *mainData;
@property (nonatomic,strong) NSMutableArray *costData;
@property (nonatomic,strong) NSArray *uploadArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITextField *beizhuText;
@end

@implementation StayApprovalDetailViewController
{
    int strIndex;
    NSString *contentStr;
    UIView * bgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBt setImage:[UIImage imageNamed:@"right_item"] forState:UIControlStateNormal];
    [backBt setFrame:CGRectMake(80, 10, 44, 44)];
    // [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
    self.navigationItem.rightBarButtonItem = back;
    
    self.toTopConsraint.constant = -188.0f;
    _mainLayoutArray = [[NSMutableArray alloc] init];
    _costLayoutArray = [[NSMutableArray alloc] init];
    _mainData = [[NSMutableArray alloc] init];
    _costData = [[NSMutableArray alloc] init];
    [self requestDataSource];
    [self addFooterView];
    
    // Do any additional setup after loading the view.
}

- (void)editItem{

    if (self.toTopConsraint.constant == -188.0f) {
        self.toTopConsraint.constant = 64;
    }
    else
        self.toTopConsraint.constant = -188.0f;
    
}

- (void)addFooterView{
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 90, SCREEN_WIDTH - 20, 90)];
    infoView.tag = 205;
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    
    if (!self.beizhuText) {
        self.beizhuText = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(infoView.frame) - 45, 30)];
        self.beizhuText.placeholder = @"请输入审批意见";
        self.beizhuText.clearsOnBeginEditing = YES;
        self.beizhuText.borderStyle = UITextBorderStyleRoundedRect;
        self.beizhuText.font = [UIFont systemFontOfSize:13];
        
    }
    [infoView addSubview:self.beizhuText];
    
    CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureBtn setFrame:CGRectMake(10, 50, btnWidth, 30)];
    [sureBtn addTarget:self action:@selector(agreeApprove) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:0.314 green:0.816 blue:0.361 alpha:1.000]];
    [sureBtn setTitle:@"同意" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor]];
    [infoView addSubview:sureBtn];
    
    UIButton *backBatn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, 50, btnWidth, 30)];
    [backBatn addTarget:self action:@selector(backApprove) forControlEvents:UIControlEventTouchUpInside];
    [backBatn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
    [backBatn setTitle:@"退回" forState:UIControlStateNormal];
    [backBatn setTitleColor:[UIColor whiteColor]];
    [infoView addSubview:backBatn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RequestMethods

// 单据详情接口
- (void)requestDataSource{
    
    //ac=GetEditData&u=9&programid=130102&billid=28
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetEditData&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSDictionary * mainLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"main"];
                          NSArray * costLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"details"];
                          [_mainLayoutArray addObjectsFromArray:[LayoutModel objectArrayWithKeyValuesArray:[mainLayout objectForKey:@"fields"]]];
                          [_costLayoutArray addObjectsFromArray:[CostLayoutModel objectArrayWithKeyValuesArray:costLayout]];
                          NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          _mainData = [dataArr safeObjectAtIndex:0];
                          
                          [_costData addObjectsFromArray:[dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _costLayoutArray.count)]]];
                          _uploadArr = [NSArray arrayWithArray:[[responseObject objectForKey:@"msg"] objectForKey:@"upload"]];
                          [self.tableView reloadData];
                          [SVProgressHUD dismiss];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];
    
}

- (void)zhuanpiRequest:(NSString *)uidStr{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=TransferApprove&u=1&ukey=abc&flowid=57&ProgramID=130102&Billid=9&StepID=616&DynamicID=6999&NewAppUid=100004&NewGuid=20140529155715693
    [SVProgressHUD showSuccessWithStatus:@"转批中..."];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=TransferApprove&u=%@&ukey=%@&flowid=%@&ProgramID=%@&Billid=%@&StepID=%@&DynamicID=%@&NewAppUid=%@&NewGuid=%@",self.uid,self.ukey,_unModel.flowid,_unModel.programid,_unModel.billid,_unModel.stepid,_unModel.dynamicid,uidStr,_unModel.newguid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"转批成功!"];
                              [self backVC];
                          }
                          else
                            [SVProgressHUD dismiss];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:NO];
}

- (void)jiaqianRequest:(NSString *)uidStr{
    
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=AddSign&u=1&ukey=abc&flowid=57&ProgramID=130102&Billid=9&StepID=616&DynamicID=6999&User=100003,100004,100005
    
    [SVProgressHUD showWithStatus:@"加签中..."];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=AddSign&u=%@&ukey=%@&flowid=%@&ProgramID=%@&Billid=%@&StepID=%@&DynamicID=%@&User=%@",self.uid,self.ukey,_unModel.flowid,_unModel.programid,_unModel.billid,_unModel.stepid,_unModel.dynamicid,uidStr]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"加签成功!"];
                              [self backVC];
                          }
                          else
                              [self showAlertView:[responseObject objectForKey:@"msg"]];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           [SVProgressHUD dismiss];
                      }
            showLoadingStatus:NO];
    
}

// 单条审批
- (void)singleApprove:(UnApprovalModel *)model type:(NSString *)type{
    //http://27.115.23.126:3032/ashx/mobile.ashx?ac=Approve&u=1&ukey=abc&ProgramID=130102&Billid=3&BillNo=NO130102_9&disc=fuck&stepid=617&returnrule=&dynamicid=6976&returntodynid=0&resultType=pass
    NSString *returntodynid;
    if (![model.returnrule isEqualToString:@"ChoiceReturnStep"]) {
        returntodynid = @"0";
    }
    else
    {
        
    }
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=Approve&u=%@&ukey=%@&ProgramID=%@&Billid=%@&BillNo=%@&disc=%@&stepid=%@&returnrule=%@&dynamicid=%@&returntodynid=%@&resultType=%@",self.uid,self.ukey,model.programid,model.billid,model.billno,[_beizhuText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],model.stepid,model.returnrule,model.dynamicid,returntodynid,type]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSString *msg = [[responseObject objectForKey:@"msg"] objectForKey:@"Msg"];
                          if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"pass"]) {
                              [SVProgressHUD showSuccessWithStatus:@"审批成功"];
                              [self backVC];
                          }
                          else if ([msg isEqualToString:@"ok"] && [type isEqualToString:@"fail"]){
                              [SVProgressHUD showSuccessWithStatus:@"退回成功"];
                              [self backVC];
                              
                          }
                          else
                          {
                              [SVProgressHUD showSuccessWithStatus:msg];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:NO];
    
}

- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.reloadData) {
        self.reloadData();
    }
    
}

#pragma mark - BtnAction

- (IBAction)callNum:(id)sender {
    [self callAction];
}



#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_mainLayoutArray.count == 0) {
        return 0;
    }
    else if (_uploadArr.count == 0){
        return _mainLayoutArray.count + 1;
    }
    else
        return _mainLayoutArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellid = @"cell";
    BillsDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    UIView *subView = [cell.contentView viewWithTag:203];
    UIView *subView1 = [cell.contentView viewWithTag:204];
    UIView *subView2 = [cell.contentView viewWithTag:205];
    [subView removeFromSuperview];
    [subView1 removeFromSuperview];
    [subView2 removeFromSuperview];
    
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    cell.lineViewHeight.constant = 0.5f;
    
    if (indexPath.row < _mainLayoutArray.count - 3) {
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@:",model.name];
        cell.contentLabel.text = [mainDataDic objectForKey:model.fieldname];
        if ([model.fieldname isEqualToString:@"totalmoney"]) {
            cell.contentLabel.textColor = [UIColor hex:@"f23f4e"];
        }
        else
            cell.contentLabel.textColor = [UIColor hex:@"333333"];

        cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
        
        
    }
    // 花费明细 判断条件
    else if (indexPath.row == _mainLayoutArray.count - 3) {
        cell.titleLabel.text =nil;
        cell.contentLabel.text = nil;
        [cell.contentView addSubview:[self costScrollView]];
        
    }
    else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1){
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row - 1];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@:",model.name];
        cell.contentLabel.text = [mainDataDic objectForKey:model.fieldname];
        if ([model.fieldname isEqualToString:@"totalmoney"]) {
            cell.contentLabel.textColor = [UIColor hex:@"f23f4e"];
        }
        else
            cell.contentLabel.textColor = [UIColor hex:@"333333"];
        cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
        
    }
    // 如果 图片数组为空，不创建这个cell
    else if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count != 0){
        cell.titleLabel.text =nil;
        cell.contentLabel.text = nil;
        bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
//        bgView.backgroundColor = [UIColor redColor];
        bgView.tag = 204;
        [self addItems:bgView];
        [cell.contentView addSubview:bgView];
        
    }
    else if ((indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count == 0) || (indexPath.row == _mainLayoutArray.count + 2 && _uploadArr.count != 0)){
        cell.titleLabel.text =nil;
        cell.contentLabel.text = nil;
        
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    if (indexPath.row == _mainLayoutArray.count - 3 && _costLayoutArray.count != 0) {
        return 80.0f;
    }
    else if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count != 0){
        CGFloat itemWidth = (SCREEN_WIDTH - 36 - 4)/3;
        int rows = _uploadArr.count / 3 + 1;
        return rows * itemWidth;
    }
    else if ((indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count == 0) || (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count != 0)){
        return 0;
    }
    else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1 ){
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row -1];
        return [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
    }
    else if (indexPath.row < _mainLayoutArray.count - 3){
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
        return [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
    }
    else
        return 0;
    
    
}

- (CGFloat )fixStr:(NSString *)str{
   CGRect frame = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 115, 99999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return  frame.size.height >=0 ? frame.size.height : 20;
}

- (void)addItems:(UIView *)view{
    
    CGFloat width = CGRectGetWidth(view.frame);
    CGFloat itemWidth = (width - 4)/3;
    int rows = _uploadArr.count / 3 + 1;
    [view setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, itemWidth * 0.75 * rows)];
    for (int i = 0; i < _uploadArr.count; i++) {
        int colum = i %3;
        int row = i/3;
        UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [itemView setFrame:CGRectMake(colum*(itemWidth + 2), row * (itemWidth * 0.75 + 2), itemWidth, itemWidth * 0.75)];
        itemView.tag = i;
        itemView.userInteractionEnabled  = YES;
        [itemView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_uploadArr safeObjectAtIndex:i]]] forState:UIControlStateNormal];
        [itemView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:itemView];
    }
}

- (void)showImage:(UIButton *)btn{
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = bgView;
    
    browser.imageCount = _uploadArr.count;
    
    browser.currentImageIndex = btn.tag;
    
    browser.delegate = self;
    
    [browser show]; // 展示图片浏览器
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
    return [imageView currentBackgroundImage];
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSLog(@"url %@",[_uploadArr objectAtIndex:index]);
    return [NSURL URLWithString:[_uploadArr objectAtIndex:index]];
}

- (UIScrollView *)costScrollView{
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, 80)];
    scroll.tag = 203;
    [scroll setContentSize:CGSizeMake(95*_costLayoutArray.count-35, 80)];
    scroll.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _costLayoutArray.count; i++) {
        CostLayoutModel *model = [_costLayoutArray safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetail:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentMode = UIViewContentModeScaleAspectFit;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]]
                                 forState:UIControlStateNormal
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    NSLog(@"imageSize:%f height %f",image.size.height,image.size.width);
                                }];
        btn.tag = i;
        
        UILabel *totleMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 57, 15)];
        totleMoney.textColor = [UIColor whiteColor];
        totleMoney.font = [UIFont systemFontOfSize:15];
        totleMoney.text = model.TotalMoney;
        totleMoney.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:totleMoney];
        
        [scroll addSubview:btn];
    }
    return scroll;
}
-(void)costDetail:(UIButton *)btn{
    
    CostDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CostDetailVC"];
    vc.costLayoutArray = _costLayoutArray;
    vc.costDataArr = _costData;
    vc.index = btn.tag;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)callAction{
    
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    NSString *phoneNum = [mainDataDic objectForKey:@"cphone"];
    if (phoneNum.length != 0) {
        [self callPhoneNum:phoneNum];
    }
    else
        [SVProgressHUD showInfoWithStatus:@"电话为空"];
    
    
}

- (void)agreeApprove{
    [self singleApprove:_unModel type:@"pass"];
}

- (void)backApprove{
    if (self.beizhuText.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写退回意见"];
    }
    else
    {
      [self singleApprove:_unModel type:@"fail"];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"zhuanpiToLink"]) {
        LinkViewController *link = (LinkViewController *)segue.destinationViewController;
        link.linkStyle = 1;
        link.titleStr = @"转批";
        link.selectPerson = ^(NSArray *selectArr ,NSInteger type){
            if (type == 1) {
                NSString *str = [self appendStr:selectArr];
                [self zhuanpiRequest:str];
            }
        };
    }
    else if ([segue.identifier isEqualToString:@"jiaqianToLink"]) {
        LinkViewController *link = (LinkViewController *)segue.destinationViewController;
        link.linkStyle = 2;
        link.titleStr = @"加签";
        link.selectPerson = ^(NSArray *selectArr ,NSInteger type){
            if (type == 2) {
                NSString *str = [self appendStr:selectArr];
                [self jiaqianRequest:str];
            }
        };
    }
}

- (NSString *)appendStr:(NSArray *)arr{
    
    NSMutableString *returnStr = [NSMutableString string];
    for (int i = 0; i < arr.count; i ++) {
        LianxiModel *model = [arr safeObjectAtIndex:i];
        if (i == arr.count - 1) {
            [returnStr appendString:model.iuserid];
        }
        else{
            [returnStr appendFormat:@"%@,",model.iuserid];
        }
    }
    return returnStr;
}

@end

