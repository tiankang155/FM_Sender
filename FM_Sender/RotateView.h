//
//  RotateView.h
//  SDSliderViewDemo
//
//  Created by songjc on 16/10/3.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^endBlock)(void);

@interface RotateView : UIView

@property(nonatomic,assign) float value;
@property(nonatomic,assign) float minimumValue;
@property(nonatomic,assign) float maximumValue;
@property(nonatomic,copy)endBlock block;

@end
