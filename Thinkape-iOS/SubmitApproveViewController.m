//
//  SubmitApproveViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/4.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

//
//  SubmitApproveViewController.m
//  Thinkape-iOS
//
//  Created by tixa on 15/6/4.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "SubmitApproveViewController.h"
#import "KindsModel.h"
#import "KindsLayoutModel.h"
#import "BillsLayoutViewCell.h"
#import "KindsItemsView.h"
#import "KindsItemModel.h"
#import "YPCGViewController.h"
#import "CTAssetsPickerController.h"
#import "KindsPickerView.h"
#import "ImageModel.h"
#import "SDPhotoBrowser.h"
#import "DatePickerView.h"
#import "SDPhotoBrowser.h"
#import "UIImage+SKPImage.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>

#import "CalculatorViewController.h"
#import "calculatorView.h"
#import "BorrowView.h"
#import "AppDelegate.h"

@interface SubmitApproveViewController () <KindsItemsViewDelegate,CTAssetsPickerControllerDelegate,SDPhotoBrowserDelegate,UIScrollViewDelegate,
QLPreviewControllerDataSource,CalculatorResultDelegate,BorrowViewDelegate>
{
    NSString *delteImageID;
    NSString *sspid;
    BOOL commintBills;
    BOOL isSingal;
    NSString *_sqlstr;
    CGFloat Text_y;
    CGFloat distances;
//    NSString *_field;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSMutableArray *layoutArray;
@property (strong, nonatomic) NSMutableDictionary *XMLParameterDic;
@property (strong, nonatomic) NSMutableDictionary *tableViewDic;
@property (strong, nonatomic) NSString *newflag;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *imagePaths;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property (strong, nonatomic) DatePickerView *datePickerView;
@property (nonatomic,copy)NSString *messageid;
@property (nonatomic,copy)NSString *namestr;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *commintBtn;

@property(nonatomic)NSInteger tagValue;

@property(nonatomic,strong)NSMutableDictionary *cell_data;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSDictionary *respondict;
@property(nonatomic,strong)CalculatorViewController *calculatorvc;
@property(nonatomic,strong)calculatorView *calculator;
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)NSMutableArray *deaftcec;
@property(nonatomic,assign)BOOL isretern;
@property(nonatomic,strong)KindsItemsView *kindsItemsView;

@property (nonatomic,strong)BorrowView *borrowView;
//是否借款冲销：
@property (nonatomic,assign)BOOL isBorrow;
@property (nonatomic,copy)NSString *oldPersonUid;//保存旧的承担人id

@property (nonatomic,assign)NSInteger layoutarrayCount;

@property (nonatomic,copy)NSMutableArray *borrowSelectArray;//选择冲销的借款的数组
@property (nonatomic,copy)NSMutableArray *borrowTotalarray;//冲销的请求的数组
@property (nonatomic,copy)NSString *borrowSelectMoney;//冲销的选择的金额
@property (nonatomic,copy)NSString *borrowTotalmoney;//冲销的总共的金额


@property(nonatomic,assign)BOOL isediting;//判断草稿页面刚出现时，提前去请求借款单的数据
@property (nonatomic,copy)NSMutableArray *programeIdArray;//用来保存当_type==1一开始的账单的progarmeID

@end

@implementation SubmitApproveViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.type = 0;
        commintBills = NO;
//        self.isediting = NO;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    _isBorrow = NO;
    self.isSubmit = NO;
    _delaysContentTouches = NO;
    
    _borrowTotalarray = [[NSMutableArray alloc]init];
    
    _programeIdArray = [[NSMutableArray alloc]init];
    
    _searchArray = [[NSMutableArray alloc] init];
    _selectModel = [[KindsModel alloc] init];
    _layoutArray = [[NSMutableArray alloc] initWithCapacity:0];
    _imagePaths = [[NSMutableArray alloc] initWithCapacity:0];
    self.cell_data = [NSMutableDictionary dictionary];
    self.XMLParameterDic = [[NSMutableDictionary alloc] init];
    self.tableViewDic = [[NSMutableDictionary alloc] init];
    self.deaftcec = [NSMutableArray array];
    NSLog(@"self.tableViewDic:%@",[self.tableViewDic class]);

    
    UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBt setTitle:@"草稿" forState:UIControlStateNormal];
    [backBt setFrame:CGRectMake(80, 10, 60, 44)];
    
    if (self.type == 0) {
//        UIButton *backBt = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBt setTitle:@"草稿" forState:UIControlStateNormal];
//        [backBt setFrame:CGRectMake(80, 10, 60, 44)];
        [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
        self.navigationItem.rightBarButtonItem = back;
        
        // 码下面选择器的界面：
        if (!self.kindsPickerView) {
            self.kindsPickerView = [[[NSBundle mainBundle] loadNibNamed:@"KindsPickerView" owner:self options:nil] lastObject];
            [self.kindsPickerView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
            __block SubmitApproveViewController *weakSelf = self;
            
            self.kindsPickerView.selectItemCallBack = ^(KindsModel *model){
                weakSelf.selectModel = model;
                //请求“随手报”页面的数据
                [weakSelf billDetails];
            
                if ([weakSelf.selectModel.programid containsString:@"13"]) {
                    weakSelf.isSubmit = YES;
                    [backBt setFrame:CGRectMake(80, 10, 70, 44)];
                    [backBt setTitle:@"借款冲销" forState:UIControlStateNormal];
                    backBt.titleLabel.font = [UIFont systemFontOfSize:16];
                }
            };
            [self.view addSubview:self.kindsPickerView];
        }
        
        [self requestBillsType];
        
    }else{
        [self.commintBtn setTitle:@"提交" forState:UIControlStateNormal];
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.title = @"编辑草稿";
        [self requestEdithBillsType];
        
        if ([self.editModel.ProgramID containsString:@"13"]) {
            
            [backBt setFrame:CGRectMake(80, 10, 70, 44)];
            [backBt setTitle:@"借款冲销" forState:UIControlStateNormal];
            backBt.titleLabel.font = [UIFont systemFontOfSize:16];
            [backBt addTarget:self action:@selector(editItem) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backBt];
            self.navigationItem.rightBarButtonItem = back;

        }
    }
   
    self.calculatorvc=[[CalculatorViewController alloc]init];
    self.calculatorvc.delegate=self;
    self.textfield = [[UITextField alloc] init];    
}

/**
 *  初始化详细表单分类界面
 *
 */
- (void)initItemView:(NSArray *)arr tag:(NSInteger)tag{
//    KindsItemsView *itemView;
   
    self.kindsItemsView= [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
    self.kindsItemsView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    self.kindsItemsView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    self.kindsItemsView.delegate = self;
    self.kindsItemsView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(self.kindsItemsView.frame) / 2.0f);
    self.kindsItemsView.dataArray = arr;
    self.kindsItemsView.isSingl = isSingal;
    self.kindsItemsView.tag = tag;
    [self.view addSubview:self.kindsItemsView];
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.kindsItemsView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self.datePickerView removeFromSuperview];
    [self.calculatorvc.view removeFromSuperview];
   
}

#pragma mark - KindsItemsViewDelegate

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    NSInteger tag = view.tag;
    
    NSLog(@"%@%@",name,ID);
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
    
    [self.XMLParameterDic setObject:ID forKey:layoutModel.key];
    [self.tableViewDic setObject:name forKey:layoutModel.key];
   
    [view closed];
    
    if ([layoutModel.MobileSspEventByAuto isEqualToString:@""]||layoutModel.MobileSspEventByAuto==nil) {
    
    }else {
        [self setAuto:layoutModel];
        
    }
    if (![[self.XMLParameterDic objectForKey:layoutModel.key] isEqualToString:self.oldPersonUid]) {
        
        if (self.isBorrow) {
            
            [self.layoutArray removeLastObject];
            [self.tableViewDic removeObjectForKey:@"borrowMoney"];
        }
        
        if (_type == 1){
        
            for (KindsLayoutModel  *model in self.layoutArray) {
            
                if ([model.Name isEqualToString:@"冲销金额"]) {

                    [self.layoutArray removeObject:model];
                    [self.tableViewDic removeObjectForKey:@"editBorrowMoney"];
          
                    break;
                }
            }
            
            self.layoutarrayCount = self.layoutArray.count;
        }
        
    }
    
    [self.tableView reloadData];
    
     //请求数据结束，数据已经铺在textfield上了，拿到这个数据去
    
    self.isretern=YES;
}

- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
//    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
     KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:tag];
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
    }
    
    [self.XMLParameterDic setObject:idStr forKey:layoutModel.key];
    [self.tableViewDic setObject:nameStr forKey:layoutModel.key];
    
    
    //在这获取nameStr
    
    if ([layoutModel.MobileSspEventByAuto isEqualToString:@""]||layoutModel.MobileSspEventByAuto==nil) {

    }else {
       [self setAuto:layoutModel];
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - Request Methods

/**
 *  请求表单分类信息（pickView的内容：请求出来二维数组用来展示信息）
 */
- (void)requestBillsType{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetSspBillType&u=1
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetSspBillType&u=%@",self.uid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          [self.dataArray removeAllObjects];
                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"data"];
                          NSArray *reqArr = [KindsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"req"]];
                          NSArray *afrArr = [KindsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"afr"]];
                          NSArray *borrowArr = [KindsModel objectArrayWithKeyValuesArray:[dataDic objectForKey:@"borrow"]];
                          [self.dataArray addObject:reqArr];
                          [self.dataArray addObject:afrArr];
                          [self.dataArray addObject:borrowArr];
                          [SVProgressHUD dismiss];
                          self.kindsPickerView.dataArray = self.dataArray;
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }];
    
}

/**
 *  请求 表单信息（选择了不同的信息，点确定调用这个去请求不同的数据）
 */

- (void)billDetails{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=GetSspGridField&u=9&programid=130102&gridmainid=130102
    
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetSspGridField_IOS&u=%@&programid=%@&gridmainid=%@",self.uid,_selectModel.programid,_selectModel.gridmainid]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          
                          [self.layoutArray removeAllObjects];
                          
                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"];
                    
                          KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
                          layoutModel.Name = @"类别";
                          self.newflag = [dataDic objectForKey:@"new"];
                          self.newflag = self.newflag.length > 0 ? self.newflag : @"yes";
                          [self.layoutArray addObject:layoutModel];
                          
                          [self saveLayoutKindsToDB:dataDic callbakc:^{
                              [self.tableView reloadData];
                              [SVProgressHUD dismiss];
                          }];
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                      }
            showLoadingStatus:YES];
    
}


/**
 *  根据版本号检测是否需要重新从服务器上请求数据
 *
 */

- (void)kindsDataSource:(KindsLayoutModel *)model
{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.layoutArray indexOfObject:model];
   
    if (model.datasource.length != 0) {
        NSString *oldDataVer = [[CoreDataManager shareManager] searchDataVer:str1];
    
         _sqlstr = model.MobileSspDataSourceWhere;
        /**
         *  首先判断是否为空，空的话 就传空值，不为空替换
         */
        if ([_sqlstr isEqualToString:@""]) {
            if ([oldDataVer isEqualToString:model.DataVer.length >0 ? model.DataVer : @"0.01"] && oldDataVer.length >0) {
            
                NSString *str = [NSString stringWithFormat:@"datasource like %@ ",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
                [SVProgressHUD showWithStatus:nil maskType:2];
                [self fetchItemsData:str callbakc:^(NSArray *arr) {
                    if (arr.count == 0) {
                    
                        [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str data:[NSDictionary dictionaryWithObjectsAndKeys:model.DataVer.length >0 ? model.DataVer : @"0.01",@"dataVer", nil]];
                        [self requestKindsDataSource:model];
                    }else{
                    
                        [SVProgressHUD dismiss];
                        [self initItemView:arr tag:tag];
                
                    }
                }];
        
            }else{
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.DataVer.length > 0 ? model.DataVer : @"0.01",@"dataVer", nil];
            
                [[CoreDataManager shareManager] updateModelForTable:@"KindsLayout" sql:str1 data:dic];
                [self requestKindsDataSource:model];
        
            }
        
        }else{
            
            _sqlstr = [self str:_sqlstr];
            [self requestKindsDataSource:model];
        }
    }
}


/**
 *  请求 详细数据分类
 *
 */
#pragma mark  点击某个框，加载KindsItemsView并请求数据：

- (void)requestKindsDataSource:(KindsLayoutModel *)model{
    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    
    
//    NSString *sqlstr =model.MobileSspDataSourceWhere;
    /**
     *  首先判断是否为空，空的话 就传空值，不为空替换
     */
    if ([_sqlstr isEqualToString:@""]) {
        
    }else{
        
        _sqlstr = [self str:_sqlstr];
    }
    
    NSInteger tag= [self.layoutArray indexOfObject:model];
    NSString *str0 = [NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0&q=%@",self.uid,model.datasource,_sqlstr];
    NSString *str1 = [str0 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [RequestCenter GetRequest:str1
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
                            [SVProgressHUD dismiss];
                      }
            showLoadingStatus:YES];
   
}


//递交申请
- (void)saveBills:(NSString *)ac
{
    //t
    NSString *xmlParameter = [self XMLParameter];
    if (xmlParameter.length == 0) {
        return;
    }
    NSString *gridmainid;
    NSString *programid;
    
    NSString *appStr =@"Data";
    NSString * ac1 = [NSString stringWithFormat:@"%@%@",ac,appStr];
    if (self.type == 0) {
        gridmainid = _selectModel.gridmainid;
        programid = _selectModel.programid;
    }
    else
    {
        gridmainid = _editModel.GridMainID;
        programid = _editModel.ProgramID;
    }

    NSString *borrowStr;
    if (_isBorrow) {
        borrowStr = [self borrowStr];
    }
    if (_type == 1){
        if ([self.tableViewDic objectForKey:@"editBorrowMoney"]) {
            borrowStr = [self borrowStr];
        }
    }

    NSString *str = [NSString stringWithFormat:@"%@?ac=%@&u=%@&data=%@&gridmainid=%@&programid=%@&new=%@&ImportMsg=%@",Web_Domain,ac1,self.uid,xmlParameter,gridmainid,programid,self.newflag,borrowStr];
    NSLog(@"str : %@",str);
    
    if ([self.newflag isEqualToString:@"no"]) {
        str = [NSString stringWithFormat:@"%@&sspid=%@",str,self.editModel.SspID];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager POST:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                    parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           if ([[responseObject objectForKey:@"msg"] isKindOfClass:[NSDictionary class]]) {
                                               NSDictionary *dic = [responseObject objectForKey:@"msg"];
                                               NSString * ac2 = [NSString stringWithFormat:@"%@File",ac];
                                               sspid = [NSString stringWithFormat:@"%@",dic[@"sspid"]];
                                               //                  if (_imagesArray.count != 0 || delteImageID.length != 0) {
                                               //
                                               //                      [self uploadImage:dic[@"sspid"] ac:ac2 inde:0];
                                               //                  }
                                               if (_imagesArray.count != 0 || delteImageID.length != 0) {
                                                   
                                                   [self uploadImage:dic[@"sspid"] ac:ac2 inde:0];
                                               }
                                               else{
                                                   
                                                   if (commintBills==YES) {
                                                       if (self.type==0) {
                                                           [self saveCGToBill:sspid];
                                                           
                                                       }
                                                       
                                                   }else
                                                   {
                                                       [self.navigationController popViewControllerAnimated:YES];
                                                   }
                                                   if (self.callback) {
                                                       self.callback();
                                                   }
                                               }
                                               
//                                               [SVProgressHUD showWithStatus:@"正在提交" maskType:2];
                                               
                                               [SVProgressHUD showSuccessWithStatus:@"提交数据成功"];
                                           }
                                           else
                                               [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"msg"]];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                       }];

    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        NSLog(@"totle %lld",totalBytesWritten);
    }];
    
}

- (NSString *)borrowStr
{
    //取出“冲销金额”的数据
    NSInteger money = [[self.tableViewDic objectForKey:@"borrowMoney"] integerValue];
    if (_type == 1) {
        money = [[self.tableViewDic objectForKey:@"editBorrowMoney"] integerValue];
    }
    
    if (money == [self.borrowSelectMoney integerValue]) {
        NSString *str0 = [NSString string];
        for (BorrowModel *model in self.borrowSelectArray) {
            str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,model.totalmoney_show_id];
        }
        
        str0 = [str0 substringWithRange:NSMakeRange(0 ,str0.length-3)];
        return str0;
    }else if (money < [self.borrowSelectMoney integerValue])
    {
        NSString *str0 = [NSString string];
//         NSInteger everMoney = money;
//        everMoney = everMoney - [model.totalmoney_show_id integerValue];
 
        NSInteger lastmoney = 0;
        NSInteger everMoney = money;
        lastmoney = everMoney;
        for (BorrowModel *model in self.borrowSelectArray) {
//            NSInteger everMoney = money;
//            lastmoney = everMoney;
            everMoney = everMoney - [model.totalmoney_show_id integerValue];
//            BorrowModel *model0 = [self.borrowSelectMoney[i]]
            
            if (everMoney <= 0) {
                str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,[NSString stringWithFormat:@"%ld", lastmoney ]];
                
                str0 = [str0 substringWithRange:NSMakeRange(0 ,str0.length-3)];
                return str0;
            }else{
                str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,model.totalmoney_show_id];
                lastmoney = everMoney ;
                
            }
            
        }
        
    }else{
        NSString *str0 = [NSString string];
        for (BorrowModel *model in self.borrowSelectArray) {
            str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,model.totalmoney_show_id];
            for (BorrowModel *model0 in _borrowTotalarray) {
                if ([model0.billid isEqualToString:model.billid]) {
                    [_borrowTotalarray removeObject:model0];
                   
                    break;
                }
            }
//            [self.borrowTotalarray removeObject:model];
        }
        
        NSInteger everMoney = 0;
        everMoney = money - [_borrowSelectMoney integerValue];
        NSInteger lastMoney = 0;
        lastMoney = everMoney;
        for (BorrowModel * model in _borrowTotalarray) {
            
            everMoney = everMoney - [model.totalmoney_show_id integerValue];
            if (everMoney > 0){
                str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,model.totalmoney_show_id];
                
                lastMoney = everMoney;
                
            }else{
//                everMoney = [model.totalmoney_show_id integerValue] - everMoney;
//                str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,[NSString stringWithFormat:@"%ld",[model.totalmoney_show_id integerValue] + everMoney]];
                str0 = [str0 stringByAppendingFormat:@"%@|%@{$}",model.billid,[NSString stringWithFormat:@"%ld",lastMoney]];
            
                str0 = [str0 substringWithRange:NSMakeRange(0 ,str0.length-3)];
                return str0;
            }
        }
    }
    return nil;
}


- (void)uploadImage:(NSString *)theSspid ac:(NSString *)ac inde:(NSInteger)index{
    
    NSString *fbyte = @"";  //图片bate64
    NSString *sspID = [NSString stringWithFormat:@"%@",theSspid];
    if(_type == 1 && [self.newflag isEqualToString:@"no"]){
        sspID = self.editModel.SspID;
    }
    if (_imagesArray.count != 0) {
        fbyte = [self bate64ForImage:[_imagesArray objectAtIndex:index]];
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
                                                  if (index + 1 < _imagesArray.count) {
                                                      [self uploadImage:sspid ac:ac inde:index + 1];
                                                  }
                                                  //index + 1 == _imagesArray.count - 1
                                                  if (index + 1 == _imagesArray.count ) {
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
                                              [SVProgressHUD dismiss];
                                          }];
    
}

/**
 *  请求编辑草稿数据
 
 */
- (void)requestEdithBillsType{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= CGEnterSspEdit&u=9&sspid=4
    //self.uid,_editModel.SspID
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=CGEnterSspEdit_IOS&u=%@&sspid=%@",self.uid,_editModel.SspID]
                   parameters:nil
                      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                          [self.layoutArray removeAllObjects];
                          NSDictionary *dataDic = [[responseObject objectForKey:@"msg"] objectForKey:@"fieldconf"];
                          NSArray *imageArr = [[responseObject objectForKey:@"msg"] objectForKey:@"filepath"];
                          [_imagePaths addObjectsFromArray:[ImageModel objectArrayWithKeyValuesArray:imageArr]];
                          self.newflag = [dataDic objectForKey:@"new"];
                          self.newflag = self.newflag.length > 0 ? self.newflag : @"no";
                          KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
                          layoutModel.Name = @"类别";
                          layoutModel.key = @"cagegory_c";
                          [self.layoutArray addObject:layoutModel];
                        
                          [self.tableViewDic setObject:_editModel.cname forKey:layoutModel.key];
                          
                          /**
                           *  如果有借款冲销的话
                           */
                          NSString *moneyStr = [[responseObject objectForKey:@"msg"] objectForKey:@"importbills"];
                          
                          if (![moneyStr isEqualToString:@""] ) {
                              
                              KindsLayoutModel *model = [[KindsLayoutModel alloc]init];
                              
                              model.Name = @"冲销金额";
                      
                              [self.layoutArray addObject:model];
                              
                              model.key = @"editBorrowMoney";
                               NSString *importbillsTotalMoney = [self importbillsTotalMoney:moneyStr];
                              [self.tableViewDic setObject:importbillsTotalMoney forKey:model.key];
    
                          }
                          //
                          //请求数据成功之后，保存到DB成功之后的回调：

                          //可不可以在回调里面去请求数据
                          
                          [self saveLayoutKindsToDB:dataDic callbakc:^{
                              
                              [self.tableView reloadData];
                              [SVProgressHUD dismiss];
                              

                              if ([self.tableViewDic objectForKey:@"editBorrowMoney"]) {
                                  for (KindsLayoutModel * model in self.layoutArray) {
                                      if ([model.Name isEqualToString:@"承担人"]) {
                                          NSString *personUid = [self.XMLParameterDic objectForKey:model.key];
                                          self.oldPersonUid = personUid;
                                          
                                          [self requestBorrowDataSource:personUid];
                                          [SVProgressHUD showWithStatus:@"请稍后" maskType:2];
                                      }
                                  }
                                  
                              }
                          }];
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                          [SVProgressHUD showErrorWithStatus:@"请求数据失败，请检查网络"];
                          
                      }
            showLoadingStatus:YES];
}


#pragma mark   请求编辑草稿数据时，如果有冲销金额，要对冲销金额进行拆分并且展示在列表上

- (NSString *)importbillsTotalMoney:(NSString *)moneyStr
{
    
    NSArray *rootArray = [moneyStr componentsSeparatedByString:@","];
    NSMutableArray *lastArray = [[NSMutableArray alloc]init];
    for (NSString *itemStr in rootArray) {
        NSArray *itemArray = [itemStr componentsSeparatedByString:@":"];
        [lastArray addObject:itemArray];
    }
    NSInteger totalMoney = 0;
    for (int i = 0; i<lastArray.count; i++) {
        NSInteger money = [lastArray[i][2] integerValue];
        NSString *programeId = lastArray[i][1];
        [_programeIdArray addObject:programeId];
        
        totalMoney +=money;
    
    }

    return [NSString stringWithFormat:@"%ld",totalMoney];
    
}

// 编辑时 草稿 存为单据

- (void)saveCGToBill:(NSString *)AG
{
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac= SspCGToBills &u=9& sspid =3,4,5,6,7
    
//    [self checkoutEmpty];
    
    if (_type == 1) {
        [self saveBills:@"SaveCG"];
    }
    
    
    NSString *billsspid = commintBills ? sspid : _editModel.SspID;
    
    NSString *borrowStr;
    if (_type == 1) {
        if ([self.tableViewDic objectForKey:@"editBorrowMoney"]) {
            
            borrowStr = [self borrowStr];
        }
        
    }

    NSString *url = [NSString stringWithFormat:@"ac=SspCGToBills&u=%@&sspid=%@&ImportMsg=%@",self.uid,billsspid,borrowStr];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *str1 = @"http://27.115.23.126:5032/ashx/mobileNew.ashx?ac=GetDataSourceNew&u=1&datasource=410202&dataver=0&q=and cDepName like '%财%'";
    
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

//
//- (void)checkoutEmpty
//{
//    int i = 0;
//    for (KindsLayoutModel *layoutModel in self.layoutArray) {
//        // NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
//        //
//        NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
//        
//        if (layoutModel.IsMust==1 && value.length == 0&&i !=0) {
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.Name]];
//            
//        }
//          i++;
//    }
//  
//
//  
//}








#pragma mark - SQL DB Action

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

- (void)saveLayoutKindsToDB:(NSDictionary *)dataDic callbakc:(void (^)(void))callBack{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in dataDic.allKeys) {
            if ([[dataDic objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                KindsLayoutModel *layoutModel = [[KindsLayoutModel alloc] init];
                [layoutModel setValuesForKeysWithDictionary:[dataDic objectForKey:key]];
                layoutModel.key = key;
               
                [self.layoutArray addObject:layoutModel];
               
                if (self.type == 1) {
                    [self.tableViewDic setObject:layoutModel.Text forKey:layoutModel.key];
                    if (layoutModel.datasource.length != 0) {
                        [self.XMLParameterDic setObject:layoutModel.Value forKey:layoutModel.key];
                    }
                    else
                        [self.XMLParameterDic setObject:layoutModel.Text forKey:layoutModel.key];
                    
                }
                
                if (layoutModel.datasource.length > 0) {
                    NSString *str = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",layoutModel.datasource]];
                    [[CoreDataManager shareManager] saveDataForTable:@"KindsLayout"
                                                               model:[NSDictionary dictionaryWithObjectsAndKeys:layoutModel.datasource,@"datasource",@"-1",@"dataVer", nil]
                                                                 sql:str];
                }
            }
        }
        self.layoutarrayCount = self.layoutArray.count ;
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack();
        });
    });
    
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

#pragma mark - BtnAction单击右边切换到草稿编辑,借款冲销的UI创建
//
- (void)editItem
{
    self.isediting = YES;
    
    if (_type == 0){
        
        if (_isSubmit == YES){
            NSLog(@"%@",_selectModel.programid);
//            KindsLayoutModel *model;
            
            for (KindsLayoutModel * model in _layoutArray) {
                if ([model.Name isEqualToString:@"承担人"]) {
                    NSString *personUid = [self.XMLParameterDic objectForKey:model.key];
                    self.oldPersonUid = personUid;
                    if (personUid) {
                        [self requestBorrowDataSource:personUid];
                        [SVProgressHUD showWithStatus:@"加载中，请稍后" maskType:2];
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"请选择承担人"];
                    }
                    
                }
            }
            
//            KindsLayoutModel *model = _layoutArray[2];
            
        }else{
            YPCGViewController *ypVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YPCGVC"];
            [self.navigationController pushViewController:ypVC animated:YES];
        }
    }else{//当_type == 1 的时候
        
        
        
        for (KindsLayoutModel * model in _layoutArray) {
            if ([model.Name isEqualToString:@"承担人"]) {
                NSString *personUid = [self.XMLParameterDic objectForKey:model.key];
                self.oldPersonUid = personUid;
                if (personUid) {
                    [self requestBorrowDataSource:personUid];
                    [SVProgressHUD showWithStatus:@"加载中，请稍后" maskType:2];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请选择承担人"];
                }
                
            }
        }
        
    }
    
}

//单击借款冲销
-(void)requestBorrowDataSource:(NSString *)personUid
{
    //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac= ImportBills&u=1&uid=1&skisbyloginuser=0&sourceprogramid=120102&targetprogramid=130102&pi=1&ps=50
    
    [self.datePickerView removeFromSuperview];
    [self.calculatorvc.view removeFromSuperview];
    [self.kindsItemsView removeFromSuperview];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *skisbyloginuser = [userDefaults objectForKey:@"skisbyloginuser"];
    NSString *ski = [userDefaults objectForKey:@"user"];
    NSString *modelProgramId ;
    
    if (_type == 0) {
        
        modelProgramId = _selectModel.programid;
        
    }else{
        modelProgramId = self.editModel.ProgramID;
    }

    NSString *str0 =[NSString stringWithFormat:@"ac=ImportBills&u=%@&uid=%@&skisbyloginuser=%@&sourceprogramid=120102&targetprogramid=%@&pi=0&ps=50",self.uid,personUid,skisbyloginuser,modelProgramId];
    
    NSString *urlStr = [str0 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [RequestCenter GetRequest:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSDictionary *msgDic = [responseObject objectForKey:@"msg"];
        NSArray *rootArray = [msgDic objectForKey:@"data"];
        
        if ([rootArray isKindOfClass:[NSArray class]]) {
            //       for (NSDictionary *dic in arr) {
//            KindsItemModel *itemModel = [KindsItemModel objectWithKeyValues:dic];
            NSMutableArray *modelArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dict  in rootArray) {
                BorrowModel *borrowModel = [BorrowModel objectWithKeyValues:dict];
                [modelArr addObject:borrowModel];
            }
            [self initBorrowView:modelArr];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
            [SVProgressHUD dismiss];
            
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}





- (void)initBorrowView:(NSArray *)rootArray
{
    
    self.borrowView= [[[NSBundle mainBundle] loadNibNamed:@"BorrowView" owner:self options:nil] lastObject];
    self.borrowView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    self.borrowView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    self.borrowView.delegate = self;
    self.borrowView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(self.kindsItemsView.frame) / 2.0f);
    self.borrowView.dataArray = rootArray;
    _borrowTotalarray = rootArray;

    NSInteger totalmoney = 0;
    for (int i = 0; i<rootArray.count; i++) {
        BorrowModel *model = rootArray[i];
    
        NSInteger money = [model.totalmoney_show_id integerValue];
        totalmoney += money;
    }
    self.borrowTotalmoney = [NSString stringWithFormat:@"%ld",totalmoney];
    if (self.isediting) {
        [self.view addSubview:self.borrowView];
    }
    for (BorrowModel *model in self.borrowTotalarray) {
        
        for (NSString *programeId in _programeIdArray) {
            if ([model.billid isEqualToString:programeId]) {
                _borrowSelectArray = [[NSMutableArray alloc]init];
                [_borrowSelectArray addObject:model];
            }
        }
    }
    
    NSInteger money0 = 0;
    for (BorrowModel *model in _borrowSelectArray) {
        
        NSInteger money = [model.totalmoney_show_id integerValue];
        money0 += money;
    }
    
    _borrowSelectMoney = [NSString stringWithFormat:@"%ld",money0];
    
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.borrowView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self.datePickerView removeFromSuperview];
    [self.calculatorvc.view removeFromSuperview];
    
}

#pragma mark   BorrowViewDelegate
//
- (void)selectBorrowArray:(NSArray *)array view:(BorrowView *)view
{
    self.borrowSelectArray = [[NSMutableArray alloc]initWithArray:array];
    
    NSInteger money0 = 0;
    
    for (int i = 0; i<array.count; i++) {
        BorrowModel *model = array[i];
        NSInteger money = [model.totalmoney_show_id integerValue];
        money0 += money;

    }
    
    NSLog( @"%ld",money0);
    
    KindsLayoutModel *model = [[KindsLayoutModel alloc]init];
    model.Name = @"冲销金额";
    if (_type == 0) {
        self.isBorrow = YES;
        if (self.layoutArray.count > self.layoutarrayCount ) {
        
        }
        else{
            [self.layoutArray addObject:model];
            
        }
        model.key = @"borrowMoney";
        
        [self.tableViewDic setObject:[NSString stringWithFormat:@"%ld",money0] forKey:model.key];

    }else if (_type == 1){

        if ([self.tableViewDic objectForKey:@"editBorrowMoney"]){
            
        }else{
            [self.layoutArray addObject:model];
        }
    
        model.key = @"editBorrowMoney";
        [self.tableViewDic setObject:[NSString stringWithFormat:@"%ld",money0] forKey:@"editBorrowMoney"];
        
    }

    self.borrowSelectMoney = [NSString stringWithFormat:@"%ld",money0];
    
    [self.tableView reloadData];
    
}


#pragma mark    随手记：存为草稿，递交申请；草稿：保存，提交
/**
 *  存为草稿
 *
 */
- (IBAction)saveToDraft:(UIButton *)sender {
    //http://27.115.23.126:3032/ashx/mobilenew.ashx?ac=savecg&u=9&data=<data gridmainid="130602" programid="130602" uid="9" deptid="3" memo="这只是1个测试" billmoney="500" ></data>&gridmainid=130102&programid=130102& EX=.jpg{$}&new=yes
    if(_type == 0)
    {
        self.newflag = @"yes";
    }
    else
    {
        self.newflag = @"no";
    }
    
    commintBills = NO;
    [self saveBills:@"SaveCG"];
    
}

/**
 *  递交申请
 *
 */
- (IBAction)commitApprove:(UIButton *)sender
{
    if (self.type == 0) {
        commintBills = YES;
        [self saveBills:@"SaveCG"];
        
    }else{
        [self saveCGToBill:sspid];
    }
    
}

- (void)showPickImageVC
{
    if (!_imagesArray) {
        _imagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    UIActionSheet *sleep = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"本地相册", nil];
    [sleep showInView:self.view];
    
    
}

//扫描字符串
- (BOOL)isPureInt:(NSString*)string{
    //  [NSScanner scannerWithString:string];
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


#pragma mark - UIActionSheetDelegate
//调用相机，访问相册，取消
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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

#pragma mark   UIImagePickerControllerDelegate   调用相机：
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"info:%@",info);
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *image = [UIImage imageWithData:[originalImage thumbImage:originalImage]];
    image = [image fixOrientation:image];
    [_imagesArray addObject:image];
    [self.tableView reloadData];
    
}


#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    id class = [assets lastObject];
    for (ALAsset *set in assets) {
        UIImage *image = [UIImage imageWithCGImage:[set aspectRatioThumbnail]];
        [_imagesArray addObject:image];
    }
    [self.tableView reloadData];
    NSLog(@"class :%@",[class class]);
}

#pragma mark - CustomMethods

- (void)showSelectImage:(UIButton *)btn{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    browser.sourceImagesContainerView = nil;
    
    browser.imageCount = _imagesArray.count;
    
    browser.currentImageIndex = btn.tag - 2024 - _imagePaths.count;
    
    browser.delegate = self;
    browser.tag = 11;
    [browser show]; // 展示图片浏览器
}

- (void)showImage:(UIButton *)btn{
    ImageModel *url = [_imagePaths safeObjectAtIndex:btn.tag - 1024];
    if ([self fileType:url.FilePath] == 1) {
        [[RequestCenter defaultCenter] downloadOfficeFile:url.FilePath
                                                  success:^(NSString *filename) {
                                                      QLPreviewController *previewVC = [[QLPreviewController alloc] init];
                                                      previewVC.dataSource = self;
                                                      [self presentViewController:previewVC animated:YES completion:^{
                                                          
                                                      }];
                                                  }
                                                  fauiler:^(NSError *error) {
                                                      
                                                  }];
    }
    else{
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.tag = 10;
        browser.sourceImagesContainerView = nil;
        
        browser.imageCount = _imagePaths.count;
        
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


- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // UIButton *imageView = (UIButton *)[bgView viewWithTag:index];
    if (browser.tag == 11) {
        return _imagesArray[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_imagePaths objectAtIndex:index]);
        ImageModel *model = [_imagePaths objectAtIndex:index];
        return [NSURL URLWithString:model.FilePath];
    }
    else
        return nil;
    
}

- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
    __block SubmitApproveViewController *weakSelf = self;
    self.datePickerView.tag = tag;
    
    
    if (date.length != 0) {
        self.datePickerView.date = date;
    }

    self.datePickerView.selectDateCallBack = ^(NSString *date){
        NSInteger tag = weakSelf.datePickerView.tag;
        KindsLayoutModel *layoutModel = [weakSelf.layoutArray safeObjectAtIndex:tag];
        [weakSelf.XMLParameterDic setObject:date forKey:layoutModel.key];
        [weakSelf.tableViewDic setObject:date forKey:layoutModel.key];
        [weakSelf.datePickerView closeView:nil];
        
        if ([layoutModel.MobileSspEventByAuto isEqualToString:@""]||layoutModel.MobileSspEventByAuto==nil) {
    
        }else {
        
            [weakSelf setAuto:layoutModel];
        }
        
        [weakSelf.tableView reloadData];
    };
   
    [self.calculatorvc.view removeFromSuperview];
    [self.kindsItemsView removeFromSuperview];
    
    [self.view addSubview:self.datePickerView];
    
    NSLog(@"kongd");

}

//    UIImage图片转成base64字符串
- (NSString *)bate64ForImage:(UIImage *)image{
    UIImage *_originImage = image;
    NSData *_data = UIImageJPEGRepresentation(_originImage, 0.5f);
    NSString *_encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return _encodedImageStr;
}

//判断输入值是否为空,判断冲销金额相关
- (NSString *)XMLParameter
{
    NSMutableString *xmlStr = [NSMutableString string];
    int i = 0;
    for (KindsLayoutModel *layoutModel in self.layoutArray) {
        // NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
        //
        NSString *value = [self.XMLParameterDic objectForKey:layoutModel.key];
        
        if (layoutModel.IsMust==1 && value.length == 0&&i !=0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.Name]];
            return nil;
        }
        if (i != 0 && value.length != 0) {
            if (i != self.layoutArray.count ) {
                [xmlStr appendFormat:@"%@=\"%@\" ",layoutModel.key,value];
            }
            else
            {
                [xmlStr appendFormat:@"%@=\"%@\"",layoutModel.key,value];
            }
        }
        
        //冲销金额是否符合要求
        
        if (self.isBorrow || _type == 1) {
          
            NSString *money = [self.tableViewDic objectForKey:@"borrowMoney"];
            if (self.isBorrow) {
                money = [self.tableViewDic objectForKey:@"borrowMoney"];
            }else if (_type == 1){
                money = [self.tableViewDic objectForKey:@"editBorrowMoney"];
            }
            
            NSString *billmoney = [self.tableViewDic objectForKey:@"billmoney"];
            if (billmoney && [money integerValue] > [billmoney integerValue]) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"冲销金额不能大于报销金额"]];
                return nil;
            }
            if ([money integerValue] > [self.borrowTotalmoney integerValue]) {
                [SVProgressHUD showErrorWithStatus:@"冲销金额不能大于借款金额"];
                return nil;
            }
        }
        i++;
    }
    NSString *returnStr = [NSString stringWithFormat:@"<data %@></data>",xmlStr];
    NSLog(@"xmlStr : %@",returnStr);
    return returnStr;
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.tagValue=textField.tag;
    self.textfield.tag = textField.tag;
    [textField resignFirstResponder];

     KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:self.tagValue];
    
    NSString * category=[NSString stringWithFormat:@"%@",layoutModel.Name];
   
    NSLog(@"===%@",layoutModel.Name);
    
    if ([category rangeOfString:@"金额"].location !=NSNotFound) {
        
        CGRect frame=CGRectMake(0,[UIScreen mainScreen].bounds.size.height-250 , [UIScreen mainScreen].bounds.size.width, 250);
        self.calculatorvc.view.frame=frame;
        
//        textField.inputView=self.calculatorvc.view;

        [self.view addSubview:self.calculatorvc.view];

        [self.kindsItemsView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
        
        
        return NO;
        
        
    }else{
        
        [self.calculatorView removeFromSuperview];
       
    }

    if (layoutModel.datasource.length > 0) {
        
        //如果是1，就会弹出选择框：
        isSingal = layoutModel.IsSingle;
      
        [self.kindsItemsView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
        [self kindsDataSource:layoutModel];
       
        return NO;
    }
  
    else if ([layoutModel.SqlDataType isEqualToString:@"date"]){
        [self.datePickerView removeFromSuperview];
        
        [self addDatePickerView:textField.tag date:textField.text];
        
        [self.kindsPickerView removeFromSuperview];
        [self.calculatorView removeFromSuperview];
    
        return NO;
    }
    else{
    
        [self.kindsItemsView removeFromSuperview];
        [self.kindsPickerView removeFromSuperview];
        [self.calculatorView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
         return YES;
        
    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:textField.tag];

    if (![self isPureInt:textField.text] && [layoutModel.SqlDataType isEqualToString:@"number"] && textField.text.length != 0) {
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
                
                return NO;
            }
            
        }
    }
    
    [self.XMLParameterDic setObject:textField.text forKey:layoutModel.key];
    [self.tableViewDic setObject:textField.text forKey:layoutModel.key];
   
    return YES;
}

#pragma mark -- 执行计算器单击确认的操作

//执行计算器单击确认的操作
-(void)sender:(NSString *)str{
    
//    UITextField * textField=(UITextField *)[self.view viewWithTag:self.textfield.tag];

    UITextField * textField=(UITextField *)[self.view viewWithTag:self.tagValue];
    double number = [str doubleValue];
    if (number == 0){
        textField.text = @"";
        
    }else{
        textField.text = str;

    }
    NSLog(@"-----%@",str);
    
    [self.calculatorvc.view removeFromSuperview];
    
    self.tagValue=textField.tag;
    self.textfield.tag = textField.tag;
    
    KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:self.tagValue];

    [self.XMLParameterDic setObject:str forKey:layoutModel.key];
    [self.tableViewDic setObject:str forKey:layoutModel.key];
    
    
    //在这里获取输入的金额数str
    
    
    if ([layoutModel.MobileSspEventByAuto isEqualToString:@""]||layoutModel.MobileSspEventByAuto==nil) {
        
        
    }else {
        
        [self setAuto:layoutModel];
    }
    [self.tableView reloadData];

}


- (void)hideCalculatorScreenText
{
    if (self.calculatorvc.view) {
        
        [self.calculatorvc.view removeFromSuperview];
    }
}



- (void)deleteBtnClick
{
     UITextField * textField=(UITextField *)[self.view viewWithTag:self.tagValue];
    textField.text = @"";
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark - UITableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.layoutArray.count == 0) {
        return 0;
    }
    else
        return self.layoutArray.count + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == 0){
        
        [self setdefaults];
    }


    if (indexPath.row != self.layoutArray.count) {
        
        KindsLayoutModel *layoutModel = [self.layoutArray safeObjectAtIndex:indexPath.row];
        layoutModel.index = indexPath.row;
        layoutModel.indexPath = indexPath;
        NSLog(@"hshhahshshshshshshsh-------------%ld",layoutModel.index);
        
        
        static NSString *cellID = @"cell";
        BillsLayoutViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        cell.contentText.placeholder = @"";
        
        if (cell == nil) {
            cell = [[BillsLayoutViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        
        cell.category.text = [NSString stringWithFormat:@"%@:",layoutModel.Name];
       
        cell.contentText.tag = indexPath.row;

        
        if(indexPath.row == 0){
            
        }else{
            
            [self.cell_data setObject:cell.contentText forKey:layoutModel.key];
           
        }
       
        
        
        NSString *value = [self.tableViewDic objectForKey:layoutModel.key];
        
        value = value.length >0 ? value :@"";
        NSLog(@"值%@",value);
        cell.contentText.text = value;
        cell.contentText.enabled = YES;
        
        if (indexPath.row == 0 && self.type == 0) {
            cell.contentText.text = _selectModel.cname;
            cell.contentText.enabled = NO;
        }
        else if (indexPath.row == 0 && self.type == 1){
            cell.contentText.enabled = NO;
        }
        else{
            if (layoutModel.IsMust == 1) {
                cell.contentText.placeholder = @"请输入，不能为空";
            }
            if ([layoutModel.SqlDataType isEqualToString:@"number"]) {
//                cell.contentText.keyboardType =UIKeyboardTypeDecimalPad ;
            }
        }
        

        return cell;
        
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        NSInteger count = _imagePaths.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        
        for (int i = 0; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            ImageModel *model = [_imagePaths safeObjectAtIndex:i];
            if ([self fileType:model.FilePath] == 1) {
                [btn setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
            }
            else{
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.FilePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ab_nav_bg"]];
            }
            btn.tag = 1024 + i;
            [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
            deleteBtn.tag = 1024+ i;
            [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
        }
        count += _imagesArray.count;
        for (int i = _imagePaths.count; i < count; i++) {
            int cloum = i %3;
            int row = i / 3;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(speace + (speace + imageWidth) * cloum, speace + (speace + imageWidth) * row, imageWidth, imageWidth)];
            [btn setBackgroundImage:[_imagesArray safeObjectAtIndex:i - _imagePaths.count] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(showSelectImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2024+ i;
            [cell.contentView addSubview:btn];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(imageWidth - 32, 0, 32, 32)];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
            deleteBtn.tag = 2024+ i;
            [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
            
        }
        int btnCloum = count %3;
        int btnRow = count / 3;
        cell.backgroundColor = [UIColor clearColor];
        UIButton *addImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [addImage setFrame:CGRectMake(speace + (speace + imageWidth) * btnCloum, speace + (speace + imageWidth) * btnRow, imageWidth, imageWidth)];
        [addImage setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
        [addImage addTarget:self action:@selector(showPickImageVC) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addImage];

        
        return cell;
    }
}

#define mark -- scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.tableView reloadData];
}

-(void)setdefaults
{
   if (self.isretern==NO) {
       for (KindsLayoutModel *layout in self.layoutArray) {
           if ([layout.MobileSspDefaultValue isEqualToString:@""]||layout.MobileSspDefaultValue==nil || !layout.MobileSspDefaultValue) {
    
           }else{
            
//               NSString *MobileSspEventByAuto = layout.MobileSspEventByAuto;
//               NSString *mobileStr = [self str:MobileSspEventByAuto];
               
               NSString *mober = layout.MobileSspDefaultValue;
               NSString *aler =[self str:mober];
            //            @synchronized(self) {
               NSString *defaults = [NSString stringWithFormat:@"%@?ac=MobileDefaultValue&u=%@&fieldname=%@&strsql=%@",Web_Domain,self.uid,layout.Field,aler];
        
               NSLog(@"默认值的接口=%@",defaults);
               AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
               AFHTTPRequestOperation *op = [manager POST:[defaults stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   long error = [[responseObject objectForKey:@"error"] integerValue];
               
                   if (error!=0) {
                    
                   }else{
                    
                       NSString *msg =[responseObject objectForKey:@"msg"];
                       NSArray *array =[msg componentsSeparatedByString:@";"];
                       
                       for (int i=0; i<[array count]; i++) {
                           NSString *ster =  [array objectAtIndex:i];
                        
                           if(![ster isEqualToString:@""]) {
                           
                               NSArray *arcer =[ster componentsSeparatedByString:@":"];
                               self.namestr = [arcer objectAtIndex:1];
                               NSArray *f_id = [[arcer objectAtIndex:0] componentsSeparatedByString:@"="];
                           
                               NSString *field =[[f_id objectAtIndex:0]stringByReplacingOccurrencesOfString:@"$" withString:@""];
                           
                               self.messageid = [f_id objectAtIndex:1];
                               NSLog(@"msg分割=%@",[array objectAtIndex:i] );
                        
                               if (layout.MobileSspDefaultValue) {
                             
//                                   self.textfield.tag = layout.index;
                                   
                                   BillsLayoutViewCell *cell = [self.tableView cellForRowAtIndexPath:layout.indexPath];
                     
              
//                                   BillsLayoutViewCell *cell
                                   cell.contentText.text = self.namestr;
                         
//                                   UITextField *field = [self.textfield viewWithTag:layout.index];
                                
                                   cell.contentText = [self.cell_data objectForKey:field];
//                                   field.text = self.namestr;
                                   
                               }
                               
                               self.textfield = [self.cell_data objectForKey:field];
                              
                               self.textfield.text =self.namestr;
                            
//                               self.textfield = [self.cell_data objectForKey:field];
//                               self.textfield.text = self.namestr;
                               
                               [self.XMLParameterDic setObject:self.messageid forKey:field];
                           
                               [self.tableViewDic setObject:self.namestr forKey:field];
                               
                           }else{
                        
                           }

                       }
                   }
               }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                   [SVProgressHUD dismiss];
           
               }];
               
               [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
               
                   NSLog(@"totle %lld",totalBytesWritten);
               }];
           }
           NSLog(@"设置默认值请求数据成功");
        //[__lock unlock];
       }
       
   }

}

//替换大括号字符串 包括#
-(NSString *)str:(NSString *)mobel
{
    NSDictionary *icer =[NSDictionary dictionary];
    NSDictionary *axz = [self fetchdata:icer];
    NSDictionary *aler = [NSDictionary dictionary];
    aler = [axz objectForKey:@"UserMsg"];
    
    NSString *idept ;
    if ([aler objectForKey:@"#idepid"]!=nil ) {
        idept = [aler objectForKey:@"#idepid"];
    }else
    {
        idept = @"";
    }
    
    NSString *cdepname;
    if ([aler objectForKey:@"#cdepname"]!=nil ) {
        cdepname = [aler objectForKey:@"#cdepname"];
    }else
    {
        cdepname = @"";
    }
    
    NSString *iroleid;
    if ([aler objectForKey:@"#iroleid"]!=nil ) {
        iroleid= [aler objectForKey:@"#iroleid"];
    }else
    {
        iroleid = @"";
    }
    NSString *cdepcode;
    if ([aler objectForKey:@"#cdepcode"]!=nil ) {
        cdepcode = [aler objectForKey:@"#iroleid"];
    }else
    {
        cdepcode = @"";
    }
    NSString *crolecode;
    if ([aler objectForKey:@"#crolecode"]!=nil ) {
        crolecode = [aler objectForKey:@"#crolecode"];
    }else
    {
        crolecode = @"";
    }
    NSString *crolename;
    if ([aler objectForKey:@"#crolename"]!=nil ) {
        crolename = [aler objectForKey:@"#crolename"];
    }else
    {
        crolename = @"";
    }
    NSString *cusercode;
    if ([aler objectForKey:@"#cusercode"]!=nil ) {
        cusercode = [aler objectForKey:@"#cusercode"];
    }else
    {
        cusercode = @"";
    }
    NSString *cusername;
    if ([aler objectForKey:@"#cusername"]!=nil ) {
        cusername = [aler objectForKey:@"#cusername"];
    }else
    {
        cusername = @"";
    }
    
    NSString *cuid;
    if ([aler objectForKey:@"#uid"]!= nil) {
        cuid  = [aler objectForKey:@"#uid"];
    }else{
        cuid = @"";
    }
    
    if ([mobel containsString:@"{"]) {
        
        NSRange r = [mobel rangeOfString:@"{"];
        int strat = r.location;
        NSRange r2 = [mobel rangeOfString:@"}"];
        int end = r2.location;
        NSString *field =  [mobel substringWithRange:NSMakeRange(strat, end-strat+1)];
        NSLog(@"r-----=%lu",(unsigned long)r2.location);
       
        
        NSString *sss = [field stringByReplacingOccurrencesOfString:@"{" withString:@""];
        sss = [sss stringByReplacingOccurrencesOfString:@"}" withString:@""];
        
        //UITextField *xt =[UITextField new];
        //xt =[self.cell_data objectForKey:sss];
        
        NSString *sst ;
        if ([self.XMLParameterDic objectForKey:sss] == nil) {
            sst = @"";
        }else{
            sst = [self.XMLParameterDic objectForKey:sss];
        }
    
        mobel =[mobel stringByReplacingOccurrencesOfString:field withString:sst];
        NSLog(@"mob = %@",mobel);
        
        mobel = [mobel stringByReplacingOccurrencesOfString:@"{" withString:@""];
        
    }
    
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#idepid" withString:idept];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#cdepcode" withString:cdepcode];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#cdepname" withString:cdepname];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#iroleid" withString:iroleid];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#crolecode" withString:crolecode];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#crolename" withString:crolename];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#cusercode" withString:cusercode];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#cusername" withString:cusername];
    mobel = [mobel stringByReplacingOccurrencesOfString:@"#uid" withString:cuid];
    
    return mobel;
}

-(NSDictionary *)fetchdata:(NSDictionary *)dict;
{
    dict =  [NSDictionary dictionaryWithContentsOfFile:[self filePath]];
    return dict;
}
- (NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/Account/",NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/Account/account",NSHomeDirectory()];
    return filePath;
}
//替换字符串
-(NSString *)idept:(NSString *)Idept
{
    if ([Idept containsString:@"#"]) {
        NSRange c =[Idept rangeOfString:@"#"];
        long start = c.location;
        NSRange b = [Idept rangeOfString:@"d"];
        
        int end = b.location;
        NSString *field = [Idept substringWithRange:NSMakeRange(start, end-start+1)];
        Idept =[Idept stringByReplacingOccurrencesOfString:field withString:@"2"];
        NSLog(@"idept = %@",Idept);
    }
    return Idept;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.layoutArray.count) {
        return 40;
    }
    else{
       
        NSInteger count = _imagesArray.count + _imagePaths.count;
        CGFloat speace = 15.0f;
        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
        int row = count / 3 + 1;
        return (speace + imageWidth) * row;
    }
    
}

- (void)deleteImage:(UIButton *)btn{
    
    if (btn.tag >=1024 && btn.tag < 2024) {
        ImageModel *model = [_imagePaths safeObjectAtIndex:btn.tag - 1024];
        if (delteImageID.length == 0) {
            delteImageID = [NSString stringWithFormat:@"%@",model.ID];
        }
        else{
            delteImageID = [NSString stringWithFormat:@"%@,%@",delteImageID,model.ID];
        }
        [_imagePaths removeObject:model];
    }
    else{
        [_imagesArray removeObjectAtIndex:btn.tag - 2024];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -- 设置联动值

- (void) setAuto : (KindsLayoutModel *)layout
{
    
//#if 0

    NSString *mobileStr = [self str:layout.MobileSspEventByAuto];
    NSString * autoStr = [NSString stringWithFormat:@"%@?ac=MobileEventByAuto&u=%@&strsql=%@",Web_Domain,self.uid,mobileStr];
    
    NSLog(@"默认值的接口=%@",autoStr);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager POST:[autoStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        long error = [[responseObject objectForKey:@"error"] integerValue];
        if (error!=0) {
        
        }else{
            NSString *msg =[responseObject objectForKey:@"msg"];
            NSArray *array =[msg componentsSeparatedByString:@";"];
        
            for (int i=0; i<[array count]; i++) {
                NSString *ster =  [array objectAtIndex:i];
                if(![ster isEqualToString:@""]) {
                    NSArray *arcer =[ster componentsSeparatedByString:@":"];
                    self.namestr = [arcer objectAtIndex:1];
                    NSArray *f_id = [[arcer objectAtIndex:0] componentsSeparatedByString:@"="];
                    NSString *field =[[f_id objectAtIndex:0]stringByReplacingOccurrencesOfString:@"$" withString:@""];
                    self.messageid = [f_id objectAtIndex:1];
                    
                    NSLog(@"msg分割=%@",[array objectAtIndex:i] );
                    
                    self.textfield = [self.cell_data objectForKey:field];
                
                    self.textfield.text = self.namestr;
        
                    //存的弹窗的对应的id值
                    
                    [self.XMLParameterDic setObject:self.messageid forKey:field];
                    
                    //根tableView的显示值：
                    
                    [self.tableViewDic setObject:self.namestr forKey:field];
                    
                }else{
                }
            }
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    [op setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        NSLog(@"totle %lld",totalBytesWritten);
        
    }];
    
//# endif
}

-(void)Goback
{
    if (_type == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        
        //http://27.115.23.126:5032/ashx/mobilenew.ashx?ac= SspCGBack &u=9& sspid =3
        
        NSString *str = [NSString stringWithFormat:@"ac=SspCGBack&u=%@&sspid=%@",self.uid,self.editModel.SspID];
        [RequestCenter GetRequest:str parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
      
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end





