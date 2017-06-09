//
//  FMUserGuideView.h
//  FM-Transmitter
//
//  Created by cxy on 14-6-3.
//
//

#import <UIKit/UIKit.h>
typedef void(^btnClickBlock)(void);


@interface FMUserGuideView : UIView<UIScrollViewDelegate>
{
    UIImageView *background;
    
    UIPageControl *pageController;
    
}

@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, copy) btnClickBlock block;
@end
