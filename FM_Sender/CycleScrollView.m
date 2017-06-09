//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"

@implementation CycleScrollView
@synthesize csvDelegate;

#define DEVICE_IS_IPHONE5       ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE4       ([[UIScreen mainScreen] bounds].size.height == 480)
#define DEVICE_IS_IPHONE6       ([[UIScreen mainScreen] bounds].size.height == 667)
#define DEVICE_IS_IPHONE6PLUS   ([[UIScreen mainScreen] bounds].size.height == 1104)
#define DEVICE_IS_IPAD          ([[UIScreen mainScreen] bounds].size.height == 1024)
#define DEVICE_IS_IOS7          ([[[UIDevice currentDevice] systemVersion] floatValue] > 7)

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray type:(NSUInteger)type currentPage:(NSUInteger)page;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = frame;
        scrollDirection = direction;
        totalPage = pictureArray.count;
        curPage = page;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        
        if(type == 0)   //user guide
        {
            scrollView = [[UIScrollView alloc] initWithFrame:frame];
            //scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        }
        else if(type == 1)  //iphone5/iphone4s/iphone4
        {
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        }
        else if(type == 2)  //iphone 3gs
        {
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 250)];
        }
        
        if(DEVICE_IS_IOS7)
        {
            if(DEVICE_IS_IPHONE5)
            {
                scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-20, scrollView.frame.size.width, scrollView.frame.size.height);
            }
            else if(DEVICE_IS_IPHONE6)
            {
                scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-20, scrollView.frame.size.width, scrollView.frame.size.height);
            }
            else if(DEVICE_IS_IPHONE6PLUS)
            {
                scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-20, scrollView.frame.size.width, scrollView.frame.size.height);
            }
            else if(DEVICE_IS_IPAD)
            {
                scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-20, scrollView.frame.size.width, scrollView.frame.size.height);
            }
            else{
                scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-20, scrollView.frame.size.width, scrollView.frame.size.height-20);
            }
        }
        else{
            scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-20, scrollView.frame.size.width, scrollView.frame.size.height);
        }
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        [self addSubview:scrollView];
        
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        if(scrollDirection == CycleDirectionPortait) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }
        
        [self addSubview:scrollView];
        [self refreshScrollView];
    }
    
    return self;
}

- (void)refreshScrollView {
    
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0) {
        //快速清除subview方法
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        ObjectType obj：这里声明数组里面你放入的是什么类型的东西，不确定的话就直接id类型最靠谱。
//        NSUInteger idx：这是数组的下标
//        BOOL * _Nonnull stop：这是一个bool值，决定是否继续循环。如果有NO,继续循环下去。如果为YES ,停止循环。
//        [subViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//        }];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        imageView.image = [curImages objectAtIndex:i];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [imageView addGestureRecognizer:singleTap];
        
        // 水平滚动
        if(scrollDirection == CycleDirectionLandscape) {
            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        }
        // 垂直滚动
        if(scrollDirection == CycleDirectionPortait) {
            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
        }
        
        
        [scrollView addSubview:imageView];
    }
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last-1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    NSLog(@"did  x=%d  y=%d", x, y);
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            if(curPage <= totalPage)
            {
                curPage = [self validPageValue:curPage-1];
                [self refreshScrollView];
            }
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if(curPage <= totalPage)
    {
        NSLog(@"lib current page is %d", curPage);
        if ([csvDelegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]){
            [csvDelegate cycleScrollViewDelegate:self didScrollImageView:curPage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    
    NSLog(@"--end  x=%d  y=%d", x, y);
    
    if (scrollDirection == CycleDirectionLandscape) {
            [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([csvDelegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [csvDelegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}


@end
