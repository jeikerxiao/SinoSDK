//
//  ViewController.h
//  SinoSDKDemo
//
//  Created by xiao on 16/10/30.
//  Copyright © 2016年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic)IBOutlet UIPickerView *picker;
@property (strong, nonatomic)IBOutlet UITextView *textView;

@property (strong, nonatomic)UITextField *accessKeyField;
@property (strong, nonatomic)UITextField *secretKeyField;
@end

