//
//  ViewController.m
//  Thinkape-iOS
//
//  Created by admin on 16/4/7.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MacroDefinition.h"
#import <NSMutableArray+BFKit.h>
@interface ViewController ()
@property(nonatomic,strong)NSMutableArray *Criclearray;
@property(nonatomic,strong)NSArray *Criclecolour;

@property(nonatomic,strong)XYPieChart *twoCircle;
@property(nonatomic,strong)NSMutableArray *twoCsarry;
@property(nonatomic,strong)XYPieChart *cirleview;
@property(nonatomic,strong)NSArray *values;
@property(nonatomic,strong)NSArray *haikei;
@property(nonatomic,strong)SimpleBarChart *chart;
@property(nonatomic,assign)NSInteger currentbar;

@end

@implementation ViewController
{
    UIScrollView *view;
}
//必须加载元饼图
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cirleview reloadData];
    [self.twoCircle reloadData];
    [self.chart reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    view =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    view.contentSize = CGSizeMake(view.frame.size.width, 1500);
    
    view.bounces=YES;
    
    _Criclearray =[NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i< 2; i++) {
        NSNumber *number = [NSNumber numberWithInt:rand()%60+20];
        [_Criclearray addObject:number];
        
    }
    
    _twoCsarry = [NSMutableArray arrayWithCapacity:3];
    for (int i=0; i<2; i++) {
        NSNumber *numer =[NSNumber numberWithInt:rand()%60+20];
        [_twoCsarry addObject:numer];
        
    }
    
    self.cirleview = [[XYPieChart alloc] initWithFrame:CGRectMake(10, 20, view.frame.size.width-150, view.frame.size.height-160)];
    
   
        
        
    self.cirleview.dataSource = self;
    self.cirleview.delegate=self;
    self.cirleview.startPieAngle = M_PI_2;
    self.cirleview.pieCenter =CGPointMake(view.center.x, 120);
    self.cirleview.animationSpeed =1.0;
    self.cirleview.showPercentage= YES;
    
    self.cirleview.tag = 200;
        
        
        //label会到外面去
    self.cirleview.labelRadius = 90;
    self.cirleview.labelColor = [UIColor blackColor];
    self.twoCircle = [[XYPieChart alloc] initWithFrame:CGRectMake(10, 250, view.frame.size.width-150, view.frame.size.height-160)];
    
    
    self.twoCircle.dataSource = self;
    self.twoCircle.delegate=self;
     self.twoCircle.startPieAngle = M_PI_2;
    self.twoCircle.pieCenter =CGPointMake(view.center.x,250);
    self.twoCircle.animationSpeed =1.0;
    self.twoCircle.showPercentage= YES;
    self.twoCircle.tag=100;
    
    
    
   // label会到外面去
    self.twoCircle.labelRadius = 90;
    
    self.twoCircle.labelColor = [UIColor blackColor];
    self.twoCircle.layer.cornerRadius = 90;
    
    
        self.Criclecolour = [NSArray arrayWithObjects:
                             [UIColor colorWithRed:123/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                             [UIColor colorWithRed:69/255.0 green:98/255.0 blue:166/255.0 alpha:1],nil];
    
    
    [self pieChart:self.cirleview didSelectSliceAtIndex:1];
    
    
    [view addSubview:self.twoCircle];
    [view addSubview:self.cirleview];
    //柱状图
    [self Histogram];
    [self.view addSubview:view];
    
    
    
}
-(void)Histogram
{
    self.values = @[@30, @45, @44, @60, @95, @2, @8, @9];
    self.haikei = [NSMutableArray arrayWithCapacity:0];
    self.haikei = @[[UIColor blueColor], [UIColor redColor], [UIColor blackColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor greenColor]];
    self.currentbar = 0;
    CGRect chartFrame				= CGRectMake(10,
                                                650,
                                                 320.0,
                                                 300.0);
    self.chart = [[SimpleBarChart alloc] initWithFrame:chartFrame];
   // self.chart.center = CGPointMake(view.frame.size.width / 2.0, self.);
    
    
    self.chart.dataSource=self;
    self.chart.delegate=self;
    self.chart.barShadowOffset = CGSizeMake(2.0, 1.0);
    self.chart.animationDuration =1.0;
    self.chart.barShadowColor = [UIColor blueColor];
    self.chart.barShadowAlpha = 0.5;
    self.chart.barShadowRadius = 1.0;
    self.chart.barWidth= 18.0;
    self.chart.xLabelType = SimpleBarChartXLabelTypeVerticle;
    self.chart.incrementValue=10;
    self.chart.barTextType = SimpleBarChartBarTextTypeTop;
    self.chart.barTextColor = [UIColor whiteColor];
    self.chart.gridColor = [UIColor grayColor];
    [view addSubview:self.chart];
    
    
}
#pragma mark------饼状图
-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    int a;
    if (pieChart.tag==100) {
        a= _Criclearray.count;
    }
    if (pieChart.tag ==200) {
        a= _Criclearray.count;
    }
    return a;
    
}
-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    CGFloat a;
    if (pieChart.tag==100) {
        a = [[_Criclearray objectAtIndex:index] intValue];
    }
    if (pieChart.tag ==200) {
        a =  [[_Criclearray objectAtIndex:index] intValue];    }
    
//    else
//    {
//        a = [[_twoCsarry objectAtIndex:index] intValue];
//    }
    return a;
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
    UIColor *addc;
    if (pieChart.tag ==100) {
        addc =[self.Criclecolour objectAtIndex:(index%self.Criclecolour.count)];
    }
    if (pieChart.tag ==200) {
        addc =[self.Criclecolour objectAtIndex:(index%self.Criclecolour.count)];
    }
    return addc;
}

-(void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    if (pieChart.tag ==100) {
        
    }
    if (pieChart.tag==2) {
        
    }

    
    NSLog(@";");
    
}
-(void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    if (pieChart.tag ==100) {
        
    }
    if (pieChart.tag==200) {
        
    }
    
      NSLog(@"a");
}
-(void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    if (pieChart.tag ==100) {
        
    }
    if (pieChart.tag==200) {
        
    }

  
}
#pragma mark-----柱状图
-(NSUInteger)numberOfBarsInBarChart:(SimpleBarChart *)barChart
{
    return self.values.count;
}
-(CGFloat)barChart:(SimpleBarChart *)barChart valueForBarAtIndex:(NSUInteger)index
{
    return [[self.values objectAtIndex:index] floatValue];
    
}
-(NSString *)barChart:(SimpleBarChart *)barChart textForBarAtIndex:(NSUInteger)index
{
    return [[self.values objectAtIndex:index] stringValue];
    
}
-(NSString *)barChart:(SimpleBarChart *)barChart xLabelForBarAtIndex:(NSUInteger)index
{
    return [[self.values objectAtIndex:index] stringValue];
}
-(UIColor *)barChart:(SimpleBarChart *)barChart colorForBarAtIndex:(NSUInteger)index
{
    return [self.haikei objectAtIndex:self.currentbar];
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
