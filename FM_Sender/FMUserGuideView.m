//
//  FMUserGuideView.m
//  FM-Transmitter
//
//  Created by cxy on 14-6-3.
//
//

#import "FMUserGuideView.h"
#import "CycleScrollView.h"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@implementation FMUserGuideView
//@synthesize pageControl;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}


-(void)loadView {
    
    if(DEVICE_IS_IPAD)
    {
        //设置背景
        background = [[UIImageView alloc] initWithFrame:self.bounds];
        background.image = [UIImage imageNamed:@"iPad_Help.jpg"];
        background.backgroundColor = [UIColor clearColor];
        background.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y-20, background.frame.size.width, background.frame.size.height);
        [self addSubview:background];
    }
    else{
        NSMutableArray *picArray = [[NSMutableArray alloc] init];
        CycleScrollView *cycle;

        [picArray addObject:[UIImage imageNamed:@"状态一640x1136.jpg"]];
        [picArray addObject:[UIImage imageNamed:@"状态二640x1136.jpg"]];
        
        cycle = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                        cycleDirection:CycleDirectionLandscape
                                              pictures:picArray
                                                  type:0
                                           currentPage:1];
        cycle.backgroundColor = [UIColor clearColor];
        cycle.csvDelegate = self;
        [self addSubview:cycle];
    

        pageController = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-38)/2, SCREEN_HEIGHT-90, 38, 36)];
        pageController.numberOfPages = 2;
        pageController.currentPage = 0;
    
        [self addSubview:pageController];
    
    }
    UIButton*skipButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    skipButton.frame=CGRectMake(SCREEN_WIDTH-90, -10, 100, 100);
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [skipButton.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [self addSubview:skipButton];
}

- (void)skipIntroduction
{
    NSLog(@"skip button pressed!");
    
    self.block();
    
}


- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index {
    NSLog(@"current page is %d",index);
    
    pageController.currentPage = index-1;
    NSLog(@"current page controller is %ld",(long)pageController.currentPage);
}




@end
