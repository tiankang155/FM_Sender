//
//  Header.h
//  FM_Sender
//
//  Created by yarui on 2016/11/16.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#ifndef Header_h
#define Header_h

//屏幕显示宽高
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define kIOSVersion  [[[UIDevice currentDevice] systemVersion] floatValue]
#define kIsIOS7 kIOSVersion >= 7
#define kCustomNaviBarHeight (kIsIOS7 ? 64 : 44)
#define DEVICE_IS_IPAD          ([[UIScreen mainScreen] bounds].size.height == 1024)

#define kFrequency		@"frequencyData.plist"
#define kLastFrequency  @"lastFrequency.plist"


//本地信息管理
#define UD [NSUserDefaults standardUserDefaults]
#define FILE_M [NSFileManager defaultManager]
//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#endif /* Header_h */
