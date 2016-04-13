//
//  BianJiViewController.m
//  Thinkape-iOS
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import "BianJiViewController.h"
#import "BillsDetailViewController.h"
#import "LayoutModel.h"
#import "CostLayoutModel.h"

#import "CostDetailViewController.h"
#import "HistoryModel.h"

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
#import "HomeViewController.h"
#import "BianjiTableViewCell.h"
#import "KindsItemsView.h"
#import "KindsModel.h"
#import "KindsLayoutModel.h"
#import "KindsPickerView.h"
#import "KindsItemModel.h"
#import "DatePickerView.h"
#import "Bianjito.h"
#import "AppDelegate.h"
#import "MiXimodel.h"
#import "BillsListViewController.h"
#import "IQKeyboardManager.h"
#import "ShenPI.h"
#import "AppDelegate.h"
#import "StayApprovalViewController.h"
@interface BianJiViewController ()<UITableViewDataSource,UITableViewDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UIActionSheetDelegate,KindsItemsViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic) NSMutableArray *mainLayoutArray; // 主表 布局视图

@property (strong,nonatomic) NSMutableArray *costLayoutArray2;

@property (strong,nonatomic) NSMutableArray *pathFlow; // 审批流程
@property (nonatomic,strong) NSMutableArray *mainData;

@property (nonatomic,strong) NSMutableArray *uploadArr;
@property (strong, nonatomic) NSMutableArray *layoutArray;
@property (nonatomic,strong) UITextField *beizhuText;
@property(nonatomic,strong)UIActionSheet *actionshoot;
@property(nonatomic,strong)NSString *stringto;
@property (strong, nonatomic) NSMutableDictionary *tableViewDic;
@property (nonatomic , strong) NSMutableArray *imageArray;
@property (strong, nonatomic) NSString *newflag;
//试验用
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;

@property(nonatomic,strong)DatePickerView *datePickerView;
@property(nonatomic,strong)NSMutableDictionary *XMLParameterDic;
@property(nonatomic,strong)UITextField *textfield;

@property(nonatomic,strong)NSMutableArray *arrytext;

@property(nonatomic,copy)NSString *str;
@property(nonatomic,strong)NSMutableArray *dataArry;
//删除的grad
@property(nonatomic,copy) NSString *delete;
@property(nonatomic,strong)NSMutableDictionary *deledict;

@property(nonatomic,strong)NSMutableDictionary *dictArray;
@property(nonatomic,strong)CostLayoutModel *coster;
@property(nonatomic,strong)NSMutableString *valueStr;

@end

@implementation BianJiViewController

{
    NSString *delteImageID;
    UIView *bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    BOOL isSinglal;
    BOOL commintBills;
    NSString *sspid;
    //键盘
    CGFloat Textfield_y;
    CGFloat distances;
    BOOL _wasKeyboardManagerEnabled;
}



- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.type = 0;
        commintBills = NO;
    }
    return self;
}
//键盘弹出第三方
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self costScrollView];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedion=1;
    self.isaddMoney = NO;
    self.isTransform = NO;
    
    Textfield_y=0;
    distances =0;
    
    UIButton *iconb =[[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [iconb setBackgroundImage:[UIImage imageNamed:@"back3.png"] forState:UIControlStateNormal];
    [iconb addTarget:self action:@selector(pulltoreturn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back =[[UIBarButtonItem alloc] initWithCustomView:iconb];
    self.navigationItem.leftBarButtonItem=back;
    
    self.title=@"编辑详情";
    
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    _mainLayoutArray = [[NSMutableArray alloc] init];
    _costLayoutArray2 = [[NSMutableArray alloc] init];
    _mainData = [[NSMutableArray alloc] init];
    _costData2 = [[NSMutableArray alloc] init];
    _pathFlow = [[NSMutableArray alloc] init];
    _selectModel=[[KindsModel alloc] init];
    _arrytext=[NSMutableArray array];
     //存右边栏数据的字典
    self.tableViewDic=[[NSMutableDictionary alloc]init];
    self.XMLParameterDic=[[NSMutableDictionary alloc]init];
    
    NSLog(@"self.tableViewDic:%@",[self.tableViewDic class]);
    
    
    self.textfield=[[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2,0,SCREEN_WIDTH-50,40)];
    
    if (self.kindsPickerView) {
        self.kindsPickerView = [[[NSBundle mainBundle] loadNibNamed:@"KindsPickerView" owner:self options:nil] lastObject];
        [self.kindsPickerView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
       
        __block BianJiViewController *weakSelf = self;
        self.kindsPickerView.selectItemCallBack = ^(KindsModel *model){
            
            weakSelf.selectModel = model;
            
        };
        [self.view addSubview:self.kindsPickerView];
    }
    
    [self requestDataSource];
    textFiledHeight=0;
    
    [self addFooterView];
    
    self.dictarry =[NSMutableDictionary dictionary];
     //保存删除字表id
    self.deledict =[NSMutableDictionary dictionary];
  //键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShows:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidens:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor =[UIColor clearColor];
    self.view.window.backgroundColor =[UIColor clearColor];
    
    
}
//键盘弹出
- (void)keyboardShows:(NSNotification *)notification{

    
    self.view.window.backgroundColor = self.tableview.backgroundColor;
        // 0.取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y-(self.tableview.frame.size.height-infoView.frame.size.height-30);
    //不能超过键盘的高度
    if (transformY >-200) {
        transformY=-200;
        
    }
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
        //self.tableview.transform= self.view.transform;
    }];
}
- (void)keyboardHidens:(NSNotification *)notification{
    Textfield_y= 0;
    
  self.view.frame = CGRectMake(0, 0, self.tableview.frame.size.width, self.tableview.frame.size.height);
}
//返回隐藏键盘
-(void)pulltoreturn
{
    [self.textfield resignFirstResponder];
   
    BillsListViewController *bi =[self.storyboard instantiateViewControllerWithIdentifier:@"BillsListView"];
    
    NSArray *temArray =self.navigationController.viewControllers;
    
    
    for (UIViewController *ter in temArray) {
       
        if ([ter isKindOfClass:[BillsListViewController class]]) {
            
            
                        [self.navigationController popToViewController:ter animated:YES];
           
        }
        if ([ter isKindOfClass:[StayApprovalViewController class]]) {
            [self.navigationController popToViewController:ter animated:YES];
            
        }
    
    }
    
}
- (void)requestDataSource{
    
    //ac=GetEditData&u=9&programid=130102&billid=28
    
    NSString * str=[NSString stringWithFormat:@"ac=EditData&u=%@&programid=%@&billid=%@",self.uid ,self.programeId,self.billid];
    NSLog(@"数据错误str:%@%@",Web_Domain,str);
    NSLog(@"数据请求%@-----------",str);
    [RequestCenter GetRequest:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          NSDictionary * mainLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"main"];
                          NSArray * costLayout = [[[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"] objectForKey:@"details"];
                          
                          LayoutModel *l = [LayoutModel objectArrayWithKeyValuesArray:[mainLayout objectForKey:@"fields"]];
                          
                          //tableView的数据源：
                          [_mainLayoutArray addObjectsFromArray:l];
                          
                          //10:币种   11：汇率
                          [_mainLayoutArray removeObjectAtIndex:10];
                          [_mainLayoutArray removeObjectAtIndex:10];
                         
                          
                          [_costLayoutArray2 addObjectsFromArray:[CostLayoutModel objectArrayWithKeyValuesArray:costLayout]];
                          for (int i=0; i<_costLayoutArray2.count; i++) {
                              CostLayoutModel *model =[_costLayoutArray2 safeObjectAtIndex:i];
                              
                              [self.deledict setObject:[NSString stringWithFormat:@":%@:%@:%@",model.SqlTableName,model.PrimaryKey,model.RelationKey] forKey:model.gridmainid];
                          }
                          
                          NSMutableArray *dataArr = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          NSLog(@"dataArr.count:%lu",dataArr.count);
                          _mainData =[dataArr safeObjectAtIndex:0];
                          NSMutableDictionary *dict = [dataArr safeObjectAtIndex:0][0];
                          NSLog(@"数组里的值:%@",_mainData);
                          
                          self.str=[dict objectForKey:@"ver"];
                          NSLog(@"ver====%@",str);
                          
                          
                          
                          self.tableViewDic=[NSMutableDictionary  dictionaryWithDictionary:_mainData[0]];
                          self.XMLParameterDic =[NSMutableDictionary dictionaryWithDictionary:_mainData[0]];
                          
                          
                          
                          NSLog(@"self.tableViewDic:%@",[self.tableViewDic class]);
                        
            
                          
                          [_costData2 addObjectsFromArray:[dataArr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _costLayoutArray2.count)]]];
                          
                          _uploadArr = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"msg"] objectForKey:@"upload"]];
                          
                         [self.tableview reloadData];
                          [SVProgressHUD dismiss];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (_uploadArr==nil) {
                              UIImageView *image =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ab_nav_bg.png"]];
                              
                              
                              
                              
                              [_uploadArr addObject:image];
                              
                          }
                          
                      }];
    
}
- (void)requestFlowPath{
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetFlowPath&u=%@&ukey=%@&ProgramID=%@&Billid=%@",self.uid,self.ukey,self.programeId,self.billid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          //                          _pathFlow = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          _pathFlow =[responseObject objectForKey:@"msg"];
                          _pathFlow = [responseObject objectForKey:@"data"];
                          
                          [SVProgressHUD dismiss];
                          [self.tableview reloadData];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
}

#pragma mark-UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger number = 0;
    
    if (_mainLayoutArray.count == 0) {
        
        number = 0;
        
        
        
    }
    else if (_uploadArr.count == 0){
        
        
        
        number = _mainLayoutArray.count + 1;
        
        if ([self isUnCommint]) {
            number = _mainLayoutArray.count + 2;
            
        }
        
    }
    else
        
      
    number = _mainLayoutArray.count + 2;

    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    BianjiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textfield.placeholder = @"";
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BianjiTableViewCell" owner:self options:nil] lastObject];
        
    }
    UIView *subView = [cell.contentView viewWithTag:203];
    UIView *subView1 = [cell.contentView viewWithTag:204];
    [subView removeFromSuperview];
    [subView1 removeFromSuperview];
    
 
    
    if (indexPath.row < _mainLayoutArray.count) {
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
        
        
        cell.leftlabel.text = [NSString stringWithFormat:@"%@:",model.name];
        NSString *value = [self.tableViewDic objectForKey:model.fieldname];
        value = value.length>0?value:@"";
        
        cell.textfield.text= value;
       

        if (model.ismust==1&& indexPath.row!= _mainLayoutArray.count&&indexPath.row!=_mainLayoutArray.count+2) {
            cell.textfield.placeholder=@"不能为空";
        }
        

        
        
        if([model.name containsString:@"<"]){
            cell.leftlabel.text=[self filterHTML:[NSString stringWithFormat:@"%@",model.name]];
            cell.textfield.placeholder=@"";
        }
        
       
        
        
        cell.textfield.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
        
        [_arrytext addObject:cell.textfield.text];
        
        
        cell.textfield.delegate=self;
        cell.textfield.tag=indexPath.row;
        cell.textfield.frame=CGRectMake((SCREEN_WIDTH-150)/2,0,SCREEN_WIDTH-50,40);
        if ([model.name isEqualToString:@"billscount"]) {
            cell.textfield.textColor = [UIColor grayColor];
            cell.textfield.keyboardType= UIKeyboardTypeDecimalPad;
            
        }
        if ([model.fieldname isEqualToString:@"memo"]) {
            
            cell.textfield.placeholder=@"";
            
        }
        if ([model.isreadonly isEqualToString:@"0"]) {
            cell.textfield.textColor = [UIColor blackColor];
            cell.textfield.enabled=YES;
            
        }else
        {   cell.textfield.textColor=[UIColor grayColor];
            
            cell.textfield.enabled=NO;
        }
        
        if ([model.fieldname isEqualToString:@"totalmoney"]) {
            
            cell.leftlabel.textColor=[UIColor hex:@"f23f4e"];
           
            
        }
        
        else
            cell.leftlabel.textColor = [UIColor hex:@"333333"];
        
    }
    
    if (indexPath.row == _mainLayoutArray.count) {
        
        cell.leftlabel.text =nil;
       
        cell.textfield.text=nil;
        cell.textfield.placeholder= nil;
        
        [cell.contentView addSubview:[self costScrollView]];
    }
    
    

    else if (indexPath.row == _mainLayoutArray.count + 1){
        cell.leftlabel.text =nil;
        cell.textfield.text=nil;
        cell.textfield.enabled=NO;
        cell.textfield.placeholder=nil;
        
        if (!bgView) {
            bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 0.75)];
            bgView.tag = 204;
        }
       
        
        NSInteger count = _imageArray.count + _uploadArr.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 36 -4*speace) / 3.0f;
        int row = count / 3 + 1;
        
        [bgView setFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, (speace + imageWidth) * row)];
        [bgView removeFromSuperview];
        [self addItems:bgView];
        
        
        [cell.contentView addSubview:bgView];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat rowHeight = 0.0f;
    
  
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
        return (speace + imageWidth) * row + 50;
    }
    
    else if (indexPath.row < _mainLayoutArray.count){
        LayoutModel *model = [_mainLayoutArray safeObjectAtIndex:indexPath.row];
        rowHeight = [self fixStr:[mainDataDic objectForKey:model.fieldname]] + 20;
        
        rowHeight= self.textfield.frame.size.height+15;
    
    }
    else if(_mainLayoutArray.count == indexPath.row && _costLayoutArray2.count != 0 )
        rowHeight = 80;
    else
    {
        rowHeight=90;
    }

    return rowHeight;
    
}


#pragma mark-KindsItemsViewDelegate点击弹出框传值过来

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    
       NSInteger tag = view.tag;
    LayoutModel *layoutModel = [self.mainLayoutArray safeObjectAtIndex:self.textfield.tag];
    [self.tableViewDic setObject:name forKey:layoutModel.fieldname];
    [self.XMLParameterDic setObject:ID forKey:[NSString stringWithFormat:@"%@%@",layoutModel.fieldname,@"_id"]];
    NSLog(@"值键%@=%@",layoutModel.fieldname,layoutModel.name);
    
  
    
    [view closed];
    
    [self.tableview reloadData];
}
- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
    NSLog(@"ssssssssssss%ld",(long)tag);
    
    LayoutModel *layoutModel = [self.mainLayoutArray safeObjectAtIndex:tag];
    int i = 0;
    for (KindsItemModel *model in arr) {
        if (i == 0) {
            idStr = [NSString stringWithFormat:@"%@",model.ID];
            nameStr = [NSString stringWithFormat:@"%@",model.name];
        }
        else{
            idStr = [NSString stringWithFormat:@"%@,%@",idStr,model.ID];
            nameStr = [NSString stringWithFormat:@"%@,%@",nameStr,model.name];
        }
        i++;
        [self.XMLParameterDic setObject:idStr forKey:layoutModel.fieldname];
        [self.XMLParameterDic setObject:nameStr forKey:layoutModel.fieldname];

     
        
    }
    
    
    
   
    
    [self.tableview reloadData];
}

#pragma mark-UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
   
    
    
    self.textfield=textField;
   
    self.textfield.tag=textField.tag;
    LayoutModel *model = [self.mainLayoutArray safeObjectAtIndex:textField.tag];
    
    NSLog(@"tag值：%ld",textField.tag);
  
   
    
    NSIndexPath *path =[self.tableview indexPathForSelectedRow];
    NSLog(@"path值：%@",path);
    
    if (![model.datasource isEqualToString:@"0"]&&![model.sqldatatype isEqualToString:@"date"]) {
    
        isSinglal =model.issingle;
        
        [self removeViewFromSuperview];
        
        [self kindsDataSource:model];
        
        return NO;
    }else
        if ([model.sqldatatype isEqualToString:@"date"]){
            
            
         
            
            [self removeViewFromSuperview];
            
            [self addDatePickerView:textField.tag date:textField.text];
            
            [self.tableViewDic setObject:textField.text forKey:model.fieldname];
            [self.XMLParameterDic setObject:textField.text forKey:model.fieldname];
            
            return NO;
        }
        else
            
            [self removeViewFromSuperview];
            return YES;
    
    
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
   

    return YES;
}


//调用方法避免选择框重叠
- (void)removeViewFromSuperview
{
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[KindsItemsView class]]) {
            [view removeFromSuperview];
        }else if ([view isKindOfClass:[DatePickerView class]]){
            [view removeFromSuperview];
        }
    }
}




//wo
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
   
    LayoutModel *model = [self.mainLayoutArray safeObjectAtIndex:textField.tag];
    
    if (![self isPureInt:textField.text] && [model.sqldatatype isEqualToString:@"number"] && textField.text.length != 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入数字"];
        textField.text = @"";
    }
    
    if ([textField.text length]>0) {
        unichar single = [textField.text characterAtIndex:0];
        if ((single>='0'&&single<='9')||single=='.') {
            //            if ([textField.text length]==0) {
            if (single=='.') {
                [SVProgressHUD showInfoWithStatus:@"开头不能是小数点点"];
                textField.text=@"";
                
            }
            
           
        }

    }
    
    [self.XMLParameterDic setObject:textField.text forKey:model.fieldname];
    [self.tableViewDic setObject:textField.text forKey:model.fieldname];
     self.view.frame = CGRectMake(0, 0, self.tableview.frame.size.width, self.tableview.frame.size.height);
       return YES;
    
}


- (void)kindsDataSource:(LayoutModel *)model{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.mainLayoutArray indexOfObject:model];
    //包含9999，containsString
    if (model.datasource.length !=0) {
        NSString *oldDataVer = [[CoreDataManager shareManager] searchDataVer:str1];
        if ([oldDataVer isEqualToString:model.dataver>0 ?model.dataver:@"0.01"]&&oldDataVer.length>0) {
            NSString *str = [NSString stringWithFormat:@"datasource like %@ ",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
            [SVProgressHUD showWithStatus:nil maskType:2];
            
            [self fetchItemsData:str callbakc:^(NSArray *arr) {
                if (arr.count ==0) {
                    [[CoreDataManager shareManager]updateModelForTable:@"KindsLayout" sql:str data:[NSDictionary dictionaryWithObjectsAndKeys:model.dataver.length >0 ? model.dataver:@"0.01",@"dataVer", nil]];
                    [self requestKindsDataSource:model dataVer:model.dataver];
                    
                }
                else
                {
                    [SVProgressHUD dismiss];
                    [self initItemView:arr tag:tag];
                    
                }
            }];
        }
        else
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.dataver.length > 0 ? model.dataver : @"0.01",@"dataVer", nil];
            [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str1 data:dic];
            [self requestKindsDataSource:model dataVer:model.dataver];
            
        }
        
    }
}


- (void)requestKindsDataSource:(LayoutModel *)model dataVer:(NSString *)Dataver{

    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    NSInteger tag= [self.mainLayoutArray indexOfObject:model];
    if ([model.datasource containsString:@"_code"]) {
        
        model.datasource =  [model.datasource stringByReplacingOccurrencesOfString:@"_code" withString:@""];
    }
    NSString *datesoure =[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource];
    [RequestCenter GetRequest:datesoure
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          id dataArr = [responseObject objectForKey:@"msg"];
                          if ([dataArr isKindOfClass:[NSArray class]]) {
                              [self saveItemsToDB:dataArr callbakc:^(NSArray *modelArr) {
                                  [self initItemView:modelArr tag:tag];
                                  
                                  [SVProgressHUD dismiss];
                              }];
                          }
                          else
                          {
                              [SVProgressHUD showInfoWithStatus:@"请求数据失败。"];
                              [SVProgressHUD dismiss];
                          }
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
}

- (void)fetchItemsData:(NSString *)sql callbakc:(void (^)(NSArray *arr))callBack{
    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr =[NSArray arrayWithArray:[[CoreDataManager shareManager] fetchDataForTable:@"KindItem" sql:sql]];
        for (NSManagedObject *obj in arr) {
            KindsItemModel *model = [[KindsItemModel alloc] init];
            model.name = [obj valueForKey:@"name"];
            model.code = [obj valueForKey:@"code"];
            model.datasource = [obj valueForKey:@"datasource"];
            model.ID = [obj valueForKey:@"id"];
            [modelArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(modelArr);
        });
    });
    
    
}

- (void)initItemView:(NSArray *)arr tag:(NSInteger)tag{
    KindsItemsView *itemView;
    itemView = [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
    itemView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    itemView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    itemView.delegate = self;
    itemView.isSingl=isSinglal;
    
    itemView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(itemView.frame) / 2.0f);
    itemView.dataArray = arr;
    
    itemView.tag = tag;
    [self.view addSubview:itemView];
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         itemView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)saveItemsToDB:(NSArray *)arr callbakc:(void (^)(NSArray *modelArr))callBack{
    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary *dic in arr) {
            KindsItemModel *itemModel = [KindsItemModel objectWithKeyValues:dic];
            [modelArr addObject:itemModel];
            NSString *str = [NSString stringWithFormat:@"datasource like %@ and id like %@",[NSString stringWithFormat:@"\"%@\"",itemModel.datasource],[NSString stringWithFormat:@"\"%@\"",itemModel.ID]];
            [[CoreDataManager shareManager] updateModelForTable:@"KindItem"
                                                            sql:str
                                                           data:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(modelArr);
        });
    });
    
}

- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
    self.datePickerView.tag = tag;
    NSLog(@"dddddddddddd%ld",(long)tag);
    
    __block BianJiViewController *weaker=self;
    self.datePickerView.selectDateBack = ^(NSString *date){
        
        NSInteger tag = weaker.datePickerView.tag;
        LayoutModel *layout =[weaker.mainLayoutArray safeObjectAtIndex:tag];
        
        NSLog(@"%@",date);
        [weaker.XMLParameterDic setObject:date forKey:layout.fieldname];
        
        [weaker.tableViewDic setObject:date forKey:layout.fieldname];
        
        [weaker.datePickerView closeView:nil];
        
        [weaker.tableview reloadData];
        
    };
    
    [self.view addSubview:self.datePickerView];
    NSLog(@"====================%@",self.textfield.text);
    
    
    
}
#pragma mark-本地化保存self.textfield.text



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)isUnCommint{
    NSDictionary *mainDataDic = [_mainData safeObjectAtIndex:0];
    return [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"未提交"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已弃审"] || [[mainDataDic objectForKey:@"flowstatus_show"] isEqualToString:@"已退回"];
}

- (void)resizeFootViewFrame:(NSInteger)type{
    if (type == 0) {
        textFiledHeight = 30;
       
        self.beizhuText.frame = CGRectMake(10, 10, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 45 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }
    else
    {
        textFiledHeight = 0;
       
        self.beizhuText.frame = CGRectMake(10, 0, CGRectGetWidth(infoView.frame) - 20, textFiledHeight);
        infoView.frame = CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight);
        CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 40) / 2.0f;
        [sureBtn setFrame:CGRectMake(10, 10 , btnWidth, 30)];
        [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    }
    
   
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
        [self.tableview reloadData];
    }
    [self.tableview reloadData];
}

- (void)showPickImageVC{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self.actionshoot = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
    self.actionshoot.tag=200;
    [self.actionshoot showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==200) {
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
       
        if (buttonIndex==0) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
           
        }
      
    }
}


//点击保存之后，上传图片调用：
- (void)uploadImage:(NSInteger)index

{
    NSString *fbyte = @"";  //图片bate64
    
    fbyte = [self bate64ForImage:[_imageArray safeObjectAtIndex:index]];
    NSLog(@"bate64 : %@",fbyte);
    NSString *str = [NSString stringWithFormat:@"%@?ac=UploadMoreFile64&u=%@&EX=%@&FName=%@&programid=%@&billid=%@",Web_Domain,self.uid,@".jpg",@"image",self.programeId,self.billid];
    
    
    
    str = [NSString stringWithFormat:@"%@&delpicid=%@",str,delteImageID];
    
    NSLog(@"图片的地址str : %@",str);
    
    

    
    
    [[AFHTTPRequestOperationManager manager] POST:str
                                       parameters:_imageArray.count != 0? @{@"FByte":fbyte} : nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self.tableview reloadData];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set aspectRatioThumbnail]];
        [_imageArray addObject:image];
    }
    [self.tableview reloadData];
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
//金额数字
- (UIScrollView *)costScrollView
{
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH - 36, 80)];
    scroll.tag = 203;
    [scroll setContentSize:CGSizeMake(95*_costLayoutArray2.count-35, 80)];
    scroll.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < _costLayoutArray2.count; i++) {
        CostLayoutModel *model = [_costLayoutArray2 safeObjectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(i*(60 + 35), 10, 57, 57)];
        [btn addTarget:self action:@selector(costDetails:) forControlEvents:UIControlEventTouchUpInside];
        btn.contentMode = UIViewContentModeScaleAspectFit;
     
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photopath]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        btn.tag = i;
        
        UILabel *totleMoney = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 57, 15)];
        totleMoney.textColor = [UIColor whiteColor];
        totleMoney.font = [UIFont systemFontOfSize:15];
        //金额数字
        totleMoney.text = model.TotalMoney;
        
        if (_isTransform == YES) {
            if (i == _changeIndex) {
                totleMoney.text = self.changeMoney;
                model.TotalMoney = self.changeMoney;
            }
        }
        //添加：
        if (self.isaddka == YES) {
            if (i == _addIndex) {
                
                totleMoney.text = [NSString stringWithFormat:@"%.2lld",[model.TotalMoney longLongValue] + [self.addMoney longLongValue]];
                model.TotalMoney = totleMoney.text;
            }
        }
        
        if (self.isdeletes == YES) {
            
            totleMoney.text = self.moneyArray[i];
            model.TotalMoney = totleMoney.text;
        }
        
    
        totleMoney.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:totleMoney];
        
        [scroll addSubview:btn];
    }
    
    
    
    self.isTransform = NO;
    self.isaddka = NO;
    self.isdeletes = NO;
    
    return scroll;
}
//

-(void)costDetails:(UIButton *)btn
{
   
    [self.textfield resignFirstResponder];
    Bianjito *vc = [[Bianjito alloc] init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //cell的行数
    NSInteger indx = app.indexcor;
    //页数
    NSInteger indexpate = app.indexpage;
    vc.costLayoutArray = _costLayoutArray2;
    vc.index=btn.tag;
    
    vc.costDataArr = _costData2;
    
    vc.dilct = self.dictarry;
    
    
    //拿到一开始的值

    CostLayoutModel *model = [_costLayoutArray2 safeObjectAtIndex:btn.tag];
    
    vc.oldMoney = model.TotalMoney;
    
    [self.navigationController pushViewController:vc animated:YES];

    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
   
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



- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark---单据报错提示

- (NSString *)XMLParameter
{
    NSMutableString *xmlStr = [NSMutableString string];
    
    int i = 0;
    for (LayoutModel *layoutModel in _mainLayoutArray) {
        NSString *value = [self.XMLParameterDic objectForKey:layoutModel.fieldname];
      
        //id 值
        NSString *str0 = [[NSString alloc]initWithString:layoutModel.fieldname];
        
        if ([layoutModel.fieldname containsString:@"_show"]) {
            
            str0 = [layoutModel.fieldname stringByReplacingOccurrencesOfString:@"_show" withString:@""];
            value = [self.XMLParameterDic objectForKey:[NSString stringWithFormat:@"%@%@",layoutModel.fieldname,@"_id"]];
        }else{
        
        }
        
        NSString *ids = [self.tableViewDic objectForKey:layoutModel.fieldname];
    
        if (layoutModel.ismust == 1 && ids.length == 0 && i != 0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.name]];
            return nil;
            NSLog(@"hhq");
        }else{
            
        }

        if (ids.length != 0) {
            
            if (![layoutModel.datasource isEqualToString:@"0"]&&![layoutModel.datasource isEqualToString:@""]) {
                if([layoutModel.datasource containsString:@"9999"]){
                    
                    [xmlStr appendFormat:@"%@=\"%@\" ",str0,ids];
                    
                }else{

                    [xmlStr appendFormat:@"%@=\"%@\" ",str0,value];
                    
                }
            }else{
                [xmlStr appendFormat:@"%@=\"%@\" ",str0,ids];
            }
        }
        i++;
    }
    NSString *returnStr = [NSString stringWithFormat:@"<?xml version= \"1.0\" encoding=\"gb2312\"?><Root><Main %@ currentprogramid=\"%@\"></Main>",xmlStr,self.programeId];
    NSLog(@"xmlStr : %@",returnStr);
    return returnStr;
        
}
-(NSString *)xmlser
{
    
  
    NSMutableString *string =[NSMutableString string];
    [string appendFormat:@"%@",@"<Detail>"];
    for (int i=0;i<_costLayoutArray2.count;i++) {
        CostLayoutModel *model =[_costLayoutArray2 objectAtIndex:i];
        NSString *groundmain =model.gridmainid;
        NSMutableArray *fieldarray =model.fileds;
        NSMutableArray *array =[_costData2 objectAtIndex:i];
        for (int c= 0; c<array.count; c++) {
            
            [string appendFormat:@"<grid%@ ",groundmain];
            
            NSMutableDictionary *dict =[array objectAtIndex:c];
            NSString *bildetal =[dict objectForKey:@"billdetailid"];
            //增加
            if (bildetal==nil||[bildetal isEqualToString:@""]) {
                [string appendFormat:@"_state=\"%@\" billdetailid=\"0\" ",@"added"];
            }else
            {
                //修改
                [string appendFormat:@"_state=\"%@\" billdetailid=\"%@\" ",@"modified",bildetal];
            }
            //删除
           
            NSLog(@"=======%@",[dict objectForKey:@"billmoney"]);
            
            
            for (MiXimodel *mixi in fieldarray) {
                NSString *fielname =mixi.fieldname;
                
                NSString *value =[dict objectForKey:[NSString stringWithFormat:@"%@",mixi.fieldname]];
                if (![mixi.datasource isEqualToString:@"0"]&&![mixi.datasource containsString:@"9999"]) {
                    value = [dict objectForKey:[NSString stringWithFormat:@"%@%@",fielname,@"_id"]];
                }
                
                if (value==nil||[value isEqualToString:@""]) {
                    
                }else
                {
                    if ([fielname containsString:@"_show"]) {
                       fielname= [fielname stringByReplacingOccurrencesOfString:@"_show" withString:@""];
                        
                    }
                    [string appendFormat:@"%@=\"%@\" ",fielname,value];
                }
            }
            [string appendFormat:@" ></grid%@>",groundmain];
        }
    }
    [string appendFormat:@"</Detail>"];
    
    NSLog(@"++++++++%@",string);
    return string;
  
   
}

-(void)addFooterView
{
    infoView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 50 - textFiledHeight, SCREEN_WIDTH - 20, 50 + textFiledHeight)];
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.tag = 1024;
    [self.view addSubview:infoView];
    CGFloat btnWidth = (CGRectGetWidth(infoView.frame) - 30) / 2.0f;
    sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sureBtn setFrame:CGRectMake(10, CGRectGetMaxY(self.beizhuText.frame) + 10, btnWidth, 30)];
    [sureBtn addTarget:self action:@selector(safefield) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:0.314 green:0.816 blue:0.361 alpha:1.000]];
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor]];
    sureBtn.tag = 1025;
    [infoView addSubview:sureBtn];
    
    backBatn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBatn setFrame:CGRectMake(CGRectGetMaxX(sureBtn.frame) + 20, CGRectGetMinY(sureBtn.frame), btnWidth, 30)];
    [backBatn addTarget:self action:@selector(canletouch) forControlEvents:UIControlEventTouchUpInside];
    [backBatn setBackgroundColor:[UIColor colorWithRed:0.906 green:0.251 blue:0.357 alpha:1.000]];
    [backBatn setTitle:@"取消" forState:UIControlStateNormal];
    [backBatn setTitleColor:[UIColor whiteColor]];
    sureBtn.tag = 1026;
    [infoView addSubview:backBatn];
}
#pragma mark----保存到草稿
- (void)saveBills:(NSString *)ac
{
   
    NSString *xmlParameter = [self XMLParameter];
    NSString *xmlParmixi =[self xmlser];
    self.valueStr=[[NSMutableString alloc] init];
    NSLog(@"++++++++++_______%@",xmlParmixi);
    
    
        for (NSString *stz in self.deledict.allKeys) {
            self.delete =stz;
            NSString *value = [self.dictarry objectForKey:self.delete];
            if (value==nil||[value isEqualToString:@""]) {
                value=@"";
                
            }
            NSString *valued=[self.deledict objectForKey:self.delete];
            NSString *val =[NSString stringWithFormat:@"%@:%@%@/",self.delete,value,valued];
            [self.valueStr appendFormat:val];
            
            
            
          
            
        }
    
    
    NSLog(@"__++++++++++++%@",self.valueStr);
    NSLog(@"%@",xmlParameter);
    NSLog(@"%@",self.delete);
    if (xmlParameter.length == 0) {
        
        return;
    }
    NSString *gridmainid;
    NSString *programid;
    
    gridmainid = _selectModel.gridmainid;
    programid = _selectModel.programid;
    
    NSString *str = [NSString stringWithFormat:@"%@?ac=SaveEditData&u=%@&programid=%@&Billid=%@&SaveStr=%@ %@</Root>&GridStr=%@&RowVer=%@",Web_Domain,self.uid,self.programeId,self.billid,xmlParameter,xmlParmixi,self.valueStr,self.str];
    

    NSLog(@"上传的数据str : %@",str);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager POST:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            
//                                           [self uploadImage:0];
                                           
                                           NSString *af =[responseObject objectForKey:@"error"];
                                           long a = [af integerValue];
                                           if (a !=0) {

                                             
                                               
                                            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"msg"]];
                                               return;
                                           }
                                           [self uploadImage:0];

                                           if (self.callback) {
                                               self.callback();
                                           }

                                           
                                           [SVProgressHUD showSuccessWithStatus:@"提交数据成功"];
                                           
                                           [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"msg"]];
                                
                                           NSArray *temArray =self.navigationController.viewControllers;
                                           for (UIViewController *ter in temArray) {
                                               if ([ter isKindOfClass:[BillsListViewController class]]) {
                                                   [self.navigationController popToViewController:ter animated:YES];
                                               }
                                           }
                                           
   
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                          
                                       }];
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"totle %lld",totalBytesWritten);
    }];

}

#pragma 图片递交为二进制
- (void)uploadImage:(NSString *)theSspid ac:(NSString *)ac inde:(NSInteger)index{
    NSString *fbyte = @"";  //图片bate64
    NSString *sspID = [NSString stringWithFormat:@"%@",theSspid];
    if(_type == 1 && [self.newflag isEqualToString:@"no"]){
        sspID = self.editModel.SspID;
    }
    if (_imageArray.count != 0) {
        fbyte = [self bate64ForImage:[_imageArray objectAtIndex:index]];
    }
    
    NSLog(@"bate64 : %@",fbyte);
    NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
    [dictData setObject:fbyte forKey:@"FByte"];
    NSString *str = [NSString stringWithFormat:@"%@?ac=%@&u=%@&EX=%@&sspid=%@&FName=%@",Web_Domain,ac,self.uid,@".jpg",sspID,@"image"];
    if (delteImageID.length != 0) {
        str = [NSString stringWithFormat:@"%@&delpicid=%@",str,delteImageID];
    }
    NSLog(@"str : %@",str);
    [SVProgressHUD showWithMaskType:2];
    [[AFHTTPRequestOperationManager manager] POST:str
                                       parameters:fbyte.length == 0 ? nil :@{@"FByte":fbyte}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              if ([[responseObject objectForKey:@"msg"] isEqualToString:@"ok"]) {
                                                  [SVProgressHUD dismiss];
                                                  if (index + 1 < _imageArray.count) {
                                                      [self uploadImage:sspID ac:ac inde:index + 1];
                                                  }
                                                  //index + 1 == _imagesArray.count - 1
                                                  if (index + 1 == _imageArray.count ) {
                                                      if (commintBills==YES) {
                                                          [self saveCGToBill:sspid];
                                                      }
                                                      else{
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                          if (self.callback) {
                                                              self.callback();
                                                          }
                                                      }
                                                  }
                                              }
                                          }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                          }];
    
}
#pragma 单据提交
- (void)saveCGToBill:(NSString *)AG{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= SspCGToBills &u=9& sspid =3,4,5,6,7
    NSString *billsspid = commintBills ? sspid : _editModel.SspID;
    NSString *url = [NSString stringWithFormat:@"ac=SspCGToBills&u=%@&sspid=%@",self.uid,billsspid];
    [RequestCenter GetRequest:url
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          NSString *msg = [responseObject objectForKey:@"msg"];
                          if ([msg isEqualToString:@"ok"]) {
                              [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                              [self.navigationController popViewControllerAnimated:YES];
                              if (self.callback) {
                                  self.callback();
                              }
                          }
                          else
                              [SVProgressHUD showInfoWithStatus:@"提交失败，请稍后尝试"];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
}
#pragma mark-------保存字典
- (void)saveLayoutKindsToDB:(NSDictionary *)dataDic callbakc:(void (^)(void))callBack{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in dataDic.allKeys) {
            if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                LayoutModel *layoutModel = [[LayoutModel alloc] init];
                [layoutModel setValuesForKeysWithDictionary:[dataDic objectForKey:key]];
                layoutModel.fieldname = key;
                [self.mainLayoutArray addObject:layoutModel];
                if (self.type == 1) {
                    [self.tableViewDic setObject:layoutModel.text forKey:layoutModel.fieldname];
                    if (layoutModel.datasource.length != 0) {
                        [self.XMLParameterDic setObject:layoutModel.name forKey:layoutModel.fieldname];
                    }
                    else
                        [self.XMLParameterDic setObject:layoutModel.text forKey:layoutModel.fieldname];
                    
                }
                
                
                if (layoutModel.datasource.length > 0) {
                    NSString *str = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",layoutModel.datasource]];
                    [[CoreDataManager shareManager] saveDataForTable:@"KindsLayout"
                                                               model:[NSDictionary dictionaryWithObjectsAndKeys:layoutModel.datasource,@"datasource",@"-1",@"dataVer", nil]
                                                                 sql:str];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack();
        });
    });
    
}

//保存文件
-(void)safefield
{
    
    [self saveBills:@"SaveED"];
    
  
}

//取消按钮的点击事件：
-(void)canletouch
{
    NSArray *array = self.navigationController.viewControllers;
    for (UIViewController *VC in array) {
        if ([VC isKindOfClass:[BillsDetailViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES];
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
