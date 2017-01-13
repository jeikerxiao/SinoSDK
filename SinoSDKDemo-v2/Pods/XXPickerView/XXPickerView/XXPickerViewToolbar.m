//
//  XXPickerViewToolbar.m
//  XXPickerViewDemo
//
//  Created by xiao on 17/1/10.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import "XXPickerViewToolbar.h"
#import "XXPickerViewTitleItem.h"

@implementation XXPickerViewToolbar

- (void)initialize {
    
    [self sizeToFit];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.translucent = YES;
    [self setTintColor:[UIColor blackColor]];
    
    // 取消按钮
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    // 在 取消按钮 和 标题按钮 之间创建一个空按钮
    UIBarButtonItem *nilButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    // 标题按钮
    self.titleButton = [[XXPickerViewTitleItem alloc] initWithTitle:nil];
    
    // 确定按钮
    self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    
    // 把按钮添加到toolBar上
    [self setItems:@[self.cancelButton, nilButton, self.titleButton, nilButton, self.doneButton]];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFit = [super sizeThatFits:size];
    sizeThatFit.height = 44;
    return sizeThatFit;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    for (UIBarButtonItem *item in self.items) {
        [item setTintColor:tintColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    static Class XXUIToolbarTextButtonClass;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XXUIToolbarTextButtonClass = NSClassFromString(@"UIToolbarTextButton");
    });
    
    NSArray *subviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        
        CGFloat x1 = CGRectGetMinX(view1.frame);
        CGFloat y1 = CGRectGetMinY(view1.frame);
        CGFloat x2 = CGRectGetMinX(view2.frame);
        CGFloat y2 = CGRectGetMinY(view2.frame);
        
        if (x1 < x2) {
            return NSOrderedAscending;
        }else if (x1 > x2) {
            return NSOrderedDescending;
        }else if (y1 < y2) {
            return NSOrderedAscending;
        }else if (y1 > y2) {
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    UIView *leftBarButtonView = nil;
    UIView *titleBarButtonView = nil;
    UIView *rightBarButtonView = nil;
    
    for (UIView *barButtonItemView in subviews) {
        if (titleBarButtonView != nil && [barButtonItemView isKindOfClass:XXUIToolbarTextButtonClass]) {
            rightBarButtonView = barButtonItemView;
        }else if (titleBarButtonView == nil && [barButtonItemView isMemberOfClass:[UIView class]]){
            titleBarButtonView = barButtonItemView;
        }else if (leftBarButtonView == nil && [barButtonItemView isKindOfClass:XXUIToolbarTextButtonClass]){
            leftBarButtonView = barButtonItemView;
        }
    }
    
    // 左边按钮
    CGRect rect = leftBarButtonView.frame;
    rect.origin.x = 8;
    leftBarButtonView.frame = rect;
    
    // 右边按钮
    rect = rightBarButtonView.frame;
    rect.origin.x = self.frame.size.width - rect.size.width-8 ;
    rightBarButtonView.frame = rect;
    
    // 标题按钮
    CGFloat x = CGRectGetMaxX(leftBarButtonView.frame) + 16;
    CGFloat width = (CGRectGetMinX(rightBarButtonView.frame)-16)-x;
    
    rect = titleBarButtonView.frame;
    rect.origin.x = x;
    rect.origin.y = 0;
    rect.size.width = width;
    rect.size.height = self.frame.size.height;
    titleBarButtonView.frame = rect;
}

@end
