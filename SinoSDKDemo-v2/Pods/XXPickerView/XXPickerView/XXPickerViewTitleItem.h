//
//  XXPickerViewTitleBarButtonItem.h
//  XXPickerViewDemo
//
//  Created by xiao on 17/1/10.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXPickerViewTitleItem : UIBarButtonItem

/**
 PickerView 的标题字体。默认系统字体12号。
 */
@property (nonatomic,strong) UIFont *font;

/**
 PickerView 的标题颜色。
 */
@property (nonatomic,strong) UIColor *titleColor;

/**
 指定的初始化方法。初始化frame和标题
 */
- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;

/**
 不可用。请使用 initWithFrame:title:
 */
+ (instancetype)new NS_UNAVAILABLE;

/**
 不可用。请使用 initWithFrame:title:
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 不可用。请使用 initWithFrame:title:
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end
