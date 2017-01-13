//
//  XXPickerView.h
//  XXPickerViewDemo
//
//  Created by xiao on 17/1/10.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 PickerView 样式选择

 - XXPickerStyleTextPicker:     文本选择
 - XXPickerStyleDatePicker:     日期选择
 - XXPickerStyleDateTimePicker: 日期时间选择
 - XXPickerStyleTimePicker:     时间选择
 */
typedef NS_ENUM(NSUInteger, XXPickerStyle) {
    
    XXPickerStyleTextPicker,
    
    XXPickerStyleDatePicker,
    
    XXPickerStyleDateTimePicker,
    
    XXPickerStyleTimePicker,
};

extern NSString * const kXXPickerViewAttributesForNormalStateKey;

extern NSString * const kXXPickerViewAttributesForHighlightedStateKey;

@class XXPickerView;

/**
 XXPickerView delegate
 */
@protocol XXPickerViewDelegate <NSObject>

#pragma mark - PickerView 代理方法

@optional
- (void)xxPickerView:(XXPickerView *)pickerView didSelectTitles:(NSArray *)titles selectedRows:(NSArray *)rows;
- (void)xxPickerView:(XXPickerView *)pickerView didSelectDate:(NSDate *)date;
- (void)xxPickerView:(XXPickerView *)pickerView didChangeRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)xxPickerViewDidCancel:(XXPickerView *)pickerView;
- (void)xxPickerViewWillCancel:(XXPickerView *)pickerView;

@end

@interface XXPickerView : UIControl

- (instancetype)initWithTitle:(NSString *)title delegate:(id<XXPickerViewDelegate>)delegate;

@property (nonatomic,weak) id<XXPickerViewDelegate> delegate;

#pragma mark - PickerView 样式和属性

/**
 设置PickerView 样式。默认 XXPickerStyleTextPicker.
 */
@property (nonatomic,assign) XXPickerStyle pickerStyle;

/**
 设置toolBar颜色
 */
@property (nonatomic,strong) UIColor *toolbarTintColor UI_APPEARANCE_SELECTOR;

/**
 设置toolBar上按钮颜色
 */
@property (nonatomic,strong) UIColor *toolbarButtonColor UI_APPEARANCE_SELECTOR;

/**
 取消按钮 的属性字符字典
 */
@property (nonatomic,strong) NSDictionary *cancelButtonAttributes UI_APPEARANCE_SELECTOR;

/**
 确定按钮 的属性字符字典
 */
@property (nonatomic,strong) NSDictionary *doneButtonAttributes UI_APPEARANCE_SELECTOR;

#pragma mark - PickerView 显示与隐藏

/**
 显示
 */
- (void)show;

/**
 显示完成
 */
- (void)showWithCompletion:(void (^)(void))completion;

/**
 隐藏
 */
- (void)dismiss;

/**
 隐藏完成
 */
- (void)dismissWithCompletion:(void (^)(void))completion;

#pragma mark - PickerView 文本选择器

/**
 每个滚轮选择的字符。请使用字符数组。（无动画）
 */
@property (nonatomic,strong) NSArray *selectedTitles;

/**
 每个滚轮选择的字符。请使用字符数组。（可显示动画）
 */
- (void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated;


- (NSInteger)selectedRowInComponent:(NSInteger)component;

/**
 为每个滚轮设置文本数组。
 格式示例：
     @[
        @[ @"01", @"02", @"03", ], // 第一个滚轮显示的字符
        @[ @"11", @"12", @"13", ], // 第二个滚轮显示的字符
        @[ @"21", @"22", @"23", ]  // 第三个滚轮显示的字符
     ]
 */
@property (nonatomic,strong) NSArray *titlesForComponents;

/**
 滚轮的宽度
 */
@property (nonatomic,strong) NSArray *widthsForComponents;

/**
 滚轮文本的字体
 */
@property (nonatomic,strong) UIFont *pickerComponentsFont UI_APPEARANCE_SELECTOR;

/**
 PickerView 的背景颜色
 */
@property (nonatomic,strong) UIColor *pickerViewBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 PickerView 的颜色
 */
@property (nonatomic,strong) UIColor *pickerComponentsColor UI_APPEARANCE_SELECTOR;

/**
 ToolBar 标题字体
 */
@property (nonatomic,strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;

/**
 ToolBar 标题颜色
 */
@property (nonatomic,strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;

/**
 初始显示每个滚轮选择的行号（要先对滚轮赋值再选择）

 @param indexes  NSNumber 的数组
 @param animated 是否显示动画
 */
- (void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated;

/**
 范围滚轮（YES:是范围滚轮，NO:不是范围滚轮）
 */
@property (nonatomic,assign) BOOL isRangePickerView;

/**
 重新加载PickerView中的一个指定滚轮
 */
- (void)reloadComponent:(NSInteger)component;

/**
 重新加载滚轮
 */
- (void)reloadAllComponents;

#pragma mark - PickerView 日期时间选择器

/**
 设置选择的日期（无动画）
 */
@property (nonatomic,assign) NSDate *date;

/**
 设置选择的日期（可选择动画）
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

/**
 最小可选择的日期。(默认为nil)
 */
@property (nonatomic,retain) NSDate *minimumDate;

/**
 最大可选择的日期。(默认为nil)
 */
@property (nonatomic,retain) NSDate *maximumDate;

@end
