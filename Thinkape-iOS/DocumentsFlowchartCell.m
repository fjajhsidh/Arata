//
//  FlowchartCell.m
//  ThinkRun
//
//  Created by sh_leig on 14-6-8.
//
//

#import "DocumentsFlowchartCell.h"
#import "MacroDefinition.h"

@implementation DocumentsFlowchartCell
@synthesize lab_title,lab_line;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        lab_title = [[UILabel alloc]init];
        lab_title.frame = CGRectMake((SCREEN_WIDTH-150)/2,0,150,40);
        //
        lab_title.backgroundColor = [UIColor colorWithRed:0.255 green:0.592 blue:0.125 alpha:1.000];
        lab_title.font = [UIFont systemFontOfSize:14];
        lab_title.textColor = [UIColor whiteColor];
        lab_title.textAlignment = NSTextAlignmentCenter;
        lab_title.layer.masksToBounds = YES;
        lab_title.layer.cornerRadius = 3;
        [self addSubview:lab_title];
        
        lab_line = [[UILabel alloc]init];
        lab_line.frame = CGRectMake((SCREEN_WIDTH-50)/2.0,40,50,30);
        lab_line.backgroundColor = [UIColor clearColor];
        lab_line.font = [UIFont boldSystemFontOfSize:30];
        lab_line.text = @"↓";
        lab_line.textColor = [UIColor colorWithRed:0.255 green:0.592 blue:0.125 alpha:1.000];
        lab_line.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab_line];
    }
    return self;
}

- (void)setStyle:(int)style{
    if (style == 1) {
        lab_title.frame = CGRectMake((SCREEN_WIDTH-50)/2,5,50,50);
        lab_title.backgroundColor = [UIColor colorWithRed:0.098 green:0.490 blue:0.722 alpha:1.000];
        lab_title.layer.masksToBounds = YES;
        lab_title.layer.cornerRadius = 25;
    }else{
        lab_title.frame = CGRectMake((SCREEN_WIDTH-50)/2,0,50,50);
        lab_title.backgroundColor =[UIColor colorWithRed:0.941 green:0.227 blue:0.192 alpha:1.000];
        lab_title.layer.masksToBounds = YES;
        lab_title.layer.cornerRadius = 25;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
