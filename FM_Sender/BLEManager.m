//
//  BLEManager.m
//  uRemote
//
//  Created by yarui on 16/9/26.
//  Copyright © 2016年 GeMei. All rights reserved.
//

#import "BLEManager.h"
#import "ViewController.h"
static BLEManager *sharedBLEmanger=nil;
@interface BLEManager()

@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *reportCharacteristic;
@end

@implementation BLEManager
@synthesize m_manger;
@synthesize m_peripheral;
@synthesize m_array_peripheral;
@synthesize mange_delegate;

-(id)init
{
    self = [super init];
    if (self) {
        if (!m_array_peripheral) {
            
            m_manger = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
            
            m_array_peripheral = [[NSMutableArray alloc]init];
        }
    }
    return self;
}

+(BLEManager*)shareInstance{
    
    static dispatch_once_t token;
    dispatch_once(&token,^{
        sharedBLEmanger = [[BLEManager alloc]init];
    });
    return sharedBLEmanger;
    
    
}
-(void)scan{
    
    //nil表示扫描所有设备
    
    [self.m_manger scanForPeripheralsWithServices:nil options:nil];
    
}
-(void)disconnect{
    
    if (self.m_manger&&self.m_peripheral) {
        [self.m_manger cancelPeripheralConnection:self.m_peripheral];
    }
    
}
-(void)initCentralManger;
{
    m_manger = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch ([central state]) {
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStatePoweredOn:
            
            _isOpenBLE=YES;
           // [MYPerson showMessage:@"蓝牙已开启"];
            [m_manger scanForPeripheralsWithServices:nil options:nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ACTION_BLE_ON" object:nil userInfo:@{@"EXTRA_DATA":[NSNumber numberWithInt:CBCentralManagerStatePoweredOn]}];
            
            break;
        case CBCentralManagerStatePoweredOff:
            _isOpenBLE=NO;

            [m_manger  stopScan];
          
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ACTION_BLE_OFF" object:nil userInfo:@{@"EXTRA_DATA":[NSNumber numberWithInt:CBCentralManagerStatePoweredOff]}];
            
            break;
            
        default:
            break;
}

}

/**
 一旦扫描到外设就会调用

*/
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"%@",peripheral);
    NSString *localName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        localName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
      NSLog(@"%@",localName);
        
    }else{
        
        localName = peripheral.name;
        
    }

//    if (![self.m_array_peripheral containsObject: peripheral]&&[localName isEqualToString:@"BTC-030(BLE)"]) {
//        
//        self.m_peripheral=peripheral;
//        
//        [self.m_array_peripheral addObject:peripheral];
//        
//        
//        }

    if ([self.mange_delegate respondsToSelector:@selector(discoveryDidRefresh:RSSI:advertisementData:)]) {
    
       [self.mange_delegate discoveryDidRefresh:peripheral RSSI:RSSI advertisementData:advertisementData];
      }

}

/*
 //这个是主动调用了 [peripheral readRSSI];方法回调的RSSI，你可以根据这个RSSI估算一下距离
*/
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    NSLog(@"RSSI:%@",RSSI);
//    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:RSSI,@"RSSI",peripheral,@"peripheral", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateRSSINotification" object:nil userInfo:dic];
    
    
}

/**
 已经连接
 */
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral*)peripheral{
    
    
    [peripheral readRSSI];
    
    [m_manger stopScan];
    
    m_peripheral = peripheral;
    m_peripheral.delegate = self;
    
    
    if ([mange_delegate respondsToSelector:@selector(bleMangerConnectedPeripheral:isConnect:)]) {
        [mange_delegate  bleMangerConnectedPeripheral:peripheral isConnect:YES];
    }
// 直接一次读取外设的所有的
    [m_peripheral discoverServices:nil];
}

/*
 连接失败
*/
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    
    NSLog(@"连接到外设失败！%@ %@",[peripheral name],[error localizedDescription]);

}

/*
 断开连接
*/
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    


    if ([mange_delegate respondsToSelector:@selector(bleMangerDisConnectedPeripheral:)]) {
        [mange_delegate bleMangerDisConnectedPeripheral:peripheral];
        
    }
}

/**
 //这个函数一般不会被调用，他被调用是因为 peripheral.name 被修改了，才会被调用，有改名称的需求
*/
-(void)peripheralDidUpdateName:(CBPeripheral *)peripheral NS_AVAILABLE(NA, 6_0);
{
    
}

//发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@"%@",peripheral.services);
    
    for (CBService*service in [peripheral services]) {
       
         if ([service.UUID.UUIDString isEqualToString:@"6666"]){
         [peripheral discoverCharacteristics:nil forService:service];
        }
        if ([service.UUID.UUIDString isEqualToString:@"7777"]){
            [peripheral discoverCharacteristics:nil forService:service];
        }
    
    
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"%@",service.characteristics);
    
    
    for (CBCharacteristic *characteristics in service.characteristics)
    {
            if ([characteristics.UUID.UUIDString isEqualToString:@"8888"])
            {
                NSLog(@"Found RX characteristic"); //外设到APP
                self.rxCharacteristic = characteristics;
                
//通知添加成功，那么就可以实时的读取value[也就是说只要外设发送数据[一般外设的频率为10Hz]，代理就会调用此方法]
                [peripheral setNotifyValue:YES forCharacteristic:characteristics];
                [peripheral readValueForCharacteristic:characteristics];
            }

              if ([characteristics.UUID.UUIDString isEqualToString:@"8877"])
            {
                NSLog(@"Found Report characteristic"); //外设到APP
                self.reportCharacteristic = characteristics;
                
                [peripheral setNotifyValue:YES forCharacteristic:characteristics];
                [peripheral readValueForCharacteristic:characteristics];

            }

        }
}

/*
 //获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
*/
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    if (characteristic == self.reportCharacteristic) {
//     // NSString *string = [NSString stringWithUTF8String:[[characteristic value] bytes]];
//       NSData *data = [characteristic value];
//
//       Byte * resultByte = (Byte *)[data bytes];
//        
//       for(int i=0;i<[data length];i++)
//       NSLog(@"Byte==[%d] = %d\n",i,resultByte[i]);
//    }
//    
//    if (characteristic ==self.rxCharacteristic) {
//        NSData *data = [characteristic value];
//        
//        NSLog(@"data is %@", data);
//        
//    }
    if ([mange_delegate respondsToSelector:@selector(bleMangerReceiveDataPeripheralData:from_Characteristic:)]) {
        [mange_delegate bleMangerReceiveDataPeripheralData:characteristic.value from_Characteristic:characteristic];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (!error) {
        NSString*value1=[NSString stringWithFormat:@"%@ value:%@",characteristic,characteristic.value];
        NSLog(@"说明发送成功，characteristic.uuid为：%@",value1);
      
    }else{
        NSLog(@"发送失败了啊！characteristic.uuid为：%@",[characteristic.UUID UUIDString]);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //这个方法被调用是因为你主动调用方法： setNotifyValue:forCharacteristic 给你的反馈
    NSLog(@"你更新了对特征值:%@ 的通知",[characteristic.UUID UUIDString]);
    
}

#pragma mark send string to peripheral

-(void)sppSendDataWithString:(NSString*)string{

    if (self.reportCharacteristic==nil) {
        return;
    }
    if (self.m_peripheral.state==2) {
        float frequencyValue =[string floatValue];
        //   (103.5-76)*20
        float value =(frequencyValue-76)*20;
        NSLog(@"%.1f",value);
        NSString*str=[self ToHex:value];
        
        NSLog(@"%@",str);
        NSString*str1;
        if (str.length<3) {
        str1=[NSString stringWithFormat:@"01fe0000538110 0000 0000 00000%@",str];
            
        }else{
        str1=[NSString stringWithFormat:@"01fe0000538110 0000 0000 0000%@",str];
        }

        //  NSData*data=[self hexToBytes:str1];
        NSLog(@"%@",str1);
//      01fe0000538110 0000 0000 0000100
//      01fe0000538110 0000 0000 000FD
//      01fe0000538110 0000 0000 00000FD
        
//      01fe0000 53811000 00000000 00000100
//      01fe0000 53811000 00000000 0000fd
//      01fe0000 53811000 00000000 000000fd
        
        
        NSData*data=[self stringToHexData:str1];
     
        NSLog(@"%@",data);
        
        // 01fe0000538110   0000  0000  0000
        
        [self.m_peripheral writeValue:data forCharacteristic:self.reportCharacteristic type:CBCharacteristicWriteWithResponse];
    }
  
    
}

//将十进制转化为十六进制
-(NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    if(str.length == 1){
        return [NSString stringWithFormat:@"0%@",str];
    }else{
        return str;
    }
}

//字符串转data
-(NSData*)hexToBytes:(NSString *)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

-(NSData*)stringToHexData:(NSString *)hexStr
{
    unsigned long len = [hexStr length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [hexStr length] / 2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}
@end

