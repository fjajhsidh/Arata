//
//  PFAdView.m
//  TIXAPlatform
//
//  Created by tixa tixa on 13-4-12.
//  Copyright (c) 2013年 tixa. All rights reserved.
//

#import "PFAdView.h"
#import "UIImageView+WebCache.h"
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "PFAd.h"
#import "WebViewController.h"

@interface PFAdView ()
{
    UIScrollView *scrollView;
    SMPageControl *pageControl;
    NSMutableArray *adImageViewList;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    
    int index;
    int currentIndex;
    NSInteger page;
    
    CGRect contentFrame;
    
    NSTimer *timer;
    
    UILabel *titleLabel;
    UILabel *pageLabel;
    
    NSString *picDomain;
}
@end

@implementation PFAdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentFrame = frame;
       picDomain = @"http://pic.medalart.cn/";
        
        [self addObserver:self forKeyPath:@"dataArray" options:NSKeyValueObservingOptionOld context:nil];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToWebView)];
        [scrollView addGestureRecognizer:tapGes];
        [self addSubview:scrollView];
        
        pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 25, frame.size.width, 25)];
        [pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageDot"]];
        [pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot"]];
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControl];
    }
    return self;
}


- (void)dealloc
{
    [timer invalidate];
    timer = nil;

    [self removeObserver:self forKeyPath:@"dataArray"];
}

#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"dataArray"]) {
        page = self.dataArray.count;
        pageControl.numberOfPages = page;
        float border = 0;
        BOOL showTitle = 0;
        BOOL showPageController = 1;
        pageControl.hidden = !showPageController;
        if (page > 1) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height);
            PFAd *ad = self.dataArray.lastObject;
            imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height)];
            NSString *imagePath = [NSString stringWithFormat:@"%@%@",picDomain,ad.imgPath];
            
            NSLog(@"----------------- ad.iconPath = %@",imagePath);
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            imageView1.userInteractionEnabled = YES;
            imageView1.layer.borderWidth = border;
            imageView1.layer.borderColor = [UIColor whiteColor].CGColor;
            
            ad = [self.dataArray objectAtIndex:0];
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(contentFrame.origin.x + scrollView.frame.size.width, 0, contentFrame.size.width, contentFrame.size.height)];
            imagePath = [NSString stringWithFormat:@"%@%@",picDomain,ad.imgPath];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            imageView2.userInteractionEnabled = YES;
            imageView2.layer.borderWidth = border;
            imageView2.layer.borderColor = [UIColor whiteColor].CGColor;
            
            ad = [self.dataArray objectAtIndex:1];
            imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(2 * scrollView.frame.size.width + contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height)];
            imagePath = [NSString stringWithFormat:@"%@%@",picDomain,ad.imgPath];
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            imageView3.userInteractionEnabled = YES;
            imageView3.layer.borderWidth = border;
            imageView3.layer.borderColor = [UIColor whiteColor].CGColor;
            
            currentIndex = 0;
            
            [scrollView addSubview:imageView1];
            [scrollView addSubview:imageView2];
            [scrollView addSubview:imageView3];
            
            CGPoint p = CGPointZero;
            p.x = scrollView.frame.size.width;
            [scrollView setContentOffset:p animated:NO];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self
                                                    selector:@selector(allArticlesMoveLeft)
                                                    userInfo:nil
                                                     repeats:YES];
        } else {
            PFAd *ad = self.dataArray.lastObject;
             NSString *imagePath = [NSString stringWithFormat:@"%@%@",picDomain,ad.imgPath];
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            imageView.userInteractionEnabled = YES;
            imageView.layer.borderWidth = border;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            [scrollView addSubview:imageView];
        }
        

        
        if (showTitle) {
            NSInteger titleIndex = pageControl.currentPage + 1;
            PFAd *ad = [self.dataArray objectAtIndex:pageControl.currentPage];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(titleIndex * scrollView.frame.size.width , contentFrame.size.height - 30, contentFrame.size.width, 30)];
            view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = ad.name;
            [view addSubview:titleLabel];
            
            pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 5.0, 40, 20)];
            pageLabel.backgroundColor = [UIColor clearColor];
            pageLabel.textColor = [UIColor whiteColor];
            pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",titleIndex,page];
            [view addSubview:pageLabel];
            
            [scrollView addSubview:view];
        }
        
    }
}

- (void)changePage:(id)sender
{
    if (pageControl.currentPage > currentIndex) {
        [self allArticlesMoveLeft];
    } else if (pageControl.currentPage < currentIndex) {
        [self allArticlesMoveRight];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [timer invalidate];
    timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
    CGFloat pageWidth = newScrollView.frame.size.width;
    // 0 1 2
    int temp = floor((newScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(allArticlesMoveLeft)
                                           userInfo:nil
                                            repeats:YES];
    if(temp == 1) {
        //用户拖动了，但是滚动事件没有生效
        return;
    } else if (temp == 0) {
        [self allArticlesMoveRight];
    } else {
        [self allArticlesMoveLeft];
    }
    
    CGPoint p = CGPointZero;
    p.x = pageWidth;
    [newScrollView setContentOffset:p animated:NO];
}


//将三个view都向右移动，并更新三个指针的指向，article2永远指向当前显示的view，article1是左边的，article3是右边的
- (void)allArticlesMoveRight
{
    //上一篇
    PFAd *ad = nil;
    pageControl.currentPage = index;
    
    currentIndex --;
    if (currentIndex < 0) {
        currentIndex = self.dataArray.count - 1;
    }
    pageControl.currentPage = currentIndex;
    index = currentIndex - 1;
    
    pageLabel.text = [NSString stringWithFormat:@"%d/%ld",currentIndex + 1,page];
    
    if (index < 0) {
        index = self.dataArray.count;
        ad = self.dataArray.lastObject;
    } else {
        ad = [self.dataArray objectAtIndex:index];
    }
    [imageView3 removeFromSuperview];
    imageView3 = nil;
    
    imageView3 = imageView2;
    imageView3.frame = CGRectMake(2 * scrollView.frame.size.width + contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height);
    
    imageView2 = imageView1;
    imageView2.frame = CGRectMake(scrollView.frame.size.width + contentFrame.origin.x, 0 , contentFrame.size.width, contentFrame.size.height);
    
    imageView1 = [[UIImageView alloc] init];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",picDomain,ad.imgPath];
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    imageView1.frame = CGRectMake(contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height);
    imageView1.layer.borderWidth = imageView2.layer.borderWidth;
    imageView1.layer.borderColor = [UIColor whiteColor].CGColor;
    [scrollView addSubview:imageView1];
    [scrollView sendSubviewToBack:imageView1];
    
}

- (void)allArticlesMoveLeft
{
    PFAd *ad = nil;
    currentIndex ++;
    if (currentIndex > self.dataArray.count - 1) {
        currentIndex = 0;
    }
    pageControl.currentPage = currentIndex;
    index = currentIndex + 1;
    
    pageLabel.text = [NSString stringWithFormat:@"%d/%d",index,page];
    
    if (index >= self.dataArray.count) {
        index = 0;
        ad = [self.dataArray objectAtIndex:0];
    } else {
        ad = [self.dataArray objectAtIndex:index];
    }
    [imageView1 removeFromSuperview];
    imageView1 = nil;
    
    imageView1 = imageView2;
    imageView1.frame = CGRectMake(contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height);
    
    imageView2 = imageView3;
    imageView2.frame = CGRectMake(scrollView.frame.size.width + contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height);
    
    imageView3 = [[UIImageView alloc] init];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",picDomain,ad.imgPath];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    imageView3.frame = CGRectMake(2 * scrollView.frame.size.width + contentFrame.origin.x, 0, contentFrame.size.width, contentFrame.size.height);
    imageView3.layer.borderWidth = imageView2.layer.borderWidth;
    imageView3.layer.borderColor = [UIColor whiteColor].CGColor;
    [scrollView addSubview:imageView3];
    [scrollView sendSubviewToBack:imageView3];
}

// tap method
-(void)tapToWebView
{
    NSLog(@"tap !!");
    PFAd * ad = nil;
    if (currentIndex < self.dataArray.count)
    {
        ad = [self.dataArray objectAtIndex:currentIndex];
    }
    if (ad.link.length)
    {
        WebViewController * webViewController = [[WebViewController alloc]init];
        //webViewController.linkUrlString = ad.urlString;
        //webViewController.modularName = ad.name;
        
        
//        webViewController.urlStr = ad.link;
//        webViewController.club = NO;
//        webViewController.loadHtml = NO;
//        webViewController.titleStr = ad.name;
        [self.parent.navigationController pushViewController:webViewController animated:YES];
    }
    else
    {
//        [[TKAlertCenter defaultCenter]postAlertWithMessage:@"暂无广告链接"];
    }
    
}

@end
