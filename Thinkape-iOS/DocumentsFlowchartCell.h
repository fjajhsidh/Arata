//
//  FlowchartCell.h
//  ThinkRun
//
//  Created by sh_leig on 14-6-8.
//  详情页面的流程图Cell
//

#import <UIKit/UIKit.h>

@interface DocumentsFlowchartCell : UITableViewCell

@property (nonatomic,strong)UILabel *lab_title;     //标题
@property (nonatomic,strong)UILabel *lab_line;      //线（向下箭头）
- (void)setStyle:(int)style;
@end
