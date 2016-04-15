//
//  BorrowView.m
//  Thinkape-iOS
//
//  Created by admin on 16/4/5.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "BorrowView.h"
#import "MacroDefinition.h"
#import "BFKit.h"

@interface BorrowView ()

{
    NSMutableArray *_selectArray;
//    UITableView *_tableView;
}

@end

@implementation BorrowView



- (void)awakeFromNib
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44, SCREEN_WIDTH-20, SCREEN_WIDTH-20) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    _dataArray = [NSMutableArray array];
    _selectArray = [[NSMutableArray alloc]init];

}


- (void)setModel:(BorrowModel *)model
{
    _model = model;
    
}

//点击取消
- (IBAction)btnClose:(id)sender
{
    [self close];
}

- (void)close
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT / 2.0 + CGRectGetHeight(self.frame) / 2.0f);
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
    
}

//点击确定
- (IBAction)sureBtn:(id)sender
{
    if (_selectArray.count > 0) {
        if (self.delegate) {
            [self.delegate  selectBorrowArray:_selectArray view:self];
        }
    }
    [self close];
    
}


- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
    }
    [_tableView reloadData];
}

#pragma mark    UITableViewDelegate  &&  UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];


    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    BorrowModel *model = _dataArray[indexPath.row];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.memo];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = model.totalmoney_show_id;
  
    for (BorrowModel *model in _selectArray) {
        if ([model.totalmoney_show_id isEqualToString:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    NSLog(@"%@",model.memo);
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorrowModel *model;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    model = [_dataArray  safeObjectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectArray removeObject:model];

    }else if (cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectArray addObject:model];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}


@end
