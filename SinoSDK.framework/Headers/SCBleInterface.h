//
//  SCBleInterface.h
//  SinocareBle
//
//  Created by Yu Cheng on 16/2/17.
//  Copyright © 2016年 sinocare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCProtocol.h"

/*!
 @class SCBleInterface
 @abstract Sinocare蓝牙通讯接口
 @discussion 包括两部分，一部分是蓝牙连接操作接口，一部分是跟设备通信接口
 @updated 2016-02-24
 */

@interface SCBleInterface : NSObject

/*! 设置delegate，蓝牙扫描连接调用*/
@property (nonatomic, assign)id<SCBLEInterfaceDelegate> delegate;
/*! 设置dataSource，设备主动发调用*/
@property (nonatomic, assign)id<SCBLEInterfaceDataDelegate> dataDelegate;
/**
 是否是直连WL-1的设备，默认否
 */
@property (nonatomic, assign)BOOL isWL_1;
/*!
 *  获取Interface对象
 *
 *  @return SCBleInterface Obj
 */

+ (instancetype)sharedInterface;

/**
 *  初始化accessKey和secrectKey，在调用其他接口前确保先调用该接口，设置该值获取权限，否则无法调用其他接口
 */
- (void)setAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

///以下是蓝牙连接相关接口
/*!
 开始扫描sinocare外设
 @param sec 扫描时长
 @return 接口是否可用，SC_RV_OK或者SC_RV_CUSTOM_VERIFY，注意该返回值并不是扫描结果
 @see BleDidDiscover:macAddress:RSSI:

 */
- (NSInteger)scan:(NSTimeInterval)sec;

/**
 停止扫描
 */
- (void)stopScan;

/*!
 连接sinocare设备，扫描后连接设备
 @param peripheral 选中的设备
 @return 接口是否可用，SC_RV_OK或者SC_RV_CUSTOM_VERIFY，注意该返回值并不是连接是否成功的结果
 @see BleDidConnected:peripheal:

 */
- (NSInteger)connectedWithDevice:(CBPeripheral *)peripheral;

/*!
 连接sinocare设备,使用uuid直连
 @param uuid uuid字符串
 @return 接口是否可用，SC_RV_OK或者SC_RV_CUSTOM_VERIFY，注意该返回值并不是连接是否成功的结果
 @see BleDidConnected:peripheal:

 */
- (NSInteger)connectedWithString:(NSString *)uuid;

/*!
 断开蓝牙连接
 @return 接口是否可用，SC_RV_OK或者SC_RV_CUSTOM_VERIFY，注意该返回值并不是断开成功与否的返回值

 */
- (NSInteger)disConnected;



///以下是手机主动发出的信号

/*!
 读当前结果
 @param block 出参，参数1：rv 表示返回值 参数2：bloodSuger 血糖对象
 */
- (void)readCurrentData:(void(^)(NSInteger rv, SCBloodSugerModel *bloodSuger))block;

/*!
 读历史数据，分包读取，当finish为YES时表示读完
 @param block 出参，参数1：rv 表示返回值 参数2：bloodSugers 血糖对象数组 参数3：是否读完
 */

- (void)readHistoryData:(void(^)(NSInteger rv, NSArray<SCBloodSugerModel *> *bloodSugers, BOOL finished))block;

/*!
 清空历史数据
 @param block 出参，rv 表示返回值

 */
- (void)clearHistoryData:(void(^)(NSInteger rv))block;

/**
 设置校正码
 */
- (void)setAdjustmentCode:(NSInteger)code block:(void(^)(NSInteger rv))block;

/**
 矫正时间，矫正到分钟
 */
- (void)setTimeWithDate:(NSDate *)date block:(void(^)(NSInteger rv))block;


@end
