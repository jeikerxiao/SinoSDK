//
//  XXPickerViewViewController.h
//  XXPickerViewDemo
//
//  Created by xiao on 17/1/10.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXPickerView;

@interface XXPickerViewViewController : UIViewController

@property (nonatomic,strong)  XXPickerView *pickerView;

- (void)showPickerView:(XXPickerView *)pickerView completion:(void (^)(void))completion;
- (void)dismissWithCompletion:(void(^)(void))completion;

@end
