//
//  SCBloodSugerModel.h
//  SinocareBle
//
//  Created by Yu Cheng on 16/2/17.
//  Copyright © 2016年 sinocare. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class SCBloodSugerModel
 @abstract 血糖类
 @discussion 接口返回的血糖数据为该类的对象
 @updated 2016-02-24
 */

@interface SCBloodSugerModel : NSObject

/*! 年*/
@property (nonatomic, assign)int year;
/*! 月*/
@property (nonatomic, assign)int month;
/*! 日 */
@property (nonatomic, assign)int day;
/*! 时*/
@property (nonatomic, assign)int hour;
/*! 分*/
@property (nonatomic, assign)int minute;
/*! 秒*/
@property (nonatomic, assign)int second;
/*! 样本类型 0血液 1质控液*/
@property (nonatomic, assign)int type;
/*! 血糖值，十进制整形，234，表示此数据除以10即为23。4mmol/L*/
@property (nonatomic, assign)int bloodSuger;
/*! 温度，十进制整形，表示225，此数据除以10即为22.5℃*/
@property (nonatomic, assign)int temperature;

@end