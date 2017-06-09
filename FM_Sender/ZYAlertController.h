//
//  ZYAlertController.h
//  FM_Sender
//
//  Created by yarui on 2016/12/1.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAlertController : UIAlertController

@property(nonatomic,strong)UIColor*tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property(nonatomic,strong)UIColor*titleColor;/**< 标题的颜色 */
@property(nonatomic,strong)UIColor*messageColor;/**< 信息的颜色 */


@end


@interface ZYAlertAction : UIAlertAction

@property(nonatomic,strong)UIColor*textColor; /**< 按钮title字体颜色 */


@end
