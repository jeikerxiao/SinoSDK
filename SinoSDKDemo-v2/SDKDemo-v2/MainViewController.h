//
//  MainViewController.h
//  SDKDemo-v2
//
//  Created by xiao on 17/1/5.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, copy)NSString *accessKey;
@property (nonatomic, copy)NSString *secretKey;
@property (nonatomic, assign, getter=isWL_1)BOOL WL_1;

@end
