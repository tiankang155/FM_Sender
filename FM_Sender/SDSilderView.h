//
//  SDSilderView.h
//  SDSliderViewDemo
//
//  Created by songjc on 16/10/1.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>

//关于SDSilderView值的变化的通知名称
#define KSDSilderViewNewValue @"SDSilderViewNotificationCenter"


@protocol SDSilderViewDelegate <NSObject>

@optional

/**
 @author Don9
 
 通过这个代理方法可以实时的获得silderView的新值.
 
 @param newChangeValue silderView的新值
 */
-(void)silderViewNewChangeValue:(float)newChangeValue;


- (void)sendFrequencyForPeripheral;


@end


@interface SDSilderView : UIView

/**
 @author Don9
 
 一个类初始化方法,SDSilderView整体是一个圆形,所以我们只需要输入它的起始位置和它的半径.
 
 @param positon    SDSilderView的起始位置信息
 @param viewRadius SDSilderView的半径
 
 @return 根据起始位置坐标和半径信息创建SDSilderView.
 */
+(instancetype)initWithPosition:(CGPoint)positon viewRadius:(CGFloat)viewRadius;


@property(nonatomic) float value;//默认值为50;
@property(nonatomic) float minimumValue;//默认最小值值为0
@property(nonatomic) float maximumValue;//默认最大值值为100

@property(nonatomic,assign)id <SDSilderViewDelegate> delegate;

@end
