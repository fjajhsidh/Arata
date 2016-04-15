//
//  Bianjiviewtableview.m
//  Thinkape-iOS
//
//  Created by admin on 16/1/1.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "Bianjiviewtableview.h"
#import "BijicellTableViewCell.h"
#import "CostLayoutModel.h"
#import "LayoutModel.h"
#import "AppDelegate.h"
#import "SDPhotoBrowser.h"
#import "LinkViewController.h"
#import <QuickLook/QLPreviewController.h>
#import <QuickLook/QLPreviewItem.h>
#import "CTToastTipView.h"
#import "ImageModel.h"
#import "UIImage+SKPImage.h"
#import "CTAssetsPickerController.h"
#import "Bianjito.h"
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

@interface Bianjiviewtableview ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SDPhotoBrowserDelegate,QLPreviewControllerDataSource,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,CalculatorResultDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,assign)int countu;
@property(nonatomic,strong)NSMutableArray *imagedatarry;
@property(nonatomic,strong)NSMutableArray *updatearry;

@property(nonatomic,strong)NSMutableDictionary *dict1;
@property(nonatomic,strong)UITextField *textstring;
@property(nonatomic,strong)UIButton *addImage;
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)DatePickerView *datePickerView;
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property(nonatomic,strong)NSMutableDictionary *tableviewDic;
@property(nonatomic,strong)CostLayoutModel *coster;
@property(nonatomic,assign)NSMutableArray *bigcoster;
@property(nonatomic)NSInteger tagCount;
@property(nonatomic,strong)CalculatorViewController *calculatorvc;
@property(nonatomic,strong)calculatorView *calculator;
@property(nonatomic,strong)KindsItemsView *kindsItemsView;
@end

@implementation Bianjiviewtableview
{
    NSString *delteImageIDS;
    UIView * bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    CGFloat lastConstant;
    BOOL isSinglal;
    CGFloat Textfield_y;
    CGFloat distances;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    Textfield_y=0;
    distances=0;
    self.title=@"新增明细";
    
    self.tableview.bounces=YES;
    
    _selectModel=[[KindsModel alloc] init];
    self.imagedatarry=[NSMutableArray array];
    self.updatearry =[NSMutableArray array];
    self.tableviewDic=[NSMutableDictionary dictionary];
    self.dict1 =[[NSMutableDictionary alloc]init];
    
    self.textfield=[[UITextField alloc] initWithFrame:CGRectMake(140, 5, 170, 30)];
    self.textfield.textAlignment=NSTextAlignmentCenter;
    self.textfield.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    _coster=[self.costArray safeObjectAtIndex:_indexto];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.indexpage = _indexto;
    self.calculatorvc=[[CalculatorViewController alloc]init];
    self.calculatorvc.delegate=self;
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, SCREEN_HEIGHT-60, SCREEN_WIDTH-20, 40)];
    
    [btn setTitle:@"新 增" forState:UIControlStateNormal];
    //设置边框为圆角
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5];
    
    //    [btn setBackgroundColor:[UIColor colorWithRed:0.70 green:0.189 blue:0.213 alpha:1.000]];
    [btn setBackgroundColor:[UIColor colorWithRed:44/225.0 green:70/225.0 blue:155/225.0 alpha:0.95]];
    
    [btn addTarget:self action:@selector(addtolist) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    //键盘的弹出和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowsd:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidensd:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardShowsd:(NSNotification *)notification{
    NSDictionary *keyBoardInfo = [notification userInfo];
    NSValue *aValue = [keyBoardInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = [aValue CGRectValue];
    CGFloat keyBoard_Y = rect.origin.y;
    if (Textfield_y> keyBoard_Y && Textfield_y!= 0) {
        distances =Textfield_y- keyBoard_Y + 100;
        self.view.frame = CGRectMake(0, -distances, self.view.frame.size.width, self.view.frame.size.height);
    }
}
- (void)keyboardHidensd:(NSNotification *)notification{
    Textfield_y= 0;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int number=0;
    CostLayoutModel *model = [self.costArray objectAtIndex:_indexto];
    if (model.fileds.count!=0) {
        number=model.fileds.count;
    }
    return number;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    {
        
        
        
        MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:indexPath.row];
        
        
        BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
     
            
        }
       
       
        
        cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
        
      
        
        cell.detailtext.text=[self.dict1 objectForKey:layoutModel.fieldname];
        
        if (layoutModel.ismust) {
            
            cell.detailtext.placeholder=@"请输入不能为空";
            
        }

        cell.detailtext.delegate= self;
        cell.detailtext.tag=indexPath.row;
        
        
        
        
        
    //最好一行的加号
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    
    
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSLog(@"tag值：%lu",textField.tag);
    
    self.textfield.tag=textField.tag;
    self.tagCount=textField.tag;
    MiXimodel *model2 =[self.coster.fileds safeObjectAtIndex:self.tagCount];
    NSString *catour =[NSString stringWithFormat:@"%@",model2.name];
    if ([catour rangeOfString:@"金额"].location!=NSNotFound) {
        CGRect frame=CGRectMake(0,[UIScreen mainScreen].bounds.size.height-250 , [UIScreen mainScreen].bounds.size.width, 250);
        self.calculatorvc.view.frame=frame;
        [self.view addSubview:self.calculatorvc.view];
        
        [self.kindsItemsView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
        
      
        return NO;

    }else{
        
        [self.calculatorView removeFromSuperview];
        
    }
// if (![model2.datasource isEqualToString:@"0"]&&![model2.sqldatatype isEqualToString:@"date"])
    if (![model2.datasource isEqualToString:@"0"]&&![model2.sqldatatype isEqualToString:@"date"]){
        
        isSinglal =model2.issingle;
        //调用隐藏点选框的操作：
        [self removeViewFromSuperview];
        
        [self kindsDataSource:model2];
        [self.dict1 setObject:textField.text forKey:model2.fieldname];
        return NO;
    }else{
        if ([model2.sqldatatype isEqualToString:@"date"]){
            [self.datePickerView removeFromSuperview];
            [self addDatePickerView:textField.tag date:textField.text];
            [self.dict1 setObject:textField.text forKey:model2.fieldname];
            
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
    
    
       [self.dict1 setValue:textField.text forKey:layoutModel.fieldname];
    return YES;
}
- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    
    NSInteger tag = view.tag;

//    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:tag];
    NSLog(@"键值：%@=%@",layoutModel.fieldname,name);
    
    [self.dict1 setObject:name forKey:layoutModel.fieldname];
    
    if (![layoutModel.datasource containsString:@"9999"]) {
        [self.dict1 setObject:ID forKey:[NSString stringWithFormat:@"%@%@",layoutModel.fieldname,@"_id"]];
    }
    NSLog(@"字典：%@",self.dict1);
    
    
    [view closed];
    [self.tableview reloadData];
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
  
    
    [self.calculatorvc.view removeFromSuperview];
    
    
    self.textfield.tag = textField.tag;
    
    MiXimodel *layoutModel = [self.coster.fileds safeObjectAtIndex:self.textfield.tag];
    
    
    [self.dict1 setObject:str forKey:layoutModel.fieldname];
    [self textFieldShouldEndEditing:textField];
    
    [self.tableview reloadData];
}

- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
    NSString *idStr = @"";
    NSString *nameStr = @"";
    NSInteger tag = view.tag;
    MiXimodel *layoutModel = [self.costArray safeObjectAtIndex:tag];
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
    
    [self.dict1 setObject:nameStr forKey:layoutModel.fieldname];
    [self.tableview reloadData];
}
- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
    self.datePickerView.tag = tag;
    NSLog(@"dddddddddddd%ld",(long)tag);
    
    __block Bianjiviewtableview *weaker=self;
    self.datePickerView.selectDateBack = ^(NSString *date){
    MiXimodel *layout =[weaker.costArray safeObjectAtIndex:tag];
        
   
    layout.fieldname = date;
    [weaker.dict1 setValue:date forKey:layout.fieldname];
    [weaker.datePickerView closeView:nil];
        
      };
    [self.view addSubview:self.datePickerView];
    
    
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
- (void)kindsDataSource:(MiXimodel *)model{
    NSString *str1 = [NSString stringWithFormat:@"datasource like %@",[NSString stringWithFormat:@"\"%@\"",model.datasource]];
    NSInteger tag= [self.costArr indexOfObject:model];
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
//加号方法

- (void)requestKindsDataSource:(MiXimodel *)model dataVer:(NSString *)Dataver{
 
    //http://localhost:53336/WebUi/ashx/mobilenew.ashx?ac=GetDataSource&u=9& datasource =400102&dataver=1.3
    NSInteger tag= [self.costArr indexOfObject:model];
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height =0;
    if (indexPath.row !=self.coster.fileds.count) {
        return 40;
        
        
    }
//    else
//    {
//        
//        NSInteger count = _imagedate.count;
//        CGFloat speace = 15.0f;
//        CGFloat imageWidth = (SCREEN_WIDTH - 4*speace) / 3.0f;
//
//        int row = count / 3+1;
//        height= (speace + imageWidth) * row;
//       
//
//        return height;
//        
//    }
    
     return 40;
}

- (CGFloat )fixStr:(NSString *)str
{
    CGRect frame = [str boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 115, 99999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return  frame.size.height >=0 ? frame.size.height : 20;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
   
    if (browser.tag == 11) {
        return _imagedatarry[index];
    }
    else
        return nil;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    if (browser.tag == 10) {
        NSLog(@"url %@",[_updatearry objectAtIndex:index]);
        NSString *model = [_updatearry objectAtIndex:index];
        return [NSURL URLWithString:model];
    }
    else
        return nil;
    
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return [NSURL fileURLWithPath:[[RequestCenter defaultCenter] filePath]];
}
//空字符传判断
- (NSString *)XMLParameter
{
    NSMutableString *xmlStr = [NSMutableString string];
    int i = 0;
    for (MiXimodel *layoutModel in self.coster.fileds) {
              NSString *value = [self.dict1 objectForKey:layoutModel.fieldname];
        if (layoutModel.ismust==1 && value.length == 0) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@不能为空",layoutModel.name]];
            return nil;
        }
        if (value.length != 0) {
            if (i != self.coster.fileds.count ) {
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


//点击新增：

- (void)addtolist {
    self.textfield.text=[self XMLParameter];
    if ([self.textfield.text isEqualToString:@""]||self.textfield.text==nil) {
        return;
    }
    
    
    //金额不一样：
    if ([self.dict1 objectForKey:@"ybmoney"] != nil) {
        if (![[self.dict1 objectForKey:@"billmoney"] isEqualToString:[self.dict1 objectForKey:@"ybmoney"]]) {
            [SVProgressHUD showErrorWithStatus:@"金额不一致，请重新输入"];
            return;
        }
    }
    
    
    
    BianJiViewController *bi =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    //新增
   
    bi.wenDicts = [NSMutableDictionary dictionaryWithDictionary:self.dict1];
    NSMutableArray *asd =[_costArr objectAtIndex:_indexto];
    NSMutableArray *count =[NSMutableArray arrayWithArray:asd];
    [count addObject:self.dict1];
    
    [_costArr replaceObjectAtIndex:_indexto withObject:count];
    bi.costData2 = _costArr;
   
    bi.dictarry=self.dictarry;
    bi.isaddka = YES;
    
//    bi.isaddMoney = YES;
    bi.addMoney = [bi.wenDicts objectForKey:@"billmoney"];
    bi.addIndex = _btnIndex;
    

    [self.navigationController popToViewController:bi animated:YES];
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
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
