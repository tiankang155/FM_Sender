//
//  HelpViewController.m
//  FM_Sender
//
//  Created by yarui on 2016/11/17.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#import "HelpViewController.h"
#import "FMUserGuideView.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FMUserGuideView*helpView=[[FMUserGuideView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    helpView.block=^{
       [self dismissViewControllerAnimated:YES completion:nil]; 
    };
    
    [self.view addSubview:helpView];
    
    
}
-(void)btnClick{
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
