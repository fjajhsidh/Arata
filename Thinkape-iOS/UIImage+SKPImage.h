//
//  UIImage+SKPImage.h
//  Thinkape-iOS
//
//  Created by 刚刚买的电脑 on 15/11/21.
//  Copyright © 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SKPImage)
- (NSData *)thumbImage:(UIImage *)image;
// 设置图片方向
- (UIImage *)fixOrientation:(UIImage *)aImage;
@end
