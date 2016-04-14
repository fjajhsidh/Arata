//
//  Bianjito.m
//  Thinkape-iOS
//
//  Created by admin on 15/12/29.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "Bianjito.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "Bianjiviewtableview.h"
#import "AppDelegate.h"
#import "MixiViewController.h"
#import "BianJiViewController.h"
@interface Bianjito ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview2;
@property(nonatomic,strong)UIAlertView *activer;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger firstindex;
@property(nonatomic,assign)BOOL ishandan;
@property(nonatomic,strong) NSMutableArray *costall;
@property(nonatomic,strong) NSMutableArray *asdc;
@property(nonatomic,assign)BOOL isDElegate;
@property (nonatomic,strong) NSMutableArray *moneyArray;


@end

@implementation Bianjito

{
    CGFloat width;
    CGFloat itemWidth;
    CGFloat speace;
    UILabel *label;
    UIView *editView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self viewDidLoad];
    [self.tableview reloadData];
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"明 细";
    
    itemWidth = 80;
    speace = 20;
    
    _moneyArray = [[NSMutableArray alloc]init];
    //右边导航按钮
    [self addRightNavgation];
    
    [self itemLength];
    //右下角按钮
    [self layoutScroll];
    self.scrollview.bounces=NO;
    self.navigationController.navigationBarHidden=NO;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.indexpage = _index;
    
    [self addLeftNavgation];
    
}
-(void)addRightNavgation{
    UIButton *imageview = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imageview setBackgroundImage:[UIImage imageNamed:@"jiaban_white.png"] forState:UIControlStateNormal];
    
    [imageview addTarget:self action:@selector(appcer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item =[[UIBarButtonItem alloc] initWithCustomView:imageview];
    
    self.navigationItem.rightBarButtonItem=item;
    
}
#pragma mark---完成按钮
-(void)addLeftNavgation
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [leftButton setTitle:@"完成" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftbuttonaction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftitem =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftitem;
    
}

//点击左边删除按钮调用
-(void)leftbuttonaction
{

    BianJiViewController *bianji = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    bianji.costData2 = _costDataArr;
    
    //删除
    
    for (NSArray *items in _costDataArr) {
        NSString *billmoney;
        long money = 0;
        long totalMoney =0;
        for (NSDictionary *dict in items) {
            billmoney = [dict objectForKey:@"billmoney"];
            money = [billmoney longLongValue];
//            money += money;
            totalMoney = money + totalMoney;
        }

        
        NSString * moneyStr0 = [NSString stringWithFormat:@"%ld",totalMoney];
        [_moneyArray addObject:moneyStr0];
       
        
    }
    
    
    bianji.isdeletes=YES;
    bianji.isChanges=YES;
    //删除的grid
    
    bianji.dictarry = self.dilct;
    
    bianji.moneyArray = [NSMutableArray arrayWithArray:_moneyArray];
    
    [self.navigationController popToViewController:bianji animated:YES];
   
}
#pragma mark---新增明细表跳转
-(void)appcer
{
    
    Bianjiviewtableview *vc =[Bianjiviewtableview new];
    vc.indexto = _index;
    vc.costArray=self.costLayoutArray;
    vc.costArr=self.costDataArr;
    vc.hudong=self.isDElegate;
    vc.dictarry=self.dilct;
    
    vc.btnIndex = self.index;
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//wo左下角的按钮
- (void)layoutScroll{
    
    UIScrollView  *bottomScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 80)];
    for (int i = 0; i < _costLayoutArray.count; i++) {
        CostLayoutModel *model = [_costLayoutArray safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetail:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        btn.tag = i;
        [bottomScroll addSubview:btn];
        UILabel *totleMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 57, 15)];
        totleMoney.textColor = [UIColor whiteColor];
        totleMoney.font = [UIFont systemFontOfSize:15];
        totleMoney.text = model.TotalMoney;
        totleMoney.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:totleMoney];
    }
    [bottomScroll setContentSize:CGSizeMake(95*_costLayoutArray.count, 80)];
    bottomScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bottomScroll];
}
- (void)costDetail:(UIButton *)btn
{
    _index = btn.tag;
    
    [self itemLength];
    [self.tableview reloadData];
    
}
- (void)itemLength{
    CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
    width = (itemWidth + speace) * model.fileds.count +100+ speace;
    self.tableview2.constant = width + 24;
}

#pragma mark -- tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //新增单元格的数据
    NSArray *array = [_costDataArr safeObjectAtIndex:_index ];
    
    return array.count + 2;
}

#pragma mark-----taleview代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //冲账，报销字符
    CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
    
    NSString *cellid = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.tag=indexPath.row;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
   
    if (indexPath.row == 0) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 17, width, 30)];
      
        bgView.backgroundColor = [UIColor colorWithRed:0.275 green:0.557 blue:0.914 alpha:1.000];
        [cell.contentView addSubview:bgView];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(13, 14, width, 15)];
        title.font = [UIFont systemFontOfSize:15];
        //冲账，报销字符
        title.text = model.name;
        title.textColor = [UIColor whiteColor];
        
        [bgView addSubview:title];
        
    }else{
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, width, 50)];
        bgView.tag = 304;
        for (int i = 0; i < model.fileds.count + 1; i++) {
           
            UIButton *button;
            if (i == 0 ) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(35,14, 40, 15)];
                button=[[UIButton alloc] initWithFrame:CGRectMake(10, 14, 40, 15)];
            }
            else{
                label = [[UILabel alloc] initWithFrame:CGRectMake(40+speace + (itemWidth + speace) * (i-1), 14, itemWidth, 15)];
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.tag = i;
            label.textColor = [UIColor colorWithHexString:@"333333"];
            label.textAlignment = NSTextAlignmentCenter;
            button=[[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.origin.x-speace+(itemWidth+speace)*(i-1)-10, 14, itemWidth, 15)];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.tag=i;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bgView addSubview:label];
            [bgView addSubview:button];
            
            if (indexPath.row == 1)
            {
                if (label.tag == 0) {
                    label.text = @"序号";
                }
                else
                {
                    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag - 1];
                    label.text = layoutModel.name;
                }
                
                if (button.tag==1) {
                    
                    [button setTitle:@"操作" forState:UIControlStateNormal];
                    
                   
                }
                
            }
            else
            {
                if (label.tag == 0) {
                    label.text = [NSString stringWithFormat:@"%ld",indexPath.row - 1];
                    
                   
                }else{
                   
                    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag -1];
                   
                    if (self.editstart==NO) {
                        
                    
                    _dataArr = [_costDataArr safeObjectAtIndex:_index];
                    }
                    //删除表单
                    if (self.isDElegate==YES) {
                       _dataArr = [_costDataArr safeObjectAtIndex:_index];
                    }
                    _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
                    
                    NSString *cc =[_datar objectForKey:layoutModel.fieldname];
                    label.text =cc;
                }
                if (button.tag==1) {
                    [button setTitle:@"删除" forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(buttonaction:) forControlEvents:UIControlEventTouchUpInside];
                     button.tag = indexPath.row-2;
                    [bgView addSubview:button];
                    
                }
            }
        }
        [cell.contentView addSubview:bgView];
        
        if ((indexPath.row - 2) % 2 == 0)
            bgView.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
        else
            //序号的背景
            bgView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
    
}
#pragma mark---点击tableviewcell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一行不能被点击
    if (indexPath.row==1||indexPath.row==0) {
        NSIndexPath *PATH =[self.tableview indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:PATH];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return;
    }

    CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
    AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:label.tag -1];
    _indexRow = indexPath.row-2;

    
    _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
    
    app.dict = _datar;
    //页数
   
    //cell的行数
    app.indexcor = _indexRow;
    //把字典数据展示到tableive上
    if (indexPath.row==_indexRow) {
        _datar = [_dataArr safeObjectAtIndex:indexPath.row-2];
        app.dict =_datar;
        label.text = [_datar objectForKey:layoutModel.fieldname];
            
        
    }
    

    MixiViewController *vc =[[MixiViewController alloc] init];
    vc.index = _index;
    
    vc.costatrraylost=self.costLayoutArray;
    vc.costarrdate=_costDataArr;
    vc.hudong=self.isDElegate;
    vc.indexsele=self.iscellindes;
    
    vc.oldMoney = self.oldMoney;
    vc.preMoney =  [_costDataArr[_index][indexPath.row-2] objectForKey:@"billmoney"];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
  
    vc.btnIndex = delegate.indexpage;
    
    
    
    
    //传删除的id的
    if ([self.dilct allKeys].count>0) {
         vc.dictarry = self.dilct;
    }
   
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark-----删除单元格的方法
-(void)buttonaction:(UIButton *)sender
{
    AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
    int select = app.indexpage;
    //点击的行数
    self.iscellindes= sender.tag;

    NSMutableArray *Costarry  =[NSMutableArray arrayWithArray:_costDataArr];
    //小数组
    NSMutableArray *dateer = [Costarry safeObjectAtIndex:_index];
    NSMutableArray *aler  =[NSMutableArray arrayWithArray:dateer];
    
    NSLog(@"button%ld",sender.tag);
    //点击的那个字典需要取id
    NSMutableDictionary *deleteDic =[aler safeObjectAtIndex:self.iscellindes];
    CostLayoutModel *model = [self.costLayoutArray safeObjectAtIndex:_index];
    //保存删除的id
    if([deleteDic objectForKey:@"billdetailid"]!=nil && ![[deleteDic objectForKey:@"billdetailid"] isEqualToString:@""]){
        if([self.dilct objectForKey:model.gridmainid]!=nil && ![[self.dilct objectForKey:model.gridmainid] isEqualToString:@""]){
            NSString *v = [self.dilct objectForKey:model.gridmainid];
            [self.dilct setObject:[NSString stringWithFormat:@"%@,%@",v,[deleteDic objectForKey:@"billdetailid"]] forKey:model.gridmainid];
        }else{
            [self.dilct setObject:[deleteDic objectForKey:@"billdetailid"] forKey:model.gridmainid];
        }
        
        
    }
    
    [aler removeObjectAtIndex:self.iscellindes];
    
    
    [Costarry replaceObjectAtIndex:_index withObject:aler];
    _costDataArr = Costarry;
    app.iscella=self.iscellindes;
    
    
  
     self.isDElegate = YES;
    
    [self.tableview reloadData];

}

#pragma mark----tableview高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 47.0f;
    }
    else
        return 50.0f;
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
