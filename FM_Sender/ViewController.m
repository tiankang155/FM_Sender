//
//  ViewController.m
//  FM_Sender
//
//  Created by yarui on 2016/11/16.
//  Copyright © 2016年 GeMei. All rights reserved.
//
static float zero = 40.0;
#import "ViewController.h"
#import "HZActivityIndicatorView.h"
#import "SDSilderView.h"
#import "HelpViewController.h"
#import "BLEManager.h"
#import "ZYAlertController.h"
#import "ZYButton.h"

@interface ViewController ()<SDSilderViewDelegate,BLEMangerDelegate>
{
    UIButton *frequencyBtn[4];
    NSInteger	frequencyBtn_tag;
    SDSilderView *silderView;
    CGFloat	  displayFrequency;
    NSTimer  *smartScan_timer;
    BOOL   smartScanning;
    NSTimer*searchTimer;
    HZActivityIndicatorView*scanActivityIndicator;
    NSMutableArray*peripheralArr;
    UILabel*connectLabel;
    UIImageView*connectImageView;
}
@property(nonatomic,strong)UILabel*disPlayLabel;
@property(nonatomic,strong)UIButton *minusButton;
@property(nonatomic,strong)UIButton *plusButton;
@property(nonatomic,strong)BLEManager *m_bleManger;

@property(nonatomic,strong)UIButton *infoButton;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden=YES;
    
   [self.navigationController.navigationBar setHidden:YES];
    //改变状态栏的颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(app_exit)
                                                 name:UIApplicationWillTerminateNotification
                                               object:app];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(app_exit)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:app];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //注册程序退出时通知,需要app保存国家设置为一致
    peripheralArr=[NSMutableArray array];

    
    [self setupUI];
    
    _m_bleManger=[BLEManager shareInstance];
    _m_bleManger.mange_delegate=self;
    searchTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTask) userInfo:nil repeats:NO];
    
    
    
    
    
    if(!scanActivityIndicator.isAnimating)
    {
        [scanActivityIndicator startAnimating];
    }
    
}
-(void)timerTask{
    
    if (_m_bleManger.isOpenBLE==YES) {
        
        [_m_bleManger.m_manger scanForPeripheralsWithServices:nil options:nil];
      
    }
    else{
        NSLog(@"蓝牙已关闭，请前往系统设置中开启蓝牙功能");
        [self creatAlertViewWith:@"提示" message:@"蓝牙已关闭，请前往系统设置中开启蓝牙功能" actionCount:1];
    }
}
-(void)discoveryDidRefresh:(CBPeripheral *)peripheral RSSI:(NSNumber *)rssi advertisementData:(NSDictionary *)advertisementData{
    
    if ([peripheral.name isEqualToString:@"BTC-030(BLE)"]) {
        
        NSLog(@"%@",peripheral);
        [searchTimer invalidate];
        searchTimer=nil;
        [peripheralArr addObject:peripheral];

        [self creatAlertViewWith:@"提示" message:@"发现设备，是否连接？（连接前请您确保系统蓝牙已连接上BTC026LM，否则会影响功能的使用！）" actionCount:2];
        
        
        
    }
    
    
}
-(void)setupUI{
    
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"background.jpg"];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:imageView];
    
    connectImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 35, 60, 60)];
    connectImageView.image=[UIImage imageNamed:@"connect_bg"];
    connectImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:connectImageView];
    
    scanActivityIndicator=[[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 30, 80, 80)];
    scanActivityIndicator.opaque = YES;
    scanActivityIndicator.steps = 18;
    scanActivityIndicator.finSize = CGSizeMake(7, 7);
    scanActivityIndicator.indicatorRadius = 28;
    scanActivityIndicator.stepDuration = 0.060;
    scanActivityIndicator.color = [UIColor whiteColor];
    scanActivityIndicator.cornerRadii = CGSizeMake(10, 10);
    [self.view addSubview:scanActivityIndicator];
    
    
    connectLabel=[[UILabel alloc]init];
    connectLabel.center=connectImageView.center;
    connectLabel.bounds=CGRectMake(0, 0, 60, 60);
    connectLabel.backgroundColor=[UIColor clearColor];
    connectLabel.text=@"搜索中...";
    connectLabel.textColor=[UIColor whiteColor];
    connectLabel.textAlignment=NSTextAlignmentCenter;
    connectLabel.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:connectLabel];
    
    
    CGFloat width = SCREEN_WIDTH-80;
    CGPoint point =self.view.center;
    CGFloat x=point.x;
    CGFloat y=point.y-65;
    
    UIImageView*slidBgView=[[UIImageView alloc]initWithFrame:CGRectMake(zero, zero, width, width)];
    slidBgView.center=CGPointMake(x, y);
    slidBgView.contentMode=UIViewContentModeScaleToFill;
    slidBgView.image=[UIImage imageNamed:@"yuan_bj"];
    [self.view addSubview:slidBgView];
  
    //刻度圆形
    silderView = [SDSilderView initWithPosition:CGPointMake(x, y)viewRadius:width/2];
    silderView.delegate=self;
    silderView.value = 87.0;
    [self.view addSubview: silderView];
    
    //显示频率label的坐标
    _disPlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(zero, zero, 108.0, 108.0)];
    _disPlayLabel.center=CGPointMake(x, y);
    _disPlayLabel.font = [UIFont boldSystemFontOfSize:40.0f];
    _disPlayLabel.backgroundColor = [UIColor clearColor];
    _disPlayLabel.textAlignment = NSTextAlignmentCenter;
    _disPlayLabel.text = @"87.0";
    _disPlayLabel.textColor = [UIColor brownColor];
    [self.view addSubview:_disPlayLabel];
    
    
    //创建/读取 上一次退出频率(文件)
    NSString *path2 = [self lastfrequencyPath];
    if (![FILE_M fileExistsAtPath:path2])
    {
        [FILE_M createFileAtPath:path2 contents:nil attributes:nil];
        
    }else
    {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path2];
        NSString*text=[array objectAtIndex:0];
        if (!text) {
            _disPlayLabel.text = @"87.0";
            silderView.value = 87.0;
        }else{
            _disPlayLabel.text = [array objectAtIndex:0];
            silderView.value = [[array objectAtIndex:0]floatValue];
        }
    
    }

    //加,减,搜索频率按钮
    CGFloat btnx = 10;
    CGFloat btny = SCREEN_HEIGHT-90-40-25-40;
    CGFloat btnWidth=(SCREEN_WIDTH-6*btnx)/2;
//   _minusButton=[self btnInitCustomBtnWithFrame:CGRectMake(btnx, btny, btnWidth, 45) imageName:@"" hlightName:nil title:@"一" tag:10 action:@selector(minusPressed)];
    _minusButton=[ZYButton touchUpOutsideCancelButtonWithframe:CGRectMake(btnx, btny, btnWidth, 45) title:@"一"  backgroundImage:@"bt2" andBlock:^{
        displayFrequency  = [[_disPlayLabel text] floatValue];
        displayFrequency -= 0.1;
        if (displayFrequency<87.0) {
            [self creatAlertViewWith:@"提示" message:@"已达到最小频率值，请调节+!" actionCount:1];
            return;
        }
        _disPlayLabel.text = [NSString stringWithFormat:@"%.1f",displayFrequency];
        silderView.value=displayFrequency;
        //发送数据
        [_m_bleManger sppSendDataWithString:_disPlayLabel.text];
    }];
    [self.view addSubview:_minusButton];
    
    
    
//    _plusButton=[self btnInitCustomBtnWithFrame:CGRectMake(btnx+btnWidth+4*btnx, btny, btnWidth, 45) imageName:@"" hlightName:nil title:@"+" tag:11 action:@selector(plusPressed)];
    
    _plusButton=[ZYButton touchUpOutsideCancelButtonWithframe:CGRectMake(btnx+btnWidth+4*btnx, btny, btnWidth, 45) title:@"+" backgroundImage:@"bt2" andBlock:^{
        displayFrequency = [[_disPlayLabel text] floatValue];
        displayFrequency += 0.1;
        if (displayFrequency>107.9) {
            [self creatAlertViewWith:@"提示" message:@"已达到最大频率值，请调节—!" actionCount:1];
            return;
            
        }
        _disPlayLabel.text = [NSString stringWithFormat:@"%.1f",displayFrequency];
        silderView.value=displayFrequency;
        //发送数据
        
        [_m_bleManger sppSendDataWithString:_disPlayLabel.text];
    }];
    [self.view addSubview:_plusButton];
    //保存频点按钮
    
    int width1=(SCREEN_WIDTH-5*10)/4;
    for (int i=0; i<4; i++) {
        int row =i%4;
        int col =i/4;
        float x=10+row*(width1+10);
        float y=btny+45+25+col*(width+10);
        frequencyBtn[i]=[self btnInitCustomBtnWithFrame:CGRectMake(x, y, width1, 45) imageName:@"bt1.png" hlightName:nil title:[NSString stringWithFormat:@"%d",i+1] tag:i action:@selector(frequencyPressed:)];
        
        [frequencyBtn[i] addTarget:self action:@selector(frequencyDown:) forControlEvents:UIControlEventTouchDown];
        [frequencyBtn[i] addTarget:self action:@selector(chancelSave) forControlEvents:UIControlEventTouchUpOutside];

    }
    
    //创建/读取 保存频点(文件)
    NSString *path1 = [self frequencyDataPath];
    if (![FILE_M fileExistsAtPath:path1])
    {
        [FILE_M createFileAtPath:path1 contents:nil attributes:nil];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@"1"];
        [array addObject:@"2"];
        [array addObject:@"3"];
        [array addObject:@"4"];
        [array writeToFile:path1 atomically:YES];
 
    }
    else
    {
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path1];
        [frequencyBtn[0] setTitle:[array objectAtIndex:0] forState:UIControlStateNormal];
        [frequencyBtn[1] setTitle:[array objectAtIndex:1] forState:UIControlStateNormal];
        [frequencyBtn[2] setTitle:[array objectAtIndex:2] forState:UIControlStateNormal];
        [frequencyBtn[3] setTitle:[array objectAtIndex:3] forState:UIControlStateNormal];
    			
    }

    //帮助按钮
    _infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    _infoButton.frame=CGRectMake(SCREEN_WIDTH-60, SCREEN_HEIGHT-60, 50, 50);
    [_infoButton addTarget:self action:@selector(infoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_infoButton];
    
    
    
    
    
}
#pragma mark -YMSlideDialViewDelegate

-(void)silderViewNewChangeValue:(float)newChangeValue{
    
    
   _disPlayLabel.text = [NSString stringWithFormat:@"%.1f",newChangeValue];

}
//旋转结束之后发送频率
-(void)sendFrequencyForPeripheral{
  NSLog(@"%@",_disPlayLabel.text);
  [_m_bleManger sppSendDataWithString:_disPlayLabel.text];
  
}
#pragma mark--加减自动扫描
//减按钮弹起时调用此方法
- (void)minusPressed{
    displayFrequency  = [[_disPlayLabel text] floatValue];
    displayFrequency -= 0.1;
    if (displayFrequency<87.0) {
        [self creatAlertViewWith:@"提示" message:@"已达到最小频率值，请调节+!" actionCount:1];
        return;
    }
    _disPlayLabel.text = [NSString stringWithFormat:@"%.1f",displayFrequency];
    silderView.value=displayFrequency;
    //发送数据
    [_m_bleManger sppSendDataWithString:_disPlayLabel.text];
    
}

//加按钮弹起时调用此方法
- (void)plusPressed{
    displayFrequency = [[_disPlayLabel text] floatValue];
    displayFrequency += 0.1;
    if (displayFrequency>107.9) {
        [self creatAlertViewWith:@"提示" message:@"已达到最大频率值，请调节—!" actionCount:1];
        return;
        
    }
    _disPlayLabel.text = [NSString stringWithFormat:@"%.1f",displayFrequency];
    silderView.value=displayFrequency;
     //发送数据
    
    [_m_bleManger sppSendDataWithString:_disPlayLabel.text];
}


#pragma mark--保存频率按钮

-(void)frequencyPressed:(id)sender{

  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveFrequency) object:nil];
    if (smartScanning==YES) {
        
    [self creatAlertViewWith:@"提示" message:@"Waitting smart scan frequency finished!" actionCount:1];
        
    }
    UIButton *btn = sender;
    NSString *btn_title = [btn titleForState:UIControlStateNormal];
    
    if([btn_title intValue]>4&&smartScanning==NO)
    {
        _disPlayLabel.text = btn_title;
        silderView.value=[btn_title floatValue];
        //点击按钮发送频率数据

        [_m_bleManger sppSendDataWithString:_disPlayLabel.text];
        
        
        
        
    }
    
}

-(void)frequencyDown:(id)sender{
    
  [self performSelector:@selector(saveFrequency) withObject:nil afterDelay:2];//打开保存////////////
   UIButton *btn =(UIButton*)sender;
   frequencyBtn_tag=btn.tag;
    
}
//按下达到3秒调用此方法
- (void)saveFrequency{
  [self changelLabel];//改变label显示明亮度
    switch (frequencyBtn_tag)
    {
        case 0:
            [frequencyBtn[0] setTitle:_disPlayLabel.text forState:UIControlStateNormal];
           
            break;
        case 1:
            [frequencyBtn[1] setTitle:_disPlayLabel.text forState:UIControlStateNormal];
            break;
        case 2:
            [frequencyBtn[2] setTitle:_disPlayLabel.text forState:UIControlStateNormal];
            break;
        case 3:
            [frequencyBtn[3] setTitle:_disPlayLabel.text forState:UIControlStateNormal];
            break;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:frequencyBtn[0].titleLabel.text];
    [array addObject:frequencyBtn[1].titleLabel.text];
    [array addObject:frequencyBtn[2].titleLabel.text];
    [array addObject:frequencyBtn[3].titleLabel.text];
    [array writeToFile:[self frequencyDataPath] atomically:YES];
    
}
//按下按钮后手移动至其它处使按钮touchupinside失效时调用此方法,取消保存频率线程
- (void)chancelSave
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveFrequency) object:nil];
}
- (void)changelLabel
{
    if (_disPlayLabel.alpha <= 0.3f)
    {
        _disPlayLabel.alpha = 1.0f;
        //取消延迟执行
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changelLabel) object:nil];
    }else
    {
        _disPlayLabel.alpha -= 0.1f;
        [self performSelector:@selector(changelLabel) withObject:nil afterDelay:0.02];
    }
    
}

#pragma mark--帮助按钮

-(void)infoButtonClick{
    HelpViewController*helpVc=[[HelpViewController alloc]init];
    helpVc.modalPresentationStyle=UIModalPresentationFullScreen;
   // UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:helpVc];带导航的模态
    
    [self presentViewController:helpVc animated:YES completion:nil];
    
}
#pragma mark--程序退出或进入后台保存数据

-(void)app_exit{
    
    NSString *path2 = [self lastfrequencyPath];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:_disPlayLabel.text];
    [array writeToFile:path2 atomically:YES];
    
}

#pragma mark 返回保存文件的路径
- (NSString*) frequencyDataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@",documentsDirectory,kFrequency];
}

- (NSString*) lastfrequencyPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/%@",documentsDirectory,kLastFrequency];
}

#pragma mark -customBtn

-(UIButton*)btnInitCustomBtnWithFrame:(CGRect)frame imageName:(NSString*)imageName hlightName:(NSString*)hlightName title:(NSString*)title tag:(NSInteger)tag action:(SEL)action{
    
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =frame;
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hlightName] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
      [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [self.view addSubview:button];
    return button;
    
}



-(void)creatAlertViewWith:(NSString*)title message:(NSString*)message actionCount:(NSInteger)actionCount{

ZYAlertController *alert=
[ZYAlertController alertControllerWithTitle:title
                                    message:message
                             preferredStyle:UIAlertControllerStyleAlert];
alert.tintColor = [UIColor redColor];
alert.messageColor=[UIColor brownColor];
    alert.titleColor=[UIColor redColor];
if (actionCount==1) {
    ZYAlertAction *action=[ZYAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
}
if (actionCount==2) {
   
    ZYAlertAction *action=[ZYAlertAction actionWithTitle:@"连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (((CBPeripheral*)[peripheralArr objectAtIndex:0]).state==2) {
            return ;
        }else{
         CBPeripheral *peripheral = [peripheralArr objectAtIndex:0];
         [_m_bleManger.m_manger connectPeripheral:peripheral options:nil];
        }
    }];
   
    [alert addAction:action];
}

[self presentViewController:alert animated:YES completion:nil];
    
}
#pragma -mark -----BLEMangerDelegate
-(void)bleMangerConnectedPeripheral:(CBPeripheral *)_peripheral isConnect:(BOOL)isConnec{
    NSLog(@"已经连接上了:%@,%ld",_peripheral.name,(long)_peripheral.state);
    connectLabel.text=@"已连接";
    connectLabel.textColor=[UIColor brownColor];
   [scanActivityIndicator stopAnimating];
   scanActivityIndicator.hidden=YES;
   connectImageView.image=[UIImage imageNamed:@"BTC026"];
    
}
-(void)bleMangerDisConnectedPeripheral:(CBPeripheral *)_peripheral{
    NSLog(@"设备断开");
    connectLabel.text=@"连接中";
    connectLabel.textColor=[UIColor whiteColor];
    [scanActivityIndicator startAnimating];
    scanActivityIndicator.hidden=NO;
    connectImageView.image=[UIImage imageNamed:@"connect_bg"];
   [_m_bleManger.m_manger connectPeripheral:_peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
}



@end
