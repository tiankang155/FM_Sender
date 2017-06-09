//
//  ZYButton.m
//  FM_Sender
//
//  Created by yarui on 2016/12/1.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#import "ZYButton.h"
#define animateDelay 0.15   //默认动画执行时间
#define defaultScale 0.9    //默认缩小的比率
@implementation ZYButton

+ (ZYButton*)buttonWithType:(UIButtonType)type
                              frame:(CGRect)frame
                              title:(NSString *)title
                         titleColor:(UIColor *)color
                    backgroundColor:(UIColor *)backgroundColor
                    backgroundImage:(NSString *)image
                           andBlock:(ClickBlock)tempBlock{
    
    ZYButton * pushBtn = [ZYButton buttonWithType:type];
    pushBtn.frame = frame;
    [pushBtn setTitle:title forState:UIControlStateNormal];
    [pushBtn setTitleColor:color forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:backgroundColor];
    [pushBtn addTarget:pushBtn action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [pushBtn addTarget:pushBtn action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [pushBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    //给按钮的block赋值
    pushBtn.clickBlock = tempBlock;
    
    return pushBtn;
    
    
    
}
+ (ZYButton*)touchUpOutsideCancelButtonWithframe:(CGRect)frame
                                                  title:(NSString *)title
                                        backgroundImage:(NSString *)image
                                               andBlock:(ClickBlock)tempBlock
{
    ZYButton *pushBtn = [ZYButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = frame;
    pushBtn.layer.cornerRadius=5;
    pushBtn.layer.masksToBounds=YES;
    [pushBtn setTitle:title forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pushBtn setBackgroundColor:[UIColor grayColor]];
    [pushBtn addTarget:pushBtn action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [pushBtn addTarget:pushBtn action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [pushBtn addTarget:pushBtn action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside];
    [pushBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [pushBtn.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    //给按钮的block赋值
    pushBtn.clickBlock = tempBlock;
    
    return pushBtn;
}


//点击手势拖出按钮frame区域松开，响应取消
- (void)cancelEvent:(ZYButton *)btn
{
    [UIView animateWithDuration:animateDelay animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

//按钮的压下事件 按钮缩小
- (void)pressedEvent:(ZYButton *)btn
{
    //缩放比例必须大于0，且小于等于1
    CGFloat scale = (_buttonScale && _buttonScale <=1.0) ? _buttonScale : defaultScale;
    
    [UIView animateWithDuration:animateDelay animations:^{
        btn.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(ZYButton *)btn
{
    [UIView animateWithDuration:animateDelay animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        //执行动作响应
        if (self.clickBlock) {
            self.clickBlock();
        }
    }];
}
@end
