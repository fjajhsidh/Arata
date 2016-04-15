//
//  ShenPI.m
//  Thinkape-iOS
//
//  Created by admin on 16/4/8.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "ShenPI.h"
#import "LayoutModel.h"
#import "CostLayoutModel.h"
#import "BillsDetailViewCell.h"
#import "CostDetailViewController.h"
#import "HistoryModel.h"
#import "HistoryViewCell.h"
#import "DocumentsFlowchartCell.h"
#import "SDPhotoBrowser.h"
#import "LinkViewController.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>
#import "CTToastTipView.h"
#import "SendMsgViewController.h"
#import "ImageModel.h"
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"
#import "BianJiViewController.h"
#import "applyChangeModel.h"
#import <Photos/Photos.h>
#import "AppDelegate.h"
#import "ShenpiTableViewCell.h"
#import "ViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
@interface ShenPI ()<SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,XYPieChartDelegate,XYPieChartDataSource,SimpleBarChartDataSource, SimpleBarChartDelegate>
{
     NSString *delteImageID;
     UIScrollView *view;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstaraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *HideView;

@property (strong,nonatomic) NSMutableArray *mainLayoutArray; // 主表 布局视图
@property (strong,nonatomic) NSMutableArray *costLayoutArray; // 花费 布局视图
@property (strong,nonatomic) NSMutableArray *pathFlow; // 审批流程
@property (nonatomic,strong) NSMutableArray *mainData;
@property (nonatomic,strong) NSMutableArray *costData;
@property (nonatomic,strong) NSMutableArray *uploadArr;
@property (assign, nonatomic) NSUInteger selectedIndex; // 0:单据详情 1:审批追溯 2:审批流程 default :0
@property (nonatomic , strong) NSMutableArray *imageArray;
@property(nonatomic,strong)UIActionSheet *actionsheet;


//wo

@property(strong,nonatomic)NSDictionary * changedict;
@property(strong,nonatomic)NSMutableArray * changeArr;
@property(strong,nonatomic)applyChangeModel * changeModel;

@property(weak,nonatomic)NSString * tuiHuiStr;
@property(nonatomic)BOOL tuihui;
@property(nonatomic,strong)NSString * leixing;
@property (nonatomic,strong) UITextField *beizhuText;
@property(nonatomic,strong)ViewController *views;
@property(nonatomic,strong)NSMutableArray *Criclearray;
@property(nonatomic,strong)NSArray *Criclecolour;
//预算统计视图
@property(nonatomic,strong)UIView *contentCz;
//饼图
@property(nonatomic,strong)XYPieChart *MaRu;
//柱状图
@property(nonatomic,strong)SimpleBarChart *chart;
@property(nonatomic,strong)NSArray *values;
@property(nonatomic,strong)NSArray *haikei;
@property(nonatomic,assign)NSInteger currentbar;
@property(nonatomic,strong)NSMutableArray *twoCsarry;
//颜色说明
@property(nonatomic,strong)UIView *setsu;
//颜色说明文字
@property(nonatomic,strong)UILabel *setsumoji;
@property(nonatomic,assign)BOOL arawasu;
@property(nonatomic,strong)UIButton *commintBtn;
@property(nonatomic,strong)UIButton *deleateButton;
@property(nonatomic,strong)UIButton *uploadButton;

@end

@implementation ShenPI
{
    UIView * bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    //柱状图文字
    NSArray *_monji;
    CGFloat lastConstant; // 记录最后一次tableView 与底部的距离
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.billType = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //wo
    NSLog(@"+++%lf,%lf",SCREEN_WIDTH,SCREEN_HEIGHT);
   
    self.tuihui=NO;
    
    self.selectedIndex = 0;
    self.selectedion2=0;
    self.title = @"详情";
    UIButton *firstBtn = (UIButton *)[self.topView viewWithTag:10];
    firstBtn.selected = YES;
    _mainLayoutArray = [[NSMutableArray alloc] init];
    _costLayoutArray = [[NSMutableArray alloc] init];
    _mainData = [[NSMutableArray alloc] init];
    _costData = [[NSMutableArray alloc] init];
    _pathFlow = [[NSMutableArray alloc] init];
    //wo 申请转报销转借款
    self.changeArr=[[NSMutableArray alloc]init];
    self.changeModel=[[applyChangeModel alloc]init];
    
    [self requestDataSource];
    self.topConstaraint.constant = -188.0f;
    
    lastConstant = 50.0f;
   
    if (self.billType == 1) {
        
        textFiledHeight = 0.0f;
        self.tableViewBottomConstraint.constant = 50 + textFiledHeight;
        UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBt setImage:[UIImage imageNamed:@"right_item"] forState:UIControlStateNormal];
        [backBt setFrame:CGRectMake(80, 10, 44, 44)];
        // [backBt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
        self.navigationItem.rightBarButtonItem = back;
        [self addFooterView];
    }
    self.views =[[ViewController alloc] init];
    self.views.view.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //  [bill didMoveToParentViewController:self];
    
    self.views.view.hidden=YES;
    
    [self addChildViewController:self.views];
  
    self.contentCz =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    self.contentCz.backgroundColor =[UIColor whiteColor];
//    [self.view addSubview:self.contentCz];
    self.contentCz.hidden=YES;
    view =[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentCz.frame.origin.y,SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    view.contentSize = CGSizeMake(self.chart.frame.size.width, 1000);
    view.userInteractionEnabled=YES;
    view.bounces=YES;
    //饼图的个数
    _Criclearray =[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i< 3; i++) {
        NSNumber *number = [NSNumber numberWithInt:rand()%60+20];
        [_Criclearray addObject:number];
        
    }
  
        [self MaruGodo];

    //柱状图的个数
    _twoCsarry = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<2; i++) {
        NSNumber *numer =[NSNumber numberWithInt:rand()%60+20];
        [_twoCsarry addObject:numer];
        
    }
    
    [self Histogram];
        // Do any additional setup after loading the view.
    
    [self gitaihandan];
    
}
-(void)gitaihandan
{
    //chisan 报销
    //shisa 审批
    //tokei 预算
    //miseru 流程
    
    if (DEVICE_IS_IPHONE5) {
        self.miserulay.constant = 70;
     
        self.lineWide.constant=70;
        self.misetulead.constant=70;
    }
    
}
#pragma mark------设置柱状图
-(void)Histogram
{
    
    
   //每个季度的数据
    self.values = @[@23, @45, @44, @0,
                    @45, @44,@60, @0,
                    @2, @95,@30, @0,
                    @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                     @44,@60,@60,@0,
                    ];
   //每个月份
    _monji =@[@"", @"1", @"",@"",
              @"", @"2", @"",@"",
              @"", @"3", @"",@"",
              @"", @"4", @"",@"",
              @"", @"5", @"",@"",
              @"", @"6", @"",@"",
              @"", @"7", @"",@"",
              @"", @"8", @"",@"",
              @"", @"9", @"",@"",
              @"", @"10", @"",@"",
              @"", @"11", @"",@"",
              @"", @"12", @"",@"",
              ];
    NSLog(@"%d,%d",self.values.count,_monji.count);
    
    self.haikei = [NSMutableArray arrayWithCapacity:0];
    self.haikei = @[[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1],[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:127/255.0 blue:88/255.0 alpha:1],[UIColor colorWithRed:218/255.0 green:112/255.0 blue:214/255.0 alpha:1]];
//    self.currentbar = 0;
   
    CGRect chartFrame				= CGRectMake(10,
                                                0,1200,340);
    if (DEVICE_IS_IPHONE5) {
        chartFrame = CGRectMake(10, 0, 1200, 320);
        
    }
    
    self.chart = [[SimpleBarChart alloc] initWithFrame:chartFrame];
    // self.chart.center = CGPointMake(view.frame.size.width / 2.0, self.);
    
    
    self.chart.dataSource=self;
    self.chart.delegate=self;
    self.chart.barShadowOffset = CGSizeMake(2.0, 1.0);
    self.chart.animationDuration =1.0;
    self.chart.barShadowColor = [UIColor blueColor];
    self.chart.barShadowAlpha = 0.1;
    self.chart.barShadowRadius = 50.0;
    self.chart.barWidth= 30.0;
    self.chart.xLabelType = SimpleBarChartXLabelTypeHorizontal;
    self.chart.xLabelFont = [UIFont systemFontOfSize:14];
    self.chart.barTextFont=[UIFont systemFontOfSize:18];
    self.chart.incrementValue=15;
    
    
    self.chart.barTextType = SimpleBarChartBarTextTypeRoof;
    
    self.chart.gridColor = [UIColor grayColor];
     [self irotsuke];
    UIView *roki = [[UIView alloc] initWithFrame:CGRectMake(0, 370, SCREEN_WIDTH, SCREEN_HEIGHT)];
    roki.backgroundColor =[UIColor clearColor];
    UIScrollView *suberi =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    suberi.backgroundColor =[UIColor blueColor];
    suberi.contentSize = CGSizeMake(self.chart.frame.size.width, self.chart.frame.size.height);
    [roki addSubview:suberi];
    [suberi addSubview:self.chart];
    [view addSubview:roki];
  
    
}
-(void)irotsuke
{
    
    
    
    //已使用
    UIView *shiyo =[[UIView alloc] init];
    
    shiyo.frame =CGRectMake(20, 316, 42, 21);
    NSLog(@"%lf",view.frame.size.height-420);
    shiyo.backgroundColor = [UIColor colorWithRed:100/255.0 green:149/255.0 blue:250/255.0 alpha:1];
    UILabel *shiyolay =[[UILabel alloc] init];
    shiyolay.frame = CGRectMake(20,317 , 42, 21);
    
    
    shiyolay.text=@"已使用";
    shiyolay.font = [UIFont systemFontOfSize:14];
    [view addSubview:shiyo];
    [view addSubview:shiyolay];
    
    //未使用
     UIView *mada =[[UIView alloc] initWithFrame:CGRectMake(69, 316, 42, 21)];
   mada.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    [view addSubview:mada];
    
    UILabel *madalay =[[UILabel alloc] initWithFrame:CGRectMake(69, 317, 42, 21)];
    
    madalay.text=@"未使用";
    madalay.font =[UIFont systemFontOfSize:14];
    [view addSubview:madalay];
    
    //占用
    UIView *shikichi =[[UIView alloc] initWithFrame:CGRectMake(69+48,316, 42, 21)];
    shikichi.backgroundColor =[UIColor colorWithRed:255/255.0 green:127/255.0 blue:88/255.0 alpha:1];
    UILabel *shikichilay =[[UILabel alloc]initWithFrame:CGRectMake(70+47,317 , 42, 21)];
    shikichilay.text=@"占用";
    shikichilay.font =[UIFont systemFontOfSize:14];
    [view addSubview:shikichi];
    [view addSubview:shikichilay];
    //全额
    UIView *subede =[[UIView alloc] initWithFrame:CGRectMake(70+47*2, 316, 42, 21)];
    subede.backgroundColor =[UIColor colorWithRed:218/255.0 green:112/255.0 blue:214/255.0 alpha:1];
    [view addSubview:subede];
    UILabel *subedelay =[[UILabel alloc] initWithFrame:CGRectMake(70+47*2, 317, 42, 21)];
    subedelay.text=@"全额";
    subedelay.font = [UIFont systemFontOfSize:14];
    [view addSubview:subedelay];
    UILabel *soka =[[UILabel alloc] initWithFrame:CGRectMake(70+47*3, 316, 60, 21)];
   
    soka.text = @"=200";
    soka.font =[UIFont systemFontOfSize:14];
    [view addSubview:soka];
    
    
    //月
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10,710, 14, 10) ];
    NSLog(@"%lf",(view.frame.size.height-345)+280);
    label.text=@"月";
    label.font=[UIFont systemFontOfSize:12];
    
    [view addSubview:label];
    //公司说明
    UILabel *kaisha =[[UILabel alloc] initWithFrame:CGRectMake(10, 740, SCREEN_WIDTH, 40)];
    NSLog(@"%f",label.frame.origin.y+40);
    
    kaisha.textAlignment = NSTextAlignmentCenter;
    kaisha.text =@"思凯普2015年年度预算展示图";
    [view addSubview:kaisha];
    
    
}
//wo添加申请转报销，申请转借款的按钮
-(void)addRightNagationBar{
    AppDelegate *ap=[UIApplication sharedApplication].delegate;
    NSLog(@"转报销转借款%@",ap.zhuanStr);
    NSLog(@"转报销转借款%@",self.leixing);
    //    if ([ap.danJu isEqualToString:@"未完成审批"]) {
    //        if ([ap.flowstatus isEqualToString:@"未提交"]||[ap.flowstatus isEqualToString:@"已退回"]||[ap.flowstatus isEqualToString:@"已弃申"]) {
    //
    //
    //            UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(item3Click:)];
    //       //     self.navigationItem.rightBarButtonItems = @[item3];
    //        }
    //    }
    
    
    if ([ap.zhuanStr isEqualToString:@"11"]) {
        if([ap.danJu isEqualToString:@"已完成审批"]){
            
            if ([self.leixing isEqualToString:@"差旅申请交通费明细"]) {
                UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"转报销" style:UIBarButtonItemStylePlain target:self action:@selector(item1Click:)];
                if (self.changeArr.count) {
                    self.navigationItem.rightBarButtonItem = item1;}
            }else if ([self.leixing isEqualToString:@"差旅申请借款明细"]){
                
                UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"转借款" style:UIBarButtonItemStylePlain target:self action:@selector(item2Click:)];
                if (self.changeArr.count) {
                    self.navigationItem.rightBarButtonItem=item2;
                    
                    
                }
                
                
            }
            
            //            UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"转报销" style:UIBarButtonItemStylePlain target:self action:@selector(item1Click:)];
            //
            //            UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"转借款" style:UIBarButtonItemStylePlain target:self action:@selector(item2Click:)];
            //            if (self.changeArr.count) {
            //                self.navigationItem.rightBarButtonItems = @[item1, item2];
            //
            
            
        }
    }
    NSLog(@"changeArr%@",self.changeArr);
}
-(void)item1Click:(id)sender{
    if (self.changeArr.count) {
        for (int i=0; i<self.changeArr.count; i++) {
            if ([[[self.changeArr objectAtIndex:i] objectForKey:@"barText"] isEqualToString:@"转差旅费报销"]) {
                self.changeModel.iid=[[self.changeArr objectAtIndex:i] objectForKey:@"iid"];
                
                self.changeModel.SourceProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"];
                self.changeModel.TargetProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"];
                self.changeModel.barText=[[self.changeArr objectAtIndex:i] objectForKey:@"barText"];
                NSLog(@"barText%@",[[self.changeArr objectAtIndex:i] objectForKey:@"barText"]);
                NSLog(@"TargetProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"]);
                NSLog(@"SourceProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"]);
                NSLog(@"iid%@",[[self.changeArr objectAtIndex:i] objectForKey:@"iid"]);
                for (NSString *key in self.changeArr[i]) {
                    NSLog(@"%@字典%@",key,self.changeArr[i][key]);
                }
                NSLog(@"数组%@",self.changeArr[i]);
                NSLog(@"模型%@",self.changeModel);
                [self zhuanBaoXiaoHuoJieKuan];
            }
            
        }
    }
    
}
-(void)item2Click:(id)sender{
    
    if (self.changeArr.count) {
        for (int i=0; i<self.changeArr.count; i++) {
            if ([[[self.changeArr objectAtIndex:i] objectForKey:@"barText"] isEqualToString:@"生成借款单"]) {
                self.changeModel.iid=[[self.changeArr objectAtIndex:i] objectForKey:@"iid"];
                
                self.changeModel.SourceProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"];
                self.changeModel.TargetProgramID=[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"];
                self.changeModel.barText=[[self.changeArr objectAtIndex:i] objectForKey:@"barText"];
                NSLog(@"barText%@",[[self.changeArr objectAtIndex:i] objectForKey:@"barText"]);
                NSLog(@"TargetProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"TargetProgramID"]);
                NSLog(@"SourceProgramID%@",[[self.changeArr objectAtIndex:i] objectForKey:@"SourceProgramID"]);
                NSLog(@"iid%@",[[self.changeArr objectAtIndex:i] objectForKey:@"iid"]);
                for (NSString *key in self.changeArr[i]) {
                    NSLog(@"%@字典%@",key,self.changeArr[i][key]);
                }
                NSLog(@"数组%@",self.changeArr[i]);
                NSLog(@"模型%@",self.changeModel);
                [self zhuanBaoXiaoHuoJieKuan];
            }
            
        }
    }
}
//wo上传后台转借款或报销

-(void)zhuanBaoXiaoHuoJieKuan{
    
    NSString *str=[NSString stringWithFormat:@"ac=AutoCreate&u=%@&SourceProgramID=%@&TargetProgramID=%@&BillID=%@&IsAutoSubmit=%@",self.uid,self.changeModel.SourceProgramID,self.changeModel.TargetProgramID,self.billid,@"0"];
    NSLog(@"请求的转%@",str);
    [RequestCenter GetRequest:str                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSLog(@"接收到的responseObject%@",responseObject);
                          [SVProgressHUD showSuccessWithStatus:@"成功"];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"错误%@",error);
                          [SVProgressHUD showSuccessWithStatus:@"失败"];
                      }];
    
    
}

- (void)editItem{
    
    if (self.topConstaraint.constant == -188.0f) {
        self.topConstaraint.constant = 64;
    }
    else
        self.topConstaraint.constant = -188.0f;
    
}
- (void)addFooterView{
    infoView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight)];
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.tag = 1024;
    [self.view addSubview:infoView];
    
    if (!self.beizhuText) {
        CGFloat y = textFiledHeight == 0 ? 0 :10;
        self.beizhuText = [[UITextField alloc] initWithFrame:CGRectMake(10, y, CGRectGetWidth(infoView.frame) - 45, textFiledHeight)];
        self.beizhuText.placeholder = @"请输入审批意见";
        self.beizhuText.clearsOnBeginEditing = YES;
        self.beizhuText.borderStyle = UITextBorderStyleRoundedRect;
        self.beizhuText.font = [UIFont systemFontOfSize:13];
    }
    
    [infoView addSubview:self.beizhuText];
    
    CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
    sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureBtn setFrame:CGRectMake(10, CGRectGetMaxY(self.beizhuText.frame) + 10, btnWidth, 30)];
    [sureBtn addTarget:self action:@selector(agreeApprove) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:0.314 green:0.816 blue:0.361 alpha:1.000]];
    [sureBtn setTitle:@"同意" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor]];
    sureBtn.tag = 1025;
    [infoView addSubview:sureBtn];
    
    backBatn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    [backBatn addTarget:self action:@selector(backApprove:) forControlEvents:UIControlEventTouchUpInside];
    [backBatn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
    [backBatn setTitle:@"退回" forState:UIControlStateNormal];
    [backBatn setTitleColor:[UIColor whiteColor]];
    sureBtn.tag = 1026;
    [infoView addSubview:backBatn];
}

#pragma mark - URL Request

/**
 *  单据信息
 */
- (void)requestDataSource{
    
    //ac=GetEditData&u=9&programid=130102&billid=28
    
    NSString * str=[NSString stringWithFormat:@"ac=GetEditData&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.billid];
    
    NSLog(@"意义%@",str);
    [RequestCenter GetRequest:str                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSDictionary * mainLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"main"];
                          NSLog(@"字典%@",mainLayout);
                          NSArray * costLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"details"];
                          //                          NSLog(@"数组%@",costLayout[0]);
                          //wo
                          //                          self.leixing=[costLayout[0] objectForKey:@"name"];
                          //     NSLog(@"类型%@",self.leixing);
                          
                          
                          [_mainLayoutArray addObjectsFromArray:[LayoutModel objectArrayWithKeyValuesArray:[mainLayout objectForKey:@"fields"]]];
                          [_costLayoutArray addObjectsFromArray:[CostLayoutModel objectArrayWithKeyValuesArray:costLayout]];
                          
                          
                          //wo
                          //                          self.changeArr=[[NSMutableArray alloc] init];
                          //                          self.changeArr=[[responseObject objectForKey:@"msg"] objectForKey:@"btn"];
                          //
                          
                          
                          NSArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          _mainData = [dataArr safeObjectAtIndex:0];
                          
                          [self addCommintBtn];
                          
                          [_costData addObjectsFromArray:[dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _costLayoutArray.count)]]];
                          _uploadArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"msg"] objectForKey:@"upload"]];
                          //                          if (_uploadArr==nil) {
                          //                              UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
                          //                              [_uploadArr addObject:image];
                          //
                          //                          }
                          [self.tableView reloadData];
                          [SVProgressHUD dismiss];
                          //wo
                          //                      [self addRightNagationBar];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];
    
}

/**
 *  审批历史
 */
- (void)requestHistory{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetApproveHistory&u=1&ukey=abc&flowid=57&ProgramID=130102&Billid=9
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetApproveHistory&u=%@&ukey=%@&ProgramID=%@&Billid=%@",self.uid,self.ukey,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [SVProgressHUD dismiss];
                          NSArray *array = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          [self.dataArray addObjectsFromArray:[HistoryModel objectArrayWithKeyValuesArray:array]];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
}

/**
 *  审批流程
 */
- (void)requestFlowPath{
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetFlowPath&u=%@&ukey=%@&ProgramID=%@&Billid=%@",self.uid,self.ukey,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          _pathFlow = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          [SVProgressHUD dismiss];
                          [self.tableView reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
}

/**
 *  转批接口
 *
 *  @param uidStr uidStr
 */
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
                              [self showAlertView:[responseObject objectForKey:@"msg"]];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:NO];
}

/**
 *  加签 接口
 *
 *  @param uidStr uidStr
 */

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

- (IBAction)guanzhu:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [SVProgressHUD showWithStatus:@"关注..." maskType:2];
    //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=BillAttention&u=1&programid=130102&billid=22&status=1
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=BillAttention&u=%@&programid=%@&billid=%@&status=1",self.uid,_unModel.programid,_unModel.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              [btn setTitle:@"已关注" forState:UIControlStateNormal];
                              [SVProgressHUD showSuccessWithStatus:@"关注成功!"];
                              // [self backVC];
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
    NSString *returntodynid = @"0";
    //    if (![model.returnrule isEqualToString:@"ChoiceReturnStep"]) {
    //        returntodynid = @"0";
    //    }
    //    else
    //    {
    //
    //    }
    
    //wo
    NSString *strRequest=[NSString stringWithFormat:@"ac=Approve&u=%@&ukey=%@&ProgramID=%@&Billid=%@&BillNo=%@&disc=%@&stepid=%@&returnrule=%@&dynamicid=%@&returntodynid=%@&resultType=%@",self.uid,self.ukey,model.programid,model.billid,model.billno,[_beizhuText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],model.stepid,model.returnrule,model.dynamicid,returntodynid,type];
    
    [RequestCenter GetRequest:strRequest
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]){
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
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"msg"]];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:NO];
    
}

/**
 *  未提交的数据进行提交 : type==0的时候接口
 */
- (void)commintInfo{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=UnCompleteSubmit&u=1&programid=130102&billid=139&billno=PTBX1508160033
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=UnCompleteSubmit&u=%@&programid=%@&billid=%@&billno=%@",self.uid,self.programeId,self.bills.billid,self.bills.billno]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                              if (self.reloadData) {
                                  self.reloadData();
                              }
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                          else
                          {
                              [SVProgressHUD showSuccessWithStatus:@"提交失败"];
                          }
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }];
}

- (void)deleateOrder{
    //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac=DeleteRecord&u=5&programid=130102&billid=382
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=DeleteRecord&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.bills.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                          if (self.reloadData) {
                              self.reloadData();
                          }
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }];
}

#pragma mark - BtnAciton

- (IBAction)changePage:(UIButton *)sender {
    
    UIView *footerView = [self.view viewWithTag:1024];
    for (UIView *subView in self.topView.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subBtn.tag == sender.tag) {
                subBtn.selected = YES;
                CGRect frame = self.lineView.frame;
                [UIView animateWithDuration:0.3 animations:^{

                    
                     self.lineLeftConstraint.constant =frame.size.width * (subBtn.tag -10);

                }];
                if (sender.tag == 10) {
                    if (_commintBtn.hidden==YES) {
                        _commintBtn.hidden=NO;
                        _deleateButton.hidden=NO;
                        _uploadButton.hidden=NO;
                    }
                   
                    self.selectedIndex = 0;

                    if (self.contentCz.hidden==NO) {
                        self.contentCz.hidden=YES;
                    }
                    footerView.hidden = NO;
                      NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
                    if (self.billType == 1) {
                        
                        self.tableViewBottomConstraint.constant = lastConstant;
                    }
                  
                   else if (self.billType == 0 &&([[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"])) {
                        self.tableViewBottomConstraint.constant = 135.0f;
                      
                    }else
                    {
                        self.tableViewBottomConstraint.constant=0;
                    }
                    
                    
                }
                else if(sender.tag == 11){
                    if (_commintBtn.hidden==YES) {
                        _commintBtn.hidden=NO;
                        _deleateButton.hidden=NO;
                        _uploadButton.hidden=NO;
                    }
                    
                    
                    if (self.contentCz.hidden==NO) {
                        self.contentCz.hidden=YES;
                    }
                    self.selectedIndex = 1;
                    if (self.dataArray.count == 0) {
                        [self requestHistory];
                    }
                    footerView.hidden = YES;
                    self.tableViewBottomConstraint.constant = 135;
                }
                else if (sender.tag == 12){
                    if (_commintBtn.hidden==YES) {
                        _commintBtn.hidden=NO;
                        _deleateButton.hidden=NO;
                        _uploadButton.hidden=NO;
                    }
                   
                    if (self.contentCz.hidden==NO) {
                        self.contentCz.hidden=YES;
                    }
                    self.selectedIndex = 2;
                    if (self.pathFlow.count == 0) {
                        [self requestFlowPath];
                    }
                    footerView.hidden = YES;
                    self.tableViewBottomConstraint.constant = 0;
                }
                
                else if (sender.tag == 13){
                    if (_commintBtn.hidden==NO) {
                        _commintBtn.hidden=YES;
                        _uploadButton.hidden=YES;
                        _deleateButton.hidden=YES;
                    }
                    
                    
                    
                    self.selectedIndex=3;
//                    if ( self.views.view.hidden==YES) {
//                        self.views.view.hidden=NO;
//                    }
//                    [self.view addSubview:self.HideView];
//                    [self.view addSubview:self.views.view];
//                    
//                    footerView.hidden = YES;
//                    self.tableViewBottomConstraint.constant = 0;
                    if (self.contentCz.hidden==YES) {
                        self.contentCz.hidden=NO;
                    }
             
                    
                      footerView.hidden = YES;
                    self.tableViewBottomConstraint.constant = 0;
                }
                

                [self.tableView reloadData];
            }
                        else
                subBtn.selected = NO;
        }
        
    }
    
}
- (BOOL)isUnCommint{
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    return [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"];
}

- (IBAction)callNum:(id)sender {
    [self callAction];
}

- (void)agreeApprove{
    [self singleApprove:_unModel type:@"pass"];
}

- (void)backApprove:(UIButton *)btn{
    
    if (btn.selected == NO) {
        btn.selected = YES;
        [self resizeFootViewFrame:0];
    }
    else {
        if (self.beizhuText.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请填写退回意见"];
        }
        else
        {
            btn.selected = NO;
            [self singleApprove:_unModel type:@"fail"];
            [self resizeFootViewFrame:1];
            //wo
            self.tuiHuiStr=self.beizhuText.text;
        }
    }
}
#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number = 0;
    switch (self.selectedIndex) {
        case 0:
        {
            if (_mainLayoutArray.count == 0) {
                number = 0;
            }
            else if (_uploadArr.count == 0){
                if ([self isUnCommint]) {
                    number = _mainLayoutArray.count + 2;
                    
                }
                else{
                    number = _mainLayoutArray.count + 1;
                    //更多
                    
                }
            }
            else
                number = _mainLayoutArray.count + 2;
            
        }
            break;
        case 1:{
            number = self.dataArray.count;
        }
            break;
        case 2:{
            number = self.pathFlow.count;
        }
            break;
        case 3:
        {
            number = 1;
        }
            break;
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_selectedIndex) {
        case 0:
        {
            NSString *cellid = @"cell2";
            ShenpiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            
            UIView *subView = [cell.contentView viewWithTag:203];
            UIView *subView1 = [cell.contentView viewWithTag:204];
            [subView removeFromSuperview];
            [subView1 removeFromSuperview];
            
            NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
            cell.lineViewHeight.constant = 0.5f;
            
            if (indexPath.row < _mainLayoutArray.count) {
                LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
                cell.titleLabel.text = [NSString stringWithFormat:@"%@:",model.name];
                if([model.name containsString:@"<"]){
                    cell.titleLabel.text=[self filterHTML:[NSString stringWithFormat:@"%@",model.name]];
                    
                }
                cell.contentLabel.text = [mainDataDic objectForKey:model.fieldname];
                
                cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
                if ([model.fieldname isEqualToString:@"totalmoney"]) {
                    cell.contentLabel.textColor = [UIColor hex:@"f23f4e"];
                }
                else
                    cell.contentLabel.textColor = [UIColor hex:@"333333"];
                
            }
            if (indexPath.row == _mainLayoutArray.count) {
                cell.titleLabel.text =nil;
                cell.contentLabel.text = nil;
                [cell.contentView addSubview:[self costScrollView]];
                
            }
            //            else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1){
            //                LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row - 1];
            //                cell.titleLabel.text = [NSString stringWithFormat:@"%@:",model.name];
            //                cell.contentLabel.text = [mainDataDic objectForKey:model.fieldname];
            //                cell.contentLabelHeight.constant = [self fixStr:[mainDataDic objectForKey:model.fieldname]];
            //                if ([model.fieldname isEqualToString:@"totalmoney"]) {
            //                    cell.contentLabel.textColor = [UIColor hex:@"f23f4e"];
            //                }
            //                else
            //                    cell.contentLabel.textColor = [UIColor hex:@"333333"];
            //            }
            else if (indexPath.row == _mainLayoutArray.count + 1){
                cell.titleLabel.text =nil;
                cell.contentLabel.text = nil;
                if (!bgView) {
                    bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
                    bgView.tag = 204;
                }
                NSInteger count = _imageArray.count + _uploadArr.count;
                CGFloat speace = 15.0f;
                CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
                int row = count / 3 + 1;
                //bgView.backgroundColor = [UIColor redColor];
                [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
                [bgView removeFromSuperview];
                [self addItems:bgView];
                [cell.contentView addSubview:bgView];
                 self.tableViewBottomConstraint.constant =100;
            }
           
            return cell;
            
        }
            break;
        case 1:{
            NSString *cellID = @"Histroy";
            HistoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryViewCell" owner:self options:nil] lastObject];
            }
            HistoryModel *model = [self.dataArray safeObjectAtIndex:indexPath.row];
            cell.name.text = model.cusername;
            cell.time.text = model.approve_date;
            cell.advice.text = model.resulttype;
            cell.stepName.text = model.stepname;
            cell.stepName.hidden = model.stepname.length > 0 ?NO : YES;
            //wo    退回意见
            if ([model.resulttype isEqualToString:@"不同意"]) {
                cell.advice.text = model.appopinion;
            }else{
                cell.advice.text = model.resulttype;
            }
            
            
            
            
            
            if (indexPath.row == self.dataArray.count - 1) {
                cell.lineView.hidden = YES;
            }
            return cell;
        }
            break;
            
        case 2:{
            static NSString *cellstr = @"DocumentsFlowchartCell";
            DocumentsFlowchartCell *cell = (DocumentsFlowchartCell*)[tableView cellForRowAtIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:cellstr];
            if (cell == nil) {
                cell = [[DocumentsFlowchartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if ([[[_pathFlow objectAtIndex:indexPath.row] objectForKey:@"stepname"] isEqualToString:@"未发起流程"]) {
                cell.lab_title.text = @"未提交";
            }else{
                cell.lab_title.text = [[_pathFlow objectAtIndex:indexPath.row] objectForKey:@"stepname"];
            }
            if (_pathFlow.count == 1) {
                cell.lab_title.backgroundColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];;
                cell.lab_line.hidden = YES;
                [cell setStyle:1];
            }else if (indexPath.row == 0){
                cell.lab_title.backgroundColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];;
                cell.lab_line.textColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];;
                [cell setStyle:1];
            }else if (indexPath.row == _pathFlow.count-1){
                cell.lab_title.backgroundColor = [UIColor colorWithRed:0.941 green:0.227 blue:0.192 alpha:1.000];
                cell.lab_line.hidden = YES;
                [cell setStyle:2];
            }else{
                if ([[[_pathFlow objectAtIndex:indexPath.row] objectForKey:@"isactive"] isEqualToString:@"1"]) {
                    cell.lab_title.backgroundColor = [UIColor colorWithRed:0.847 green:0.737 blue:0.267 alpha:1.000];
                    cell.lab_title.text = [cell.lab_title.text stringByAppendingString:@"(审批中)"];
                }
            }
            cell.backgroundColor = [UIColor clearColor];
            return cell;
            
        }
            break;
         case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
               
            }
           
            [self.MaRu reloadData];
            [self.chart reloadData];
            [self.contentCz addSubview:view];
            [self gitaihandan];
            [cell.contentView addSubview:self.contentCz];
            
            return cell;

        }
            break;
        default:
            break;
    }
    
    return nil;
    
    
}
#pragma mark ----饼图
-(void)MaruGodo
{
    self.MaRu = [[XYPieChart alloc] initWithFrame:CGRectMake(10, 20, view.frame.size.width-150, view.frame.size.height-160)];
    self.MaRu.dataSource=self;
    self.MaRu.delegate=self;
    self.MaRu.startPieAngle=M_PI_2;
    self.MaRu.pieCenter = CGPointMake(view.center.x, 120);
    self.MaRu.animationSpeed =1.0;
   
    self.MaRu.showPercentage= YES;
    
//    self.Criclecolour = [NSArray arrayWithObjects:
//                         [UIColor colorWithRed:123/255.0 green:155/255.0 blue:0/255.0 alpha:1],
//                         [UIColor colorWithRed:69/255.0 green:98/255.0 blue:166/255.0 alpha:1],nil];
    self.Criclecolour=[NSArray arrayWithObjects:[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1],[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:127/255.0 blue:88/255.0 alpha:1],nil];
    self.setsu = [[UIView alloc] initWithFrame:CGRectMake(15, 108, 42, 21)];
    self.setsu.backgroundColor =[UIColor colorWithRed:100/255.0 green:149/255.0 blue:237/255.0 alpha:1];
    [view addSubview:self.setsu];
    self.setsumoji = [[UILabel alloc] initWithFrame:CGRectMake(15, 109, 42, 21)];
    self.setsumoji.text=@"未使用";
    self.setsumoji.font =[UIFont systemFontOfSize:14];
    UIView *shiyo = [[UIView alloc] initWithFrame:CGRectMake(15, 131, 42, 21)];
    [view addSubview:shiyo];
    UILabel *shitsu =[[UILabel alloc] initWithFrame:CGRectMake(15, 132, 42, 21)];
    shitsu.text=@"已使用";
    shitsu.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    shitsu.font = [UIFont systemFontOfSize:14];
    UIView *shikichi =[[UILabel alloc] initWithFrame:CGRectMake(15, 132+24, 42, 21)];
    shikichi.backgroundColor =[UIColor colorWithRed:255/255.0 green:127/255.0 blue:88/255.0 alpha:1];
    [view addSubview:shikichi];
    UILabel *shikichilay =[[UILabel alloc]initWithFrame:CGRectMake(15,132+26 , 42, 21)];
    shikichilay.text=@"占用";
    shikichilay.font =[UIFont systemFontOfSize:14];
  
    [view addSubview:shitsu];
    [view addSubview:shikichilay];
    [view addSubview:self.setsumoji];
    
    
    
     [view addSubview:self.MaRu];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = 0.0f;
    
    if (self.selectedIndex == 0) {
        NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
        if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count != 0){
            NSInteger count = _imageArray.count + _uploadArr.count;
            CGFloat speace = 15.0f;
            CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
            int row;
            if (count %3 == 0) {
                row = count / 3;
            }
            else{
                row = count / 3 + 1;
            }
            return (speace + imageWidth) * row + 90;
        }
        else if (indexPath.row == _mainLayoutArray.count + 1 && _uploadArr.count == 0 && [self isUnCommint]){
            NSInteger count = _imageArray.count + _uploadArr.count;
            CGFloat speace = 15.0f;
            CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
            int row = count / 3 + 1;
            return (speace + imageWidth) * row + 10;
        }
        //        else if (indexPath.row > _mainLayoutArray.count - 3 && indexPath.row < _mainLayoutArray.count + 1){
        //            LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row - 1];
        //            rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
        //        }
        else if (indexPath.row < _mainLayoutArray.count){
            LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
            rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
        }
        else if(_mainLayoutArray.count == indexPath.row && _costLayoutArray.count != 0 )
            rowHeight = 80;
        else
            rowHeight = 0;
    }
    else if (self.selectedIndex==3)
    {
        rowHeight=SCREEN_HEIGHT;
    }
    else
    {
        rowHeight = 90.0f;
    }
    
    return rowHeight;
    
}
-(NSString *)filterHTML:(NSString *)str
{
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        str  =  [str  stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == 2) {
        NSMutableDictionary *dict = [_pathFlow objectAtIndex:indexPath.row];
        [CTToastTipView showTipText:[dict objectForKey:@"approveuser"]];
    }
}

#pragma mark - Custom Methods

// 是否显示提交按钮
- (void)addCommintBtn{
    
    
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    if (self.billType == 0 && ([[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] ||[[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"])) {
        
        _commintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commintBtn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [_commintBtn setTitle:@"提 交" forState:UIControlStateNormal];
        [_commintBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_commintBtn addTarget:self action:@selector(commintInfo) forControlEvents:UIControlEventTouchUpInside];
        [_commintBtn setFrame:CGRectMake(10, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:_commintBtn];
        
        _deleateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleateButton setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [_deleateButton setTitle:@"删 除" forState:UIControlStateNormal];
        [_deleateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_deleateButton addTarget:self action:@selector(deleateOrder) forControlEvents:UIControlEventTouchUpInside];
        [_deleateButton setFrame:CGRectMake(10, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:_deleateButton];
        
        _uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadButton setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [_uploadButton setTitle:@"上 传" forState:UIControlStateNormal];
        [_uploadButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_uploadButton addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
        [_uploadButton setFrame:CGRectMake(10, SCREEN_HEIGHT - 120, SCREEN_WIDTH - 20, 30)];
        [self.view addSubview:_uploadButton];

        self.tableViewBottomConstraint.constant = 135.0f;
        lastConstant = 135.0f;
       
    }
   
        
    if (self.billType==0&&[[mainDataDic objectForKey:@"flowstatus_show"]isEqualToString:@"已提交"]) {
        
        
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10, SCREEN_HEIGHT-60, SCREEN_WIDTH-20, 40)];
        
        
        [btn setTitle:@"回 收" forState:UIControlStateNormal];
        //设置边框为圆角
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:10];
        
        [btn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
        [btn addTarget:self action:@selector(aller) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:btn];
        self.tableViewBottomConstraint.constant = 50.0f;
        lastConstant = 50.0f;
        
    }
   
    
}
-(void)aller
{
    NSString *tuiHui =[NSString stringWithFormat:@"ac=Recover&u=%@&programid=%@&billid=%@",self.uid,self.programeId,self.billid];
    NSLog(@"??????%@,???%@,%@",self.uid,self.programeId,self.billid);
    
    [RequestCenter GetRequest:tuiHui parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSString *msg =[responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            [SVProgressHUD showInfoWithStatus:@"退回成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.reloadData) {
                self.reloadData();
                
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"退回失败，请稍后尝试"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }
            showLoadingStatus:YES];
    
}
-(void)danju
{
    self.actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"生成借款",@"生成报销", nil];
    self.actionsheet.tag=3;
    
    
    
    [self.actionsheet showInView:self.view];
    
}
-(void)buttontap
{
    BianJiViewController *bian = [[BianJiViewController alloc] init];
    bian.billid=self.billid;
    bian.programeId=self.programeId;
    bian.flowid=self.flowid;
    bian.bills=self.bills;
    bian.reloadData = ^(){
        [self.tableView.header beginRefreshing];
        
        
    };
    [self.navigationController pushViewController:bian animated:YES];
    
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



/**
 *  重置footerView Type
 *
 *  @param type type 0:现实输入框 1： 不显示输入框
 */
- (void)resizeFootViewFrame:(NSInteger)type{
    if (type == 0) {
        textFiledHeight = 30;
        // UIView *view = [self.view viewWithTag:1024];
        self.tableViewBottomConstraint.constant = 60 + textFiledHeight;
        self.beizhuText.frame = CGRectMake(10, 10, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 45 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }
    else
    {
        textFiledHeight = 0;
        // UIView *view = [self.view viewWithTag:1024];
        self.tableViewBottomConstraint.constant = 50 + textFiledHeight;
        self.beizhuText.frame = CGRectMake(10, 0, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 10 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }
    
    lastConstant = self.tableViewBottomConstraint.constant;
}

- (void)backVC{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.reloadData) {
        self.reloadData();
    }
    
}

- (CGFloat )fixStr:(NSString *)str{
    CGRect frame = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 115, 99999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return  frame.size.height >=0 ? frame.size.height : 20;
}

- (void)addItems:(UIView *)view{
    
    for (UIView *subView in bgView.subviews) {
        [subView removeFromSuperview];
    }
    
    //    CGFloat width = CGRectGetWidth(view.frame);
    //    CGFloat itemWidth = (width - 4)/3;
    //    int rows = _uploadArr.count / 3 + 1;
    //    [view setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, itemWidth * 0.75 * rows)];
    //    for (int i = 0; i < _uploadArr.count; i++) {
    //        int colum = i %3;
    //        int row = i/3;
    //        NSString *url = [_uploadArr safeObjectAtIndex:i];
    //        UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom];
    //
    //        [itemView setFrame:CGRectMake(colum*(itemWidth + 2), row * (itemWidth * 0.75 + 2), itemWidth, itemWidth * 0.75)];
    //        itemView.tag = i;
    //        itemView.userInteractionEnabled  = YES;
    //        }
    //        [itemView addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
    //        [view addSubview:itemView];
    //    }
    if (_uploadArr.count != 0 || _imageArray.count != 0) {
        NSInteger count = _uploadArr.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        
        for (int i = 0; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            NSString *url = [_uploadArr safeObjectAtIndex:i];
            if ([self fileType:url] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
            }
            btn.tag = 1024+ i;
            [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:btn];
            if ([self isUnCommint]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                deleteBtn.tag = 1024+ i;
                [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:deleteBtn];
            }
            
        }
        count += _imageArray.count;
        for (int i = _uploadArr.count; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imageArray safeObjectAtIndex:i - _uploadArr.count] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showSelectImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2024+ i;
            [bgView addSubview:btn];
            
            if ([self isUnCommint]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
                [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                deleteBtn.tag = 1024+ i;
                [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
                [btn addSubview:deleteBtn];
            }
        }
        int btnCloum = count %3;
        int btnRow = count / 3;
        view.backgroundColor = [UIColor clearColor];
        //NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
        if ([self isUnCommint]) {
            UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * btnCloum, speace + (speace + imageWidth) * btnRow, imageWidth, imageWidth)];
            [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImage addTarget:self action:@selector(showPickImageVC) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:addImage];
        }
    }
    else{
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 - 4*speace) / 3.0f;
        if ([self isUnCommint]) {
            UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * 0, speace + (speace + imageWidth) * 0, imageWidth, imageWidth)];
            [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [addImage addTarget:self action:@selector(showPickImageVC) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:addImage];
        }
        
    }
    
}

#pragma mark - CustomMethods

- (void)deleteImage:(UIButton *)btn{
    
    if (btn.tag >=1024 && btn.tag < 2024) {
        NSString *url = [_uploadArr safeObjectAtIndex:btn.tag - 1024];
        
        NSString *imgid = [[url componentsSeparatedByString:@"?"] lastObject];
        
        
        if (delteImageID.length == 0) {
            delteImageID = [NSString stringWithFormat:@"%@",imgid];
        }
        else{
            delteImageID = [NSString stringWithFormat:@"%@,%@",delteImageID,imgid];
        }
        [_uploadArr removeObject:url];
    }
    else{
        [_imageArray removeObjectAtIndex:btn.tag - 2024];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
}

- (void)showPickImageVC{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self.actionsheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
    self.actionsheet.tag=2;
    [self.actionsheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionsheet.tag==2) {
        if (buttonIndex == 0) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        if (buttonIndex == 1)
        {
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
    }
    if (self.actionsheet.tag==3) {
        if (buttonIndex==0) {
            NSLog(@"<<<<<<<<<<<<<<<<<<<<<<");
            
        }
        if (buttonIndex==1) {
            NSLog(@"111111111111111");
            
        }
    }
    
}

- (void)uploadClick:(UIButton *)btn{
    [self uploadImage:0];
}

- (void)uploadImage:(NSInteger)index{
    NSString *fbyte = @"";  //图片bate64
    
    fbyte = [self bate64ForImage:[_imageArray safeObjectAtIndex:index]];
    NSLog(@"bate64 : %@",fbyte);
    NSString *str = [NSString stringWithFormat:@"%@?ac=UploadMoreFile64&u=%@&EX=%@&FName=%@&programid=%@&billid=%@",Web_Domain,self.uid,@".jpg",@"image",self.programeId,self.billid];
    if (delteImageID.length != 0) {
        str = [NSString stringWithFormat:@"%@&delpicid=%@",str,delteImageID];
    }
    NSLog(@"str : %@",str);
    [SVProgressHUD showWithMaskType:2];
    [[AFHTTPRequestOperationManager manager] POST:str
                                       parameters:_imageArray.count != 0? @{@"FByte":fbyte} : nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              //                                              if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                                              [SVProgressHUD dismiss];
                                              if (index + 1 < _imageArray.count) {
                                                  [self uploadImage:index + 1];
                                              }
                                              if (index + 1 == _imageArray.count - 1) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  if (self.reloadData) {
                                                      self.reloadData();
                                                  }
                                              }
                                              if (_imageArray.count == 0 && delteImageID.length != 0) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  if (self.reloadData) {
                                                      self.reloadData();
                                                  }
                                              }
                                              //                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
    
}

- (NSString *)bate64ForImage:(UIImage *)image{
    UIImage *_originImage = image;
    NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodedImageStr;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageWithData:[originalImage thumbImage:originalImage]];
    image = [image fixOrientation:image];
    [_imageArray addObject:image];
    [self.tableView reloadData];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set aspectRatioThumbnail]];
        [_imageArray addObject:image];
    }
    [self.tableView reloadData];
    NSLog(@"class :%@",[class class]);
}

- (void)showSelectImage:(UIButton *)btn{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = nil;
    
    browser.imageCount = _imageArray.count;
    
    browser.currentImageIndex = btn.tag - 2024 - _uploadArr.count;
    
    browser.delegate = self;
    browser.tag = 11;
    [browser show]; // 展示图片浏览器
}


- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
    if (browser.tag == 11) {
        return _imageArray[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_uploadArr objectAtIndex:index]);
        
        NSString *model = [_uploadArr objectAtIndex:index];
        
        return [NSURL URLWithString:model];
    }
    else
        return nil;
    
}

- (NSInteger)fileType:(NSString *)fileName{
    NSArray *suffix = [fileName componentsSeparatedByString:@"."];
    NSString *type = [suffix lastObject];
    NSRange range = [type rangeOfString:@"png"];
    NSRange range1 = [type rangeOfString:@"jpg"];
    
    if (range.length >0 || range1.length > 0) {
        return 0;
    }
    else
        return 1;
}

- (void)showImage:(UIButton *)btn{
    NSString *url = [_uploadArr safeObjectAtIndex:btn.tag - 1024];
    if ([self fileType:url] == 1) {
        [[RequestCenter defaultCenter] downloadOfficeFile:url
                                                  success:^(NSString *filename) {
                                                      QLPreviewController *previewVC = [[QLPreviewController alloc] init];
                                                      previewVC.dataSource = self;
                                                      [self presentViewController:previewVC animated:YES completion:^{
                                                          
                                                      }];
                                                  }
                                                  fauiler:^(NSError *error) {
                                                      
                                                  }];
        
        
    }
    
    else {
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.tag = 10;
        browser.sourceImagesContainerView = nil;
        
        browser.imageCount = _uploadArr.count;
        
        browser.currentImageIndex = btn.tag - 1024;
        
        browser.delegate = self;
        
        [browser show]; // 展示图片浏览器
    }
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:[[RequestCenter defaultCenter] filePath]];
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
        //        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]]
        //                                 forState:UIControlStateNormal
        //                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //         }];
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
        
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
    vc.selecter=_selectedion2;
    vc.index = btn.tag;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
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

#pragma mark - Navigation

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
    else if ([segue.identifier isEqualToString:@"pushMsgVC"]){
        
        SendMsgViewController *send = (SendMsgViewController *)segue.destinationViewController;
        send.model = self.unModel;
        send.msgType = SendMessageTableType;
    }
}

//wo上传后台转借款或报销
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----饼状图代理
-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
  
    return _Criclearray.count;;
    
}
-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    
    
      return  [[_Criclearray objectAtIndex:index] intValue];
    
    //    else
    //    {
    //        a = [[_twoCsarry objectAtIndex:index] intValue];
    //    }
    
}
-(UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //颜色分配
    //    if (pieChart ==self.cirleview) return nil;
    //    if (pieChart == self.twoCircle) {
    //        return [self.Criclecolour objectAtIndex:(index%self.Criclecolour.count)];
    //    }else
    //    {
    //    return [self.Criclecolour objectAtIndex:(index%self.Criclecolour.count)];
    //
    
    //    }
    
    
    return [self.Criclecolour objectAtIndex:(index%self.Criclecolour.count)];
    
}
-(void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
 
    
    NSLog(@";");
    
}
#pragma mark-----柱状图
-(NSUInteger)numberOfBarsInBarChart:(SimpleBarChart *)barChart
{
    return self.values.count;
}
-(CGFloat)barChart:(SimpleBarChart *)barChart valueForBarAtIndex:(NSUInteger)index
{
    
    return [[self.values objectAtIndex:index]floatValue] ;
    
}
-(NSString *)barChart:(SimpleBarChart *)barChart textForBarAtIndex:(NSUInteger)index
{
    if (index%4==3) {
        barChart.barTextColor = [UIColor clearColor];
        
    }
//        else{
//        barChart.barTextColor =[UIColor blackColor];
//    }
    
    return [[self.values objectAtIndex:index] stringValue];
    
}
-(NSString *)barChart:(SimpleBarChart *)barChart xLabelForBarAtIndex:(NSUInteger)index
{
    return [_monji objectAtIndex:index];
}
-(UIColor *)barChart:(SimpleBarChart *)barChart colorForBarAtIndex:(NSUInteger)index
{
    if (index%4 == 0) {
        index = 0;
        
        self.chart.barWidth=27;
        
    }
    if (index%4 ==1) {
        index=1;
       
    }
    if (index%4==2) {
        index=2;
       
    }
    if (index%4==3) {
        index=1;
      // barChart.barTextColor =[UIColor clearColor];
        self.chart.barWidth=0;
    }
    
    
    
    
  
    return [self.haikei objectAtIndex:index];
    
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
