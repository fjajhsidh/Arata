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

@interface MixiViewController ()<UITextFieldDelegate,KindsItemsViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *safete;
@property(nonatomic,strong)NSMutableDictionary *dict2;
//试验用
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomtrance;
@property (strong, nonatomic) KindsModel *selectModel;
@property (strong, nonatomic) KindsPickerView *kindsPickerView;
@property(nonatomic,strong)UITextField *textfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toptrance;
@property(nonatomic,strong)DatePickerView *datePickerView;


@end

@implementation MixiViewController
{
    NSString *delteImageID;
    UIView *bgView;
    CGFloat textFiledHeight;
    UIButton *sureBtn;
    UIButton *backBatn;
    UIView *infoView;
    BOOL isSinglal;
    CGFloat lastConstatant;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"新增明细";
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)] ]
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.dict2 =[[NSMutableDictionary alloc] init];
    self.textfield=[[UITextField alloc] initWithFrame:CGRectMake(140, 5, 170, 30)];
     self.textfield.textAlignment=NSTextAlignmentCenter;
     self.textfield.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
     _selectModel=[[KindsModel alloc] init];
    textFiledHeight=0.0f;
    self.bottomtrance.constant=50+textFiledHeight;
    
//    self.bottomtrance.constant=;
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(10, SCREEN_HEIGHT-60, SCREEN_WIDTH-20, 40)];
    
    
    [btn setTitle:@"保 存" forState:UIControlStateNormal];
    //设置边框为圆角
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:10];
    
    [btn setBackgroundColor:[UIColor colorWithRed:0.70 green:0.189 blue:0.213 alpha:1.000]];
    [btn addTarget:self action:@selector(savetolist) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn];
    
    self.bottomtrance.constant=lastConstatant;
 //wo
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    
    self.dict2=[NSMutableDictionary dictionaryWithDictionary:app.dict];
    
    
    if (self.kindsPickerView) {
        self.kindsPickerView = [[[NSBundle mainBundle] loadNibNamed:@"KindsPickerView" owner:self options:nil] lastObject];
        [self.kindsPickerView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        __block MixiViewController *weakSelf = self;
        self.kindsPickerView.selectItemCallBack = ^(KindsModel *model){
            
            weakSelf.selectModel = model;
            
        };
        [self.view addSubview:self.kindsPickerView];
    }

    
    
    
    [self initDict2];
    
}
-(void)initDict2{
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    
    for (NSString * key in app.dict) {
        [self.dict2 setObject:@"" forKey:key];
    }



}

-(void)requestminxi
{
    
}
-(void)savetolist
{
    
}

#pragma mark-UItableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    return model.fileds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    
    NSLog(@"self.costatrraylost啦啦%@",self.costatrraylost);
    MiXimodel *layoutModel =[model.fileds safeObjectAtIndex:indexPath.row];
     NSLog(@"细嗅%@=%@",layoutModel.name,layoutModel.fieldname);
    NSLog(@"细嗅=%lu",indexPath.row);
    
    BijicellTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"BijicellTableViewCell" owner:self options:nil] lastObject];
    }
    cell.textlabel.text=[NSString stringWithFormat:@"%@",layoutModel.name];
   
    
    //wo
    cell.detailtext.text=[self.dict2 objectForKey:layoutModel.fieldname];
    
    
    if (layoutModel.ismust) {
        cell.detailtext.placeholder=@"请输入不能为空";
        
    }
    if ([layoutModel.sqldatatype isEqualToString:@"number"]) {
        cell.detailtext.keyboardType =UIKeyboardTypeDecimalPad ;
    }
    
    cell.detailtext.tag=indexPath.row;
    cell.detailtext.delegate=self;

    if (cell.textlabel.text==nil) {
        cell.selectionStyle=UITableViewRowActionStyleNormal;
        
    }
    cell.selectionStyle=UITableViewCellAccessoryNone;
    
    
    return cell;
    
}


#pragma mark-KindsItemsViewDelegate

- (void)selectItem:(NSString *)name ID:(NSString *)ID view:(KindsItemsView *)view{
    
      NSInteger tag = view.tag;
    NSLog(@"%@=%@=%lu",name,ID,tag);
    NSLog(@"tag值%lu",self.textfield.tag);
    CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    
    MiXimodel *layoutModel = [model.fileds safeObjectAtIndex:self.textfield.tag];
    NSLog(@"键值：%@=%@",layoutModel.fieldname,name);
    
    [self.dict2 setObject:name forKey:layoutModel.fieldname];
    
    NSLog(@"字典：%@",self.dict2);
    
    
    
    [view closed];
    [self.tableview reloadData];
}
- (void)selectItemArray:(NSArray *)arr view:(KindsItemsView *)view{
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
    //    [self.XMLParameterDic setObject:idStr forKey:layoutModel.key];
    //    [self.tableViewDic setObject:nameStr forKey:layoutModel.key];
    [self.tableview reloadData];
}




#pragma mark-UItextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
     CostLayoutModel *model =[self.costatrraylost safeObjectAtIndex:_index];
    NSLog(@"tag值：%lu",textField.tag);
    
    self.textfield.tag=textField.tag;
    MiXimodel *model2 =[model.fileds safeObjectAtIndex:textField.tag];
    
    if (![model2.datasource isEqualToString:@"0"]) {
        
        
        isSinglal =model2.issingle;

        [self kindsDataSource:model2];
        
        return NO;
    }else
        if ([model2.sqldatatype isEqualToString:@"date"]){
            
//         [self readtoDb];
            
                self.textfield=textField;
            
          
//                        self.textfield.font=[UIFont systemFontOfSize:13];
//            
            
            
            if (self.textfield.text !=textField.text) {
                NSLog(@"22222222222222");
            }
            
            [self addDatePickerView:self.textfield.tag date:textField.text];
            
            
            
            return NO;
        }
        else
            
            return YES;
    
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
   MiXimodel *layoutModel = [self.costatrraylost safeObjectAtIndex:_index];
    
    //    if (![self isPureInt:textField.text] && [layoutModel.SqlDataType isEqualToString:@"number"] &&[textField.text rangeOfString:@"."].location&&![textField.text isEqualToString:@""]==NSNotFound) {
    //        [SVProgressHUD showInfoWithStatus:@"请输入数字"];
    //        textField.text = @"";
    //        _isHaven=NO;
    //    }
    
    if (![self isPureInt:textField.text] && [layoutModel.sqldatatype isEqualToString:@"number"] && textField.text.length != 0) {
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
            
            //            }
        }
    }
    
    
    
    
//    [self.XMLParameterDic setObject:textField.text forKey:layoutModel.key];
//    [self.tableViewDic setObject:textField.text forKey:layoutModel.key];
    
    
    return YES;
}
- (BOOL)isPureInt:(NSString*)string{
    //  [NSScanner scannerWithString:string];
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
- (void)addDatePickerView:(NSInteger)tag date:(NSString *)date{
    if (!self.datePickerView) {
        self.datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] lastObject];
        [self.datePickerView setFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
    }
    
    self.datePickerView.tag = tag;
    NSLog(@"dddddddddddd%ld",(long)tag);
    
    __block MixiViewController *weaker=self;
    self.datePickerView.selectDateBack = ^(NSString *date){
        
    //    NSInteger tag = weaker.datePickerView.tag;
//        LayoutModel *layout =[weaker.mainLayoutArray safeObjectAtIndex:tag];
//        
//        [weaker.tableViewDic setObject:date forKey:layout.fieldname];
//        
//        [weaker.datePickerView closeView:nil];
//        
//        [weaker.tableview reloadData];
        NSLog(@"数组%@",weaker.costatrraylost);
        
        MiXimodel *layout =[weaker.costatrraylost safeObjectAtIndex:tag];
        
//        [weaker.dict2 setObject:date forKey:layout.fieldname];
        layout.fieldname = date;
        NSLog(@"???????????????%@",layout.fieldname);
        
        [weaker.costatrraylost insertObject:layout atIndex:tag];
        
       
        
        
        
        
        //       [weaker.tableViewDic removeObjectForKey:layout.fieldname];
        //       [weaker.tableViewDic setObject:date forKey:layout.fieldname];
        
        //        [weakSelf.mainLayoutArray setValue:date forKey:layout.fieldname];
        //        textf.text=date;
        //        textf.text=date;
        NSLog(@"00000000000000%@",date);
        //
        
        weaker.textfield.text=date;
        
        
        //        NSLog(@"aaaaaaaaaaaaaaaa%@",textf.text);
        //        weaker.textfield.text=date;
        //        weaker.textfield.text=textf.text;
        
        [weaker.datePickerView closeView:nil];
        
        //        weakSelf.datestring = [NSMutableArray arrayWithObject:weakSelf.datetext];
        
    };
    [self.tableview reloadData];
    [self.view addSubview:self.datePickerView];
//    [self savetoDb];
    NSLog(@"====================%@",self.textfield.text);
    
    
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
- (void)requestKindsDataSource:(MiXimodel *)model dataVer:(NSString *)Dataver{
    //model.dataver
    //[RequestCenter GetRequest:[NSString stringWithFormat:@"ac=GetDataSourceNew&u=%@&datasource=%@&dataver=0",self.uid,model.datasource]
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
    KindsItemsView *itemView;
    itemView = [[[NSBundle mainBundle] loadNibNamed:@"KindsItems" owner:self options:nil] lastObject];
    itemView.frame = CGRectMake(50, 100, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
    itemView.center = CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0);
    itemView.delegate = self;
    itemView.isSingl=isSinglal;
    
    itemView.transform =CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT / 2.0 - CGRectGetHeight(itemView.frame) / 2.0f);
    itemView.dataArray = arr;
    //    itemView.isSingl = isSinglal;
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


- (NSString *)uid{
    return [DataManager shareManager].uid;
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

@end
