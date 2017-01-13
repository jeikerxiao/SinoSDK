//
//  XXPickerView.m
//  XXPickerViewDemo
//
//  Created by xiao on 17/1/10.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import "XXPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "XXPickerViewViewController.h"
#import "XXPickerViewToolbar.h"

NSString * const kXXPickerViewAttributesForNormalStateKey = @"kXXPickerViewAttributesForNormalStateKey";
NSString * const kXXPickerViewAttributesForHighlightedStateKey = @"kXXPickerViewAttributesForHighlightedStateKey";

@interface XXPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) XXPickerViewToolbar        *pickerViewToolbar;
@property (nonatomic, strong) XXPickerViewViewController *pickerViewViewController;

@end

@implementation XXPickerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<XXPickerViewDelegate>)delegate {
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height = 216+44;// 键盘高度+工具条高度
    
    self = [super initWithFrame:rect];
    
    if (self) {
        // UIToolbar
        {
            _pickerViewToolbar = [[XXPickerViewToolbar alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 44)];
            _pickerViewToolbar.barStyle = UIBarStyleDefault;
            
            _pickerViewToolbar.cancelButton.target = self;
            _pickerViewToolbar.cancelButton.action = @selector(pickerCancelClicked:);
            
            _pickerViewToolbar.titleButton.title = title;
            
            _pickerViewToolbar.doneButton.target = self;
            _pickerViewToolbar.doneButton.action = @selector(pickerDoneClicked:);
            
            [self addSubview:_pickerViewToolbar];
        }
        
        // UIPickerView
        {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMaxY(_pickerViewToolbar.frame),
                                                                         CGRectGetWidth(_pickerViewToolbar.frame),
                                                                         216)];
            _pickerView.backgroundColor = [UIColor whiteColor];
            [_pickerView setShowsSelectionIndicator:YES];
            [_pickerView setDelegate:self];
            [_pickerView setDataSource:self];
            [self addSubview:_pickerView];
        }
        
        // UIDatePicker
        {
            _datePicker = [[UIDatePicker alloc] initWithFrame:_pickerView.frame];
            [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            _datePicker.frame = _pickerView.frame;
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            [_datePicker setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:_datePicker];
        }
        
        // 初始化设置
        {
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            [self setFrame:CGRectMake(0, 0, CGRectGetWidth(_pickerView.frame), CGRectGetMaxY(_pickerView.frame))];
            [self setPickerStyle:XXPickerStyleTextPicker];
            
            self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            _pickerViewToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        }
    }
    
    _delegate = delegate;
    
    return self;
}

#pragma mark - set方法

/**
 set方法中设置Picker样式
 */
- (void)setPickerStyle:(XXPickerStyle)pickerStyle {
    _pickerStyle = pickerStyle;
    
    switch (pickerStyle) {
        case XXPickerStyleTextPicker:
            [_pickerView setHidden:NO];
            [_datePicker setHidden:YES];
            break;
        case XXPickerStyleDatePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case XXPickerStyleDateTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case XXPickerStyleTimePicker:
            [_pickerView setHidden:YES];
            [_datePicker setHidden:NO];
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
            
        default:
            break;
    }
}

/**
 设置Picker背景颜色
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _pickerView.backgroundColor = backgroundColor;
    _datePicker.backgroundColor = backgroundColor;
}

/**
 设置 取消按钮 属性文本
 */
- (void)setCancelButtonAttributes:(NSDictionary *)cancelButtonAttributes {
    
    id attributesForCancelButtonNormalState = [cancelButtonAttributes objectForKey:kXXPickerViewAttributesForNormalStateKey];
    
    if (attributesForCancelButtonNormalState != nil &&
        [attributesForCancelButtonNormalState isKindOfClass:[NSDictionary class]]) {
        [_pickerViewToolbar.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForCancelButtonNormalState forState:UIControlStateNormal];
    }
    
    id attributesForCancelButtonHiglightedState = [cancelButtonAttributes objectForKey:kXXPickerViewAttributesForHighlightedStateKey];
    
    if (attributesForCancelButtonHiglightedState != nil &&
        [attributesForCancelButtonHiglightedState isKindOfClass:[NSDictionary class]]) {
        [_pickerViewToolbar.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForCancelButtonHiglightedState forState:UIControlStateHighlighted];
    }
    
}

/**
 设置 确认按钮 属性文本
 */
- (void)setDoneButtonAttributes:(NSDictionary *)doneButtonAttributes {
    
    id attributesForDoneButtonNormalState = [doneButtonAttributes objectForKey:kXXPickerViewAttributesForNormalStateKey];
    
    if (attributesForDoneButtonNormalState != nil &&
        [attributesForDoneButtonNormalState isKindOfClass:[NSDictionary class]]) {
        [_pickerViewToolbar.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForDoneButtonNormalState forState:UIControlStateNormal];
    }
    
    id attributesForDoneButtonHiglightedState = [doneButtonAttributes objectForKey:kXXPickerViewAttributesForHighlightedStateKey];
    
    if (attributesForDoneButtonHiglightedState != nil &&
        [attributesForDoneButtonHiglightedState isKindOfClass:[NSDictionary class]]) {
        [_pickerViewToolbar.cancelButton setTitleTextAttributes:(NSDictionary *)attributesForDoneButtonHiglightedState forState:UIControlStateHighlighted];
    }
    
}

/**
 设置toolbar颜色
 */
- (void)setToolbarTintColor:(UIColor *)toolbarTintColor {
    _toolbarTintColor = toolbarTintColor;
    
    [_pickerViewToolbar setBarTintColor:toolbarTintColor];
}

/**
 设置toolbar按钮颜色
 */
- (void)setToolbarButtonColor:(UIColor *)toolbarButtonColor {
    _toolbarButtonColor = toolbarButtonColor;
    
    [_pickerViewToolbar setTintColor:toolbarButtonColor];
}

/**
 设置标题字体
 */
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    _pickerViewToolbar.titleButton.font = titleFont;
}
/**
 设置标题颜色
 */
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    _pickerViewToolbar.titleButton.titleColor = titleColor;
}

#pragma mark - 取消、确定

- (void)pickerCancelClicked:(UIBarButtonItem *)barButton {
    
    if ([self.delegate respondsToSelector:@selector(xxPickerViewWillCancel:)]) {
        [self.delegate xxPickerViewWillCancel:self];
    }
    
    [self dismissWithCompletion:^{
        
        if ([self.delegate respondsToSelector:@selector(xxPickerViewDidCancel:)]) {
            [self.delegate xxPickerViewDidCancel:self];
        }
        
    }];
}

- (void)pickerDoneClicked:(UIBarButtonItem *)barButton {
    
    switch (_pickerStyle) {
        case XXPickerStyleTextPicker:
        {
            NSMutableArray *selectedTitles = [[NSMutableArray alloc]init];
            
            NSMutableArray *selectedRows = [[NSMutableArray alloc]init];
            
            for (NSInteger component = 0; component<_pickerView.numberOfComponents; component++) {
                NSInteger row = [_pickerView selectedRowInComponent:component];
                
                if (row != -1) {
                    [selectedTitles addObject:_titlesForComponents[component][row]];
                    [selectedRows addObject:@(row)];
                } else {
                    [selectedTitles addObject:[NSNull null]];
                    [selectedRows addObject:[NSNull null]];
                }
            }
            
            [self setSelectedTitles:selectedTitles];
            
            if ([self.delegate respondsToSelector:@selector(xxPickerView:didSelectTitles:selectedRows:)]) {
                
                [self.delegate xxPickerView:self didSelectTitles:selectedTitles selectedRows:selectedRows];
            }
        }
            break;
        case XXPickerStyleDatePicker:
        case XXPickerStyleDateTimePicker:
        case XXPickerStyleTimePicker:
        {
            [self setDate:_datePicker.date];
            
            [self setSelectedTitles:@[_datePicker.date]];
            
            if ([self.delegate respondsToSelector:@selector(xxPickerView:didSelectDate:)]) {
                
                [self.delegate xxPickerView:self didSelectDate:_datePicker.date];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self dismiss];
}

#pragma mark - 文本选择器

-(void)reloadComponent:(NSInteger)component
{
    [_pickerView reloadComponent:component];
}

-(void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}

-(void)setSelectedTitles:(NSArray *)selectedTitles
{
    [self setSelectedTitles:selectedTitles animated:NO];
}

-(NSArray *)selectedTitles
{
    if (_pickerStyle == XXPickerStyleTextPicker)
    {
        NSMutableArray *selectedTitles = [[NSMutableArray alloc] init];
        
        NSUInteger totalComponent = _pickerView.numberOfComponents;
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSInteger selectedRow = [_pickerView selectedRowInComponent:component];
            
            if (selectedRow == -1)
            {
                [selectedTitles addObject:[NSNull null]];
            }else {
                NSArray *items = _titlesForComponents[component];
                
                if ([items count] > selectedRow)
                {
                    id selectTitle = items[selectedRow];
                    [selectedTitles addObject:selectTitle];
                }
                else
                {
                    [selectedTitles addObject:[NSNull null]];
                }
            }
        }
        
        return selectedTitles;
    }else {
        return nil;
    }
}

-(void)setSelectedTitles:(NSArray *)selectedTitles animated:(BOOL)animated
{
    if (_pickerStyle == XXPickerStyleTextPicker)
    {
        NSUInteger totalComponent = MIN(selectedTitles.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = _titlesForComponents[component];
            id selectTitle = selectedTitles[component];
            
            if ([items containsObject:selectTitle])
            {
                NSUInteger rowIndex = [items indexOfObject:selectTitle];
                [_pickerView selectRow:rowIndex inComponent:component animated:animated];
            }
        }
    }
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    
    if (_pickerStyle == XXPickerStyleTextPicker) {
        
    }
    return 1;
}

-(void)selectIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    if (_pickerStyle == XXPickerStyleTextPicker)
    {
        NSUInteger totalComponent = MIN(indexes.count, _pickerView.numberOfComponents);
        
        for (NSInteger component = 0; component<totalComponent; component++)
        {
            NSArray *items = _titlesForComponents[component];
            NSUInteger selectIndex = [indexes[component] unsignedIntegerValue];
            
            if (selectIndex < items.count)
            {
                [_pickerView selectRow:selectIndex inComponent:component animated:animated];
            }
        }
    }
}

#pragma mark - 日期时间选择器

-(void)dateChanged:(UIDatePicker*)datePicker
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated
{
    _date = date;
    if (_date != nil)   [_datePicker setDate:_date animated:animated];
}

-(void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    
    _datePicker.minimumDate = minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    
    _datePicker.maximumDate = maximumDate;
}

#pragma mark - UIPickerView delegate/dateSource

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 如果有宽度值
    if (_widthsForComponents)
    {
        // 如果是 NSNumber 类
        if ([_widthsForComponents[component] isKindOfClass:[NSNumber class]])
        {
            CGFloat width = [_widthsForComponents[component] floatValue];
            
            // 如果宽度是0，则计算宽度值
            if (width == 0){
                return ((pickerView.bounds.size.width-20)-2*(_titlesForComponents.count-1))/_titlesForComponents.count;
            
            }else {
                // 否则直接返回宽度
                return width;
            }
        }else {
            // 计算宽度
            return ((pickerView.bounds.size.width-20)-2*(_titlesForComponents.count-1))/_titlesForComponents.count;
        }
    }else {   // 计算宽度
        return ((pickerView.bounds.size.width-20)-2*(_titlesForComponents.count-1))/_titlesForComponents.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_titlesForComponents count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_titlesForComponents[component] count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *labelText = [[UILabel alloc] init];
    if(self.pickerComponentsColor != nil) {
        labelText.textColor = self.pickerComponentsColor;
    }
    if(self.pickerComponentsFont == nil){
        labelText.font = [UIFont boldSystemFontOfSize:20.0];
    }else{
        labelText.font = self.pickerComponentsFont;
    }
    labelText.backgroundColor = [UIColor clearColor];
    [labelText setTextAlignment:NSTextAlignmentCenter];
    [labelText setText:_titlesForComponents[component][row]];
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isRangePickerView && pickerView.numberOfComponents == 3)
    {
        if (component == 0)
        {
            [pickerView selectRow:MAX([pickerView selectedRowInComponent:2], row) inComponent:2 animated:YES];
        }
        else if (component == 2)
        {
            [pickerView selectRow:MIN([pickerView selectedRowInComponent:0], row) inComponent:0 animated:YES];
        }
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if ([self.delegate respondsToSelector:@selector(xxPickerView:didChangeRow:inComponent:)]) {
        [self.delegate xxPickerView:self didChangeRow:row inComponent:component];
    }
}

#pragma mark - 显示、隐藏

/**
 显示
 */
- (void)show {
    [self showWithCompletion:nil];
}

/**
 显示完成
 */
- (void)showWithCompletion:(void (^)(void))completion {
    [_pickerView reloadAllComponents];
    
    _pickerViewViewController = [[XXPickerViewViewController alloc] init];
    [_pickerViewViewController showPickerView:self completion:completion];
}

/**
 隐藏
 */
- (void)dismiss {
    [_pickerViewViewController dismissWithCompletion:nil];
}

/**
 隐藏完成
 */
- (void)dismissWithCompletion:(void (^)(void))completion {
    [_pickerViewViewController dismissWithCompletion:completion];
}


@end
