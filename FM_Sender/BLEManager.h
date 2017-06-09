//
//  BLEManager.h
//  uRemote
//
//  Created by yarui on 16/9/26.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <HomeKit/HomeKit.h>
@protocol BLEMangerDelegate <NSObject>

-(void)bleMangerConnectedPeripheral :(CBPeripheral *)_peripheral isConnect:(BOOL)isConnect;
-(void)bleMangerDisConnectedPeripheral :(CBPeripheral *)_peripheral;
-(void)bleMangerReceiveDataPeripheralData :(NSData *)data from_Characteristic :(CBCharacteristic *)curCharacteristic;

- (void) discoveryDidRefresh: (CBPeripheral *)peripheral RSSI:(NSNumber*)rssi advertisementData:(NSDictionary*)advertisementData;



@end


@interface BLEManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>




+(BLEManager*)shareInstance;
@property(nonatomic,copy)     NSMutableArray   *m_array_peripheral;
@property(nonatomic,strong)   CBCentralManager *m_manger;
@property(nonatomic,strong)   CBPeripheral     *m_peripheral;
@property(weak,nonatomic) id<BLEMangerDelegate> mange_delegate;


@property(assign,nonatomic)BOOL isOpenBLE;//是否开启了蓝牙
-(void)initCentralManger;


//开始扫描
- (void) scan;

//断开设备连接：

-(void)disconnect;
//发送数据
-(void)sppSendDataWithString:(NSString*)string;

-(NSString *)ToHex:(int)tmpid;

@end
