//
//  BianJiViewController.h
//  Thinkape-iOS
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UnApprovalModel.h"
#import "BillsModel.h"
#import "ParentsViewController.h"
#import "CGModel.h"
@interface BianJiViewController : ParentsViewController<UINavigationBarDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic,copy) NSString *billid;
@property (nonatomic,copy) NSString *programeId;
@property (nonatomic,copy) NSString *flowid;
@property (nonatomic,strong) BillsModel *bills;
@property (nonatomic,strong) CGModel *editModel;

@property (nonatomic , strong) NSString *sspid;
@property (nonatomic,strong) UnApprovalModel *unModel;
@property (nonatomic,copy) void (^reloadData)();
@property (nonatomic , copy) void (^callback)();
@property(nonatomic,assign)int selectedion;//记录单据界面
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSMutableDictionary *oldDicts;
@property(nonatomic,strong)NSMutableDictionary *wenDicts;

@property(nonatomic,strong) NSMutableArray *costData2;


@property (nonatomic,strong)NSMutableArray *bigCost;
//删除的字典
@property(nonatomic,strong)NSMutableDictionary *dictarry;



// 金额的传值

//是否改变了金额，改变的话更新btn上面的金额数
@property(nonatomic,assign)BOOL isChanges;
@property (nonatomic,assign)BOOL isTransform;
@property (nonatomic,assign)BOOL isAdditem;
@property(nonatomic,assign)BOOL isaddka;
@property(nonatomic,assign)BOOL isdeletes;
@property (nonatomic,assign)BOOL isaddMoney;

@property (nonatomic,assign) NSInteger changeIndex;
@property (nonatomic,copy)NSString *changeMoney;
@property (nonatomic,copy)NSString *oldMoney;

@property (nonatomic,copy)NSString *addMoney;
@property (nonatomic,assign)NSInteger *addIndex;


@property (nonatomic,strong)NSMutableArray *moneyArray;


@end
