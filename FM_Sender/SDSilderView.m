//
//  SDSilderView.m
//  SDSliderViewDemo
//
//  Created by songjc on 16/10/1.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "SDSilderView.h"
#import "RotateView.h"

@interface SDSilderView ()

@property(nonatomic,strong) RotateView *rotateView;

@end
@implementation SDSilderView



-(instancetype)initWithPosition:(CGPoint)positon viewRadius:(CGFloat)viewRadius{

    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, viewRadius*2, viewRadius*2);
        self.center = positon;
        
        [self loadRotateView];
        
        
        UIImage *backgroundImage = [self reSizeImage:[UIImage imageNamed:@"kedu_bj"] toSize:CGSizeMake(viewRadius*2, viewRadius*2)];
        self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        

    }

    return self;
}


+(instancetype)initWithPosition:(CGPoint)positon viewRadius:(CGFloat)viewRadius{

    SDSilderView *obj = [[SDSilderView alloc]initWithPosition:positon viewRadius:viewRadius];
    
    return obj;

}
#pragma mark --- 设置基本 ---

-(void)loadRotateView{

    
    _rotateView = [[RotateView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.1, self.frame.size.height*0.1, self.frame.size.width*0.8, self.frame.size.height*0.8)];
    
    __weak SDSilderView*wself=self;
    
    _rotateView.block=^{
        if ([wself.delegate respondsToSelector:@selector(sendFrequencyForPeripheral)]) {
            [wself.delegate sendFrequencyForPeripheral];
            
        }
    
    };
    _value = _rotateView.value;
    
    [self addSubview:_rotateView];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changNewValue) name:KSDSilderViewNewValue object:nil];
    
    

}



#pragma mark --- 设置图片尺寸 ---
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

#pragma mark ---旋钮主体的通知 ---

-(void)changNewValue{


    _value = _rotateView.value;
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(silderViewNewChangeValue:)]) {
        
        [self.delegate silderViewNewChangeValue:_value];
        
    }
    

}

#pragma mark --- 设置属性 ---
-(void)setMaximumValue:(float)maximumValue{
    
    _maximumValue = maximumValue;
    
    
    _rotateView.maximumValue = maximumValue;
    
}


-(void)setMinimumValue:(float)minimumValue{
    
    _minimumValue = minimumValue;
    
    _rotateView.minimumValue = minimumValue;
    
}

-(void)setValue:(float)value{
    
    _value = value;
    
    _rotateView.value = value;


    
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


@end
