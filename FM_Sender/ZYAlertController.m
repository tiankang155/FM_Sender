//
//  ZYAlertController.m
//  FM_Sender
//
//  Created by yarui on 2016/12/1.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#import "ZYAlertController.h"
#import <objc/runtime.h>


@interface ZYAlertController ()

@end

@implementation ZYAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    unsigned int count = 0;
    Ivar*ivars=class_copyIvarList([UIAlertController class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar=ivars[i];
        const char*keyChar=ivar_getName(ivar);
        NSString*ivarname=[NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        if ([ivarname isEqualToString:@"_attributedMessage"]&&self.message&&self.messageColor) {
            NSMutableAttributedString*attri=[[NSMutableAttributedString alloc]initWithString:self.message attributes:@{NSForegroundColorAttributeName:self.messageColor,NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
            [self setValue:attri forKey:@"attributedMessage"];
        }
        if ([ivarname isEqualToString:@"_attributedTitle"]&&self.titleColor&&self.titleColor) {
            NSMutableAttributedString*attribute=[[NSMutableAttributedString alloc]initWithString:self.title attributes:@{NSForegroundColorAttributeName:self.titleColor,NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
            [self setValue:attribute forKey:@"attributedTitle"];
            
        }
    }
    
    if (self.tintColor) {
        for (ZYAlertAction*action in self.actions) {
            if (!action.textColor) {
                action.textColor=self.tintColor;
                
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

@implementation ZYAlertAction

-(void)setTextColor:(UIColor *)textColor{
    
    _textColor=textColor;
    unsigned int count = 0;
    Ivar*ivars=class_copyIvarList([UIAlertAction class], &count);
    
    for (int i =0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char*keyChar=ivar_getName(ivar);
        NSString*ivarName=[NSString stringWithCString:keyChar encoding:NSUTF8StringEncoding];
        NSLog(@"%@",ivarName);
        if ([ivarName isEqualToString:@"_titleTextColor"]) {
            [self setValue:textColor forKey:@"titleTextColor"];
        }
    }
    
    
    
    
}

@end
