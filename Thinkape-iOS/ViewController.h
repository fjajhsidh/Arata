//
//  ViewController.h
//  Thinkape-iOS
//
//  Created by admin on 16/4/7.
//  Copyright © 2016年 TIXA. All rights reserved.
//

#import "BillsDetailViewController.h"
#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "SimpleBarChart.h"
@interface ViewController : UIViewController<XYPieChartDelegate, XYPieChartDataSource,SimpleBarChartDataSource, SimpleBarChartDelegate>







@end
