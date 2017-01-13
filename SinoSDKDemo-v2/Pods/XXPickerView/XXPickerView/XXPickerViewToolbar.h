//
//  XXPickerViewToolbar.h
//  XXPickerViewDemo
//
//  Created by xiao on 17/1/10.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPickerViewTitleItem.h"

@interface XXPickerViewToolbar : UIToolbar

@property (nonatomic,strong) UIBarButtonItem *cancelButton;

@property (nonatomic,strong) XXPickerViewTitleItem *titleButton;

@property (nonatomic,strong) UIBarButtonItem *doneButton;

@end
