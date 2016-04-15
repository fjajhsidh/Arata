//
//  ScreenView.m
//  Calculator
//
//  Created by Ice on 15/9/2.
//  Copyright (c) 2015年 By.Li. All rights reserved.
//

#import "ScreenView.h"

@implementation ScreenView


//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"被点击");
//    if(self.text.length > 1)
//    {
//        self.text = [self.text substringToIndex: self.text.length-1];
//    }
//    else
//        self.text = @"0";
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
////    NSLog(@"移动中");
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    
    if (self = [super initWithFrame:frame]) {
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
////        btn.backgroundColor = [UIColor blackColor];
//        btn.frame = CGRectMake(20, 20, 24, 24);
//        
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [btn setBackgroundImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];
//    
//        [self addSubview:btn];
        
    }
    return self;
    
}

//
//- (void)btnClick:(UIButton *)sender
//{
//    if (self.delegate) {
//        [self.delegate  hideCalculator];
//        
//    }
//    
//}



@end
