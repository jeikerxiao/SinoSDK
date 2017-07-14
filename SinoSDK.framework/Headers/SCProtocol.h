//
//  SCProtocol.h
//  SinocareBle
//
//  Created by Yu Cheng on 16/2/17.
//  Copyright © 2016年 sinocare. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "SCBloodSugerModel.h"

#ifndef SCProtocol_h
#define SCProtocol_h
/*!
 错误码 
 */
#define SC_RV_OK 0x00 //正确
#define SC_RV_E1 0x01 //E1错误
#define SC_RV_E2 0x02 //E2错误
#define SC_RV_E3 0x03 //E3错误
#define SC_RV_E6 0x06 //E6错误
#define SC_RV_HI 0x04 //HI错误，测试结果过高
#define SC_RV_LO 0x05 //LO错误，测试结果过低

#define SC_RV_CUSTOM_DATA 0x06 //数据错误
#define SC_RV_CUSTOM_VERIFY 0x07//没有访问权限、鉴权失败
#define SC_RV_CUSTOM_DISCONNECTED 0x08//无连接

/*!
 *  @brief 蓝牙状态发生变化的类型枚举
 **/

typedef NS_ENUM(NSInteger, SC_BLE_STATUS){
    SC_BLE_STATUS_UNKNOWN,      //未知错误
    SC_BLE_STATUS_POWERON,      //蓝牙打开
    SC_BLE_STATUS_POWEROFF,     //蓝牙关闭
    SC_BLE_STATUS_NOT_SUPPORT,  //不支持蓝牙4.0
    SC_BLE_STATUS_CONNECTED,    //蓝牙连接上设备（只是连接上，未获得通讯权限）
    SC_BLE_STATUS_DISCONNECTED, //蓝牙连接断开
    SC_BLE_STATUS_VERIFING,     //正在进行验证
    SC_BLE_STATUS_VERIFY_OK,    //权限验证通过，可以进行通讯了
    SC_BLE_STATUS_VERIFY_ERROR  //权限验证失败
};

/*!
 @brief 与sinocare设备通信状态枚举
 */
typedef NS_ENUM(NSInteger, SC_DEVICE_STATUS){
    SC_DEVICE_STATUS_FLASH = 1, //滴血灯闪烁
    SC_DEVICE_STATUS_BEGIN_TEST,//滴血完成开始测试
    SC_DEVICE_STATUS_SHUT_DOWN  //仪器关机
    //...
};

///该协议是蓝牙设备的协议
@protocol SCBLEInterfaceDelegate <NSObject>

@optional
/*!
 发现sinocare设备及信号强度
 @param peripheral 发现的设备
 @param RSSI 信号强度
 */
- (void)BleDidDiscover:(CBPeripheral *) peripheral macAddress:(NSString *)macAddress RSSI:(NSNumber *)RSSI;
/*!
 扫描设备结束回调
 */
- (void)BleScanFinished;
/*!
 是否连接成功，connectedWithDevice和connectedWithString的回调
 @param peripheral 连接成功返回设备对象
 */
- (void)BleDidConnected:(BOOL)connected peripheal:(CBPeripheral *) peripheral;

@required
/*!
 连接状态发生变化
 */
- (void)BleDidUpdateState:(SC_BLE_STATUS)bleStatus;

@end

/// 该协议是蓝牙设备主动发的数据
@protocol SCBLEInterfaceDataDelegate <NSObject>

/*!
 仪器返回错误码
 */
- (void)didReturnValue:(NSInteger)rv;

/*!
 sinocare设备返回状态码，eg.滴血符号闪烁/正在测试...
 */
- (void)didRecieveDeviceStatus:(SC_DEVICE_STATUS)status;

/*!
 仪器返回测试结果
 */
- (void)didRecieveTestResult:(SCBloodSugerModel *)bloodSuger;

@optional
/**
 仪器自动发的历史数据，微信协议
 @return YES 不再重发 NO 忽略，以后继续自动发
 */
- (BOOL)didRecieveHistoryResult:(SCBloodSugerModel *)bloodSuger;

@end


#endif /* SCProtocol_h */
