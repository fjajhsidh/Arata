//
//  MixiViewController.m
//  Thinkape-iOS
//
//  Created by admin on 16/1/5.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "MixiViewController.h"
#import "Bianjito.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "BijicellTableViewCell.h"
#import "AppDelegate.h"
#import "SubmitApproveViewController.h"
#import "DatePickerView.h"
#import "SDPhotoBrowser.h"
#import "KindsModel.h"
#import "KindsItemsView.h"
#import "KindsLayoutModel.h"
#import "KindsItemModel.h"
#import "KindsPickerView.h"
#import "DatePickerView.h"
#import "MiXimodel.h"
#import "CTToastTipView.h"
#import <QuickLook/QLPreviewItem.h>
#import <QuickLook/QLPreviewController.h>
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"
#import "ImageModel.h"
#import "DataManager.h"
#import "BianJiViewController.h"
#import "CalculatorViewController.h"
#import "calculatorView.h"
//#import "IQKeyboardManager.h"
@interface MixiViewController ()<UITextFieldDelegate,KindsItemsViewDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate,UIActionSheetDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,CalculatorResultDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


//试验用

@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property(nonatomic,strong)UITextField *textfield;

@property(nonatomic,strong)DatePickerView *datePickerView;
@property(nonatomic,strong)NSMutableDictionary *tableviewDic;
@property(nonatomic,strong)CostLayoutModel *coster;
@property(nonatomic,strong)NSMutableArray *Tositoma;
@property(nonatomic,strong)NSMutableArray *updateImage;
@property(nonatomic,strong)NSMutableArray *imageupdate;
@property(nonatomic,strong)NSMutableDictionary *datemeory;

@property(nonatomic,strong)NSMutableDictionary *editor;
@property(nonatomic,strong)NSMutableArray *bigCount;
@property(nonatomic,assign)NSInteger tagver;
@property(nonatomic,strong)CalculatorViewController *calculatorvc;
@property(nonatomic,strong)calculatorView *calculator;
@property(nonatomic,strong)KindsItemsView *kindsItemsView;
@end

@implementation MixiViewController
{
    NSString *delteImageIDS;
    UIView *bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    BOOL isSinglal;
    BOOL _wasKeyboardManagerEnabled;
    CGFloat Text_y;
    CGFloat distances;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    Text_y=0;
//    distances=0;
    self.title=@"修改明细";
  
    UIButton *iconb =[[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [iconb setBackgroundImage:[UIImage imageNamed:@"back3.png"] forState:UIControlStateNormal];
    [iconb addTarget:self action:@selector(pulltoreturn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back =[[UIBarButtonItem alloc] initWithCustomView:iconb];
    self.navigationItem.leftBarButtonItem=back;
    
    
    
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    self.textfield=[[UITextField alloc]init];
    
    _selectModel=[[KindsModel alloc] init];
    self.tableviewDic=[NSMutableDictionary dictionary];
    _imageupdate=[NSMutableArray array];
    _updateImage=[NSMutableArray array];
    _coster=[self.costatrraylost safeObjectAtIndex:_index];
    self.Tositoma =_coster.fileds;
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, SCREEN_HEIGHT-60, SCREEN_WIDTH-20, 40)];
    
    [btn setTitle:@"保 存" forState:UIControlStateNormal];
    //设置边框为圆角
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5];
    
  
    [btn setBackgroundColor:[UIColor colorWithRed:44/225.0 green:70/225.0 blue:155/225.0 alpha:0.95]];
    
    [btn addTarget:self action:@selector(savetolist) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    AppDelegate *appe = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.dict2 = [NSMutableDictionary dictionaryWithDictionary:appe.dict];
    self.calculatorvc=[[CalculatorViewController alloc]init];
    self.calculatorvc.delegate=self;
    self.textfield.delegate=self;
    //键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowDs:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidenDs:) name:UIKeyboardWillHideNotification object:nil];
}

//返回上一层
-(void)pulltoreturn
{
    NSArray *temArray =self.navigationController.viewControllers;
    for (UIViewController *ter in temArray) {
        if ([ter isKindOfClass:[Bianjito class]]) {
            [self.navigationController popToViewController:ter animated:YES];
        }
    }

}
- (void)keyboardShowDs:(NSNotification *)notification{
    NSDictionary *keyBoardInfo = [notification userInfo];
    NSValue *aValue = [keyBoardInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [aValue CGRectValue];
    CGFloat keyBoard_Y = rect.origin.y;
    if (Text_y > keyBoard_Y && Text_y!= 0) {
        distances =Text_y - keyBoard_Y + 100;
        self.view.frame = CGRectMake(0, -distances, self.view.frame.size.width, self.view.frame.size.height);
    }
}
- (void)keyboardHidenDs:(NSNotification *)notification{
   Text_y= 0;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // CostLayoutModel *model = [self.costatrraylost safeObjectAtIndex:_index];
    
    //    LayoutModel *layoutModel = [model.fileds safeObjectAtIndex:indexPath.row];
    //
    NSInteger height =0;
    if (indexPath.row != self.coster.fileds.count) {
       height= 40;
        
    }
    return height;
    
}
#pragma mark-提交
-(void)savetolist
{
    UITextField *text =[[UITextField alloc] init];
    self.textfield=text;
    self.textfield.text = [self XMLParameter];
    if ([self.textfield.text isEqualToString:@""]) {
        return;
    }
  
    
    //判断金额是否一致
    if ([self.dict2 objectForKey:@"ybmoney"] != nil) {
        if (![[self.dict2 objectForKey:@"billmoney"] isEqualToString:[self.dict2 objectForKey:@"ybmoney"]]) {
            [SVProgressHUD showErrorWithStatus:@"金额不一致，请重新输入"];
            return;
        }
    }
    
    
    
    
    
    BianJiViewController  *bi =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int indexa = app.indexcor;
    bi.oldDicts = [NSMutableDictionary dictionaryWithDictionary:self.dict2];
    NSMutableArray *coun =[_costarrdate objectAtIndex:_index];
    NSMutableArray *arr =[NSMutableArray arrayWithArray:coun];
   
    
    [arr replaceObjectAtIndex:indexa withObject:self.dict2];
    [_costarrdate replaceObjectAtIndex:_index withObject:arr];
    if (self.dictarry!=0) {
         bi.dictarry=self.dictarry;
    }
 
    bi.costData2 = _costarrdate;

    bi.isChanges=YES;
    bi.isTransform = YES;
    
    bi.changeIndex = _btnIndex;
    
    //金额
    double number = [[bi.oldDicts objectForKey:@"billmoney"] doubleValue] - [ _preMoney doubleValue ] + [_oldMoney doubleValue] ;
  
    bi.changeMoney = [NSString stringWithFormat:@"%.2lf",number];
    
   
    [self.navigationController popToViewController:bi animated:YES];

    
}

#pragma mark-UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    int number=0;
    CostLayoutModel *model = [self.costatrraylost objectAtIndex:_index];
    if (model.fileds.count!=0) {
        //减少一行
        number=model.fileds.count;
    }
    return number;
    
    
    
}
#pragma mark----cell重用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MiXimodel *layoutModel =[self.coster.fileds
                             safeObjectAtIndex:indexPath.row];
    BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
    }
    
    
    
    cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
    

    cell.detailtext.text= [self.dict2 objectForKey:layoutModel.fieldname];
    
   
    if (layoutModel.ismust==1) {
        cell.detailtext.placeholder=@"请输入不能为零";
    }

    cell.detailtext.delegate=self;
    cell.detailtext.tag=indexPath.row;

   //加号删除
    cell.selectionStyle=UITableViewCellAccessoryNone;

    return cell;
    
}

- (void)keyboardShowDsd:(NSNotification *)notification{
    NSDictionary *keyBoardInfo = [notification userInfo];
    NSValue *aValue = [keyBoardInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [aValue CGRectValue];
    CGFloat keyBoard_Y = rect.origin.y;
    if (Text_y > keyBoard_Y && Text_y!= 0) {
        distances =Text_y - keyBoard_Y + 100;
        self.view.frame = CGRectMake(0, -distances, self.view.frame.size.width, self.view.frame.size.height);
    }
}
- (void)keyboardHidenDsd:(NSNotification *)notification{
    Text_y= 0;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark-KindsItemsViewDelegate

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    
    NSInteger tag = view.tag;
    NSLog(@"%@=%@=%lu",name,ID,tag);
    NSLog(@"tag值%lu",self.textfield.tag);
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    NSLog(@"键值：%@=%@",layoutModel.fieldname,name);
    
    [self.dict2 setObject:name forKey:layoutModel.fieldname];
    if (![layoutModel.datasource containsString:@"9999"]) {
        [self.dict2 setObject:ID forKey:[NSString stringWithFormat:@"%@%@",layoutModel.fieldname,@"_id"]];
    }
    
    [view closed];
    [self.tableview reloadData];
}

#pragma mark-UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    self.textfield.tag=textField.tag;
   
   
    MiXimodel *model2 =[self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    NSString *cater =[NSString stringWithFormat:@"%@",model2.name];
    if ([cater rangeOfString:@"金额"].location !=NSNotFound) {
        
        CGRect frame=CGRectMake(0,[UIScreen mainScreen].bounds.size.height-250 , [UIScreen mainScreen].bounds.size.width, 250);
        self.calculatorvc.view.frame=frame;
        
        [self.view addSubview:self.calculatorvc.view];
        
        [self.kindsItemsView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
        
         return NO;
        
        
    }else{
        
        [self.calculatorView removeFromSuperview];
        
    }

    if (![model2.datasource isEqualToString:@"0"]&&![model2.sqldatatype isEqualToString:@"date"]) {
    
        isSinglal =model2.issingle;
        //调用隐藏点选框的操作：
        [self removeViewFromSuperview];
        
        [self kindsDataSource:model2];
        [self.dict2 setObject:textField.text forKey:model2.fieldname];
        return NO;
    }else{
        if ([model2.sqldatatype isEqualToString:@"date"]){
            [self.datePickerView removeFromSuperview];
            [self addDatePickerView:textField.tag date:textField.text];
            [self.dict2 setObject:textField.text forKey:model2.fieldname];
            
            return NO;
        }
        else{
            
            [self removeViewFromSuperview];
            return YES;
        }
    }
}


- (void)removeViewFromSuperview
{
    for (UIView *view0 in self.view.subviews) {
        if ([view0 isKindOfClass:[KindsItemsView class]]) {
            [view0 removeFromSuperview];
        }
    }
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:textField.tag];

    if ([layoutModel.sqldatatype isEqualToString:@"number"]&&textField.text.length>0) {
        
        unichar single = [textField.text characterAtIndex:0];
        if ((single>='0'&&single<='9')||single=='.') {
         
            if (single=='.') {
                [SVProgressHUD showInfoWithStatus:@"开头不能是小数点"];
                textField.text=@"";
                return NO;
            }
            
        }
    }
    
    
    [self.dict2 setObject:textField.text forKey:layoutModel.fieldname];
    
    return YES;
}
-(void)sender:(NSString *)str{
    
     UITextField *textField =[[UITextField alloc] init];
    textField = self.textfield;

    double number = [str doubleValue];
    if (number == 0){
        textField.text = @"";
        
    }else{
        textField.text = str;
        
    }
    NSLog(@"-----%@",str);
    
    [self.calculatorvc.view removeFromSuperview];
    
//    self.tagver=textField.tag;
//    self.textfield.tag = textField.tag;
    
   MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    
   
    [self.dict2 setObject:str forKey:layoutModel.fieldname];
    [self textFieldShouldEndEditing:textField];
    
      [self.tableview reloadData];
}
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
    
    
    __block MixiViewController * weaker = self;
    
    self.datePickerView.selectDateCallBack = ^(NSString *date){
        
       
        
    MiXimodel *layout =[weaker.coster.fileds safeObjectAtIndex:tag];
        
    [weaker.dict2 setObject:date forKey:layout.fieldname];
        
        
    [weaker.datePickerView closeView:nil];
    [weaker.tableview reloadData];
        
        
    };
    [self.tableview reloadData];
    
    [self.view addSubview:self.datePickerView];
    
    
}
- (void)kindsDataSource:(MiXimodel *)model{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.costatrraylost indexOfObject:model];
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
//判断输入值是否为空
- (NSString *)XMLParameter
{
    NSMutableString *xmlStr = [NSMutableString string];
    int i = 0;
    for (MiXimodel *layoutModel in self.coster.fileds) {
    NSString *value = [self.dict2 objectForKey:layoutModel.fieldname];
        
        if (layoutModel.ismust==1 && value.length == 0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.name]];
            return nil;
        }
        if (value.length != 0) {
            if (i != self.costarrdate.count ) {
                [xmlStr appendFormat:@"%@=\"%@\" ",layoutModel.fieldname,value];
            }
            else
            {
                [xmlStr appendFormat:@"%@=\"%@\"",layoutModel.fieldname,value];
            }
        }
        
        i++;
    }
    NSString *returnStr = [NSString stringWithFormat:@"<data %@></data>",xmlStr];
    NSLog(@"xmlStr : %@",returnStr);
    return returnStr;
}
- (void)requestKindsDataSource:(MiXimodel *)model dataVer:(NSString *)Dataver{
    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    NSInteger tag= [self.costatrraylost indexOfObject:model];
    [RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource]
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
    self.kindsItemsView = [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
    self.kindsItemsView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    self.kindsItemsView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    self.kindsItemsView.delegate = self;
    self.kindsItemsView.isSingl=isSinglal;
    
    self.kindsItemsView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(self.kindsItemsView.frame) / 2.0f);
    self.kindsItemsView.dataArray = arr;
    self.kindsItemsView.isSingl = isSinglal;
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


- (NSString *)uid
{
    return [DataManager shareManager].uid;
}

- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view
{
    
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
    MiXimodel *layoutModel = [self.costatrraylost safeObjectAtIndex:tag];
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
    
    [self.dict2 setObject:nameStr forKey:layoutModel.fieldname];
    [self.tableview reloadData];
}
- (void)hideCalculatorScreenText
{
    
    if (self.calculatorvc.view) {
        
        [self.calculatorvc.view removeFromSuperview];
    }
    
    
}

- (void)deleteBtnClick
{
    
    UITextField *textField =[[UITextField alloc] init];
    textField = self.textfield;
    
       textField.text = @"";
    
}
//
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

@end
