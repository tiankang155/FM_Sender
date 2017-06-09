//
//  RotateView.m
//  SDSliderViewDemo
//
//  Created by songjc on 16/10/3.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "RotateView.h"
#define KMaxRotation 6.906043
#define KMinRotation 0.600464
#define KSDSilderViewNewValue @"SDSilderViewNotificationCenter"

@interface RotateView ()

@property(nonatomic,assign)CGPoint startPoint;

@property(nonatomic,assign)CGPoint movePoint;

@property(nonatomic,assign)BOOL  direction;//YES为顺时针,NO为逆时针

@property(nonatomic,assign)CGFloat ownRotation;//自身的角度


@end

@implementation RotateView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        UIImage *rotateImage = [self reSizeImage:[UIImage imageNamed:@"旋钮主体"] toSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        
        self.backgroundColor = [UIColor colorWithPatternImage:rotateImage];
        
        [self loadAllValue];

    }

    return self;

}


//加载所有的数值
-(void)loadAllValue{

    self.ownRotation = M_PI/9*8;
    
    NSLog(@"%f",self.ownRotation);
    
    
    _minimumValue = 87.0;
    
    _maximumValue = 107.9;
    
    self.value = 87.0;

}

#pragma mark ---旋转实现 ----
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];


    _startPoint  = [touch locationInView:self];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];

    _movePoint  = [touch locationInView:self];
    
    CGFloat rotation = [self getAnglesWithThreePoint:_startPoint pointB:self.center pointC:_movePoint];
    

    //控制旋转的角度
   // if (KMinRotation<=  _ownRotation &&_ownRotation <= KMaxRotation) {
        
        //如果选择的角度超过预设最大值或者最小值,那么重新定义这个旋转的角度
        if (self.direction && self.ownRotation +rotation > KMaxRotation) {
            rotation = KMaxRotation - self.ownRotation;
        }
        
        if (!self.direction  && self.ownRotation -rotation < KMinRotation) {
            rotation =self.ownRotation- KMinRotation;

        }
        
        //对self进行仿射变换
        if (self.direction) {
            self.transform = CGAffineTransformRotate(self.transform, rotation);
            self.ownRotation  = self.ownRotation +rotation;

            
        }else{
            
            self.transform = CGAffineTransformRotate(self.transform, -rotation);
            self.ownRotation  = self.ownRotation -rotation;

        }
        
   // }
    [self valueTransformer];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    _block();

}
#pragma mark ----初始化的数值的等量变化----

-(void)valueTransformer{

    //计算所占总值的比例
    float proportionNumber;
    
    proportionNumber = (_ownRotation-KMinRotation)/(KMaxRotation -KMinRotation);


    _value = proportionNumber*(_maximumValue-_minimumValue) +_minimumValue;

    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:KSDSilderViewNewValue object:[NSNumber numberWithFloat:_value]];

}

//计算角度大小和角度的方向
-(CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC{
    CGFloat x1 = pointA.x - pointB.x;
    CGFloat y1 = pointA.y - pointB.y;
    CGFloat x2 = pointC.x - pointB.x;
    CGFloat y2 = pointC.y - pointB.y;
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    CGFloat angle = acos(x/sqrt(x*x+y*y));
    
    //方向
    if (x*y < 0) {
        self.direction = NO;
    }else{
        self.direction = YES;
    }
    return angle;
}

#pragma mark --- 设置图片尺寸 ---
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

#pragma mark --- 各个属性 ---

-(void)setMaximumValue:(float)maximumValue{

    _maximumValue = maximumValue;
    
    
    [self setValue:_value];

}


-(void)setMinimumValue:(float)minimumValue{

    _minimumValue = minimumValue;
    
    [self setValue:_value];


}

-(void)setValue:(float)value{

    _value = value;
    
    //计算所占总值的比例
    float proportionNumber;
    
    proportionNumber =(value-_minimumValue)/(_maximumValue-_minimumValue);

    //最终到达的角度值
    CGFloat newRocation = (KMaxRotation -KMinRotation) *proportionNumber +KMinRotation;
    
    
    CGFloat changRocation = newRocation - _ownRotation;
    
    _ownRotation = newRocation;

    self.transform = CGAffineTransformRotate(self.transform, changRocation);

    
    
    
    
}

@end
