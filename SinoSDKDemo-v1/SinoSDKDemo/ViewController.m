//
//  ViewController.m
//  SinoSDKDemo
//
//  Created by xiao on 16/10/30.
//  Copyright © 2016年 jeikerxiao. All rights reserved.
//

#import "ViewController.h"
#import "SinoSDK/SinoSDK.h"

#define SC_PICKER_HEIGHT 206

#define SC_ACCESSKEY @"888"
#define SC_SECRETKEY @"888"

@interface ViewController ()<SCBLEInterfaceDelegate, SCBLEInterfaceDataSource>

@property (nonatomic, strong)NSMutableArray *devices;
@property (nonatomic, strong)NSMutableString *testString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = YES;
    self.title = @"Demo";
    self.devices = [NSMutableArray array];
    self.testString = [NSMutableString string];
    
    [SCBleInterface sharedInterface].delegate = self;
    [SCBleInterface sharedInterface].dataSource = self;
    [SCBleInterface sharedInterface].isWL_1 = YES;
    [[SCBleInterface sharedInterface] setAccessKey:SC_ACCESSKEY secretKey:SC_SECRETKEY];
    
    self.title = @"管理工具";

    
    self.picker.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, SC_PICKER_HEIGHT);
    self.picker.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    self.accessKeyField = [[UITextField alloc] initWithFrame:CGRectMake(10, 25, 120, 30)];
    self.accessKeyField.borderStyle = UITextBorderStyleRoundedRect;
    self.accessKeyField.delegate = self;
    [self.accessKeyField setText:SC_ACCESSKEY];
    self.accessKeyField.placeholder = @"accessKey";
    [self.view addSubview:self.accessKeyField];
    self.secretKeyField = [[UITextField alloc] initWithFrame:CGRectMake(140, 25, 120, 30)];
    self.secretKeyField.borderStyle = UITextBorderStyleRoundedRect;
    self.secretKeyField.delegate = self;
    [self.secretKeyField setText:SC_SECRETKEY];
    self.secretKeyField.placeholder = @"secretKey";
    [self.view addSubview:self.secretKeyField];
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setButton.frame = CGRectMake(270, 25, 40, 30);
    [setButton setTitle:@"设置" forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(setAccessKey:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAccessKey:(id)sender {
    NSString *accessKey = self.accessKeyField.text;
    NSString *secretKey = self.secretKeyField.text;
    
    if (!accessKey.length || !secretKey.length) {
        [self.testString appendString:@"accessKey和secretKey必须设置才能调用接口\n"];
        self.textView.text = self.testString;
        return;
    }
    
    [[SCBleInterface sharedInterface] setAccessKey:accessKey secretKey:secretKey];

    
}


- (NSString *)convertBLEStatus:(SC_BLE_STATUS)status {
    NSString *des = @"";
    switch (status) {
        case SC_BLE_STATUS_POWERON:
            des = @"蓝牙打开";
            break;
        case SC_BLE_STATUS_POWEROFF:
            des = @"蓝牙关闭";
            break;
        case SC_BLE_STATUS_NOT_SUPPORT:
            des = @"不支持蓝牙4.0";
            break;
        case SC_BLE_STATUS_CONNECTED:
            des = @"蓝牙连接上设备";
            break;
        case SC_BLE_STATUS_DISCONNECTED:
            des = @"蓝牙断开连接";
            break;
        case SC_BLE_STATUS_VERIFING:
            des = @"正在进行验证accessKey";
            break;
        case SC_BLE_STATUS_VERIFY_OK:
            des = @"accessKey验证成功，可以进行通讯";
            break;
        case SC_BLE_STATUS_VERIFY_ERROR:
            des = @"accessKey验证失败或session失效，需要重新建立通道";
            break;
            
        default:
            break;
    }
    return des;
}

- (NSString *)convertErr:(NSInteger)err {
    NSString *des = @"OK";
    switch (err) {
        case SC_RV_E1:
            des = @"E1错误";
            break;
        case SC_RV_E2:
            des = @"E2错误";
            break;
        case SC_RV_E3:
            des = @"E3错误";
            break;
        case SC_RV_HI:
            des = @"HI错误";
            break;
        case SC_RV_LO:
            des = @"LO错误";
            break;
        case SC_RV_CUSTOM_DATA:
            des = @"数据解析错误";
            break;
        case SC_RV_CUSTOM_VERIFY:
            des = @"访问权限错误";
            break;
        case SC_RV_CUSTOM_DISCONNECTED:
            des = @"已断开连接";
            break;

            
        default:
            break;
    }
    return des;
}

- (void)hidePicker {
    [UIView beginAnimations:nil context:nil];
    self.picker.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, SC_PICKER_HEIGHT);
    [UIView commitAnimations];

}

- (void)setTestString:(NSMutableString *)testString {
    _testString = testString;
    self.textView.text = _testString;
}

- (IBAction)connectedDett:(id)sender {
    [self hidePicker];

    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"];
    if (uuid && uuid.length > 0) {
        NSLog(@"已连接过设备，直连");
//        [self.testString appendString:@"已连接过设备，直连\n"];
//        self.textView.text = self.testString;
        
        NSInteger rv = [[SCBleInterface sharedInterface] connectedWithString:uuid];
        if (rv == SC_RV_CUSTOM_VERIFY) {
            [self.testString appendString:@"没有访问权限，请确保设置accessKey和secretKey\n"];
            self.textView.text = self.testString;
        }
        
    } else {
        NSLog(@"未连接过设备，无法直连");
        [self.testString appendString:@"未连接过该设备，无法直连，请先扫描设备\n"];
        self.textView.text = self.testString;

    }
}


- (IBAction)scan:(id)sender {

    
    [self.testString appendString:@"正在扫描\n"];
    self.textView.text = self.testString;

    NSInteger rv = [[SCBleInterface sharedInterface] scan:8];
    if (rv == SC_RV_CUSTOM_VERIFY) {
        [self.testString appendString:@"没有访问权限，请确保设置accessKey和secretKey\n"];
        self.textView.text = self.testString;
    } else if (rv == SC_RV_OK) {
        [self.view bringSubviewToFront:self.picker];
        [UIView beginAnimations:nil context:nil];
        self.picker.frame = CGRectMake(0, self.view.bounds.size.height - SC_PICKER_HEIGHT, self.view.frame.size.width, SC_PICKER_HEIGHT);
        [UIView commitAnimations];
    }
}


- (IBAction)readHistory:(id)sender {
    [self hidePicker];

    [[SCBleInterface sharedInterface] readHistoryData:^(NSInteger rv, NSArray<SCBloodSugerModel *> *bloodSugers, BOOL finished) {
        NSLog(@"读取历史数据错误码:%ld", (long)rv);
        [self.testString appendFormat:@"读取历史数据错误码:%ld，描述:%@\n", (long)rv, [self convertErr:rv]];
        self.textView.text = self.testString;

        if (rv != SC_RV_OK) return;
        for (SCBloodSugerModel *bloodSuger in bloodSugers) {
            NSLog(@"读历史数据： %d年%d月%d日%d时%d分--血糖：%d--样本类型:%d--温度:%d", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, bloodSuger.bloodSuger, bloodSuger.type, bloodSuger.temperature);
            [self.testString appendFormat:@"读历史数据： %d年%d月%d日%d时%d分--血糖：%.2fmmol/L--样本类型:%d--温度:%d\n", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, bloodSuger.temperature];
            self.textView.text = self.testString;
            
        }
    }];
}

- (IBAction)clearHistory:(id)sender {
    [self hidePicker];

    [[SCBleInterface sharedInterface] clearHistoryData:^(NSInteger rv) {
        if (rv == SC_RV_OK) {
            NSLog(@"清空历史数据成功");
            [self.testString appendString:@"清空历史数据成功\n"];
            self.textView.text = self.testString;

        } else {
            NSLog(@"清空历史数据失败，错误码:%ld，描述：%@", (long)rv, [self convertErr:rv]);
            [self.testString appendFormat:@"清空历史数据失败，错误码:%ld，描述:%@\n", (long)rv, [self convertErr:rv]];
            self.textView.text = self.testString;

        }
    }];
}

- (IBAction)readCurrent:(id)sender {
    [self hidePicker];

    [[SCBleInterface sharedInterface] readCurrentData:^(NSInteger rv, SCBloodSugerModel *bloodSuger) {
        NSLog(@"读当前数据错误码:%ld，描述:%@", (long)rv, [self convertErr:rv]);
        [self.testString appendFormat:@"读当前数据错误码:%ld，描述:%@\n", (long)rv, [self convertErr:rv]];
        self.textView.text = self.testString;
        
        if (rv == SC_RV_OK) {
            NSLog(@"读当前数据：%d年%d月%d日%d时%d分--血糖：%d--样本类型:%d--温度:%d", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, bloodSuger.bloodSuger, bloodSuger.type, bloodSuger.temperature);
            [self.testString appendFormat:@"读当前数据：%d年%d月%d日%d时%d分--血糖：%.2fmmol/L--样本类型:%d--温度:%.2f℃\n", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, (float)bloodSuger.temperature/10.];
            self.textView.text = self.testString;
        }

    }];
}

- (IBAction)clearText:(id)sender {
    [self hidePicker];

    self.testString = [NSMutableString stringWithString:@""];
}

- (IBAction)disConnected:(id)sender {
    [self hidePicker];

    [[SCBleInterface sharedInterface] disConnected];
}

#pragma mark - UIBLEInterfaceDelegate
- (void)BleDidDiscover:(CBPeripheral *) peripheral macAddress:(NSString *)macAddress RSSI:(NSNumber *)RSSI {
    NSLog(@"发现设备:%@, 信号:%d", macAddress, [RSSI intValue]);
    NSDictionary *pDic = @{@"p":peripheral, @"m":macAddress};
    int i = 0;
    BOOL replace = NO;
    for (NSDictionary *storeDic in self.devices) {
        CBPeripheral *p = [storeDic objectForKey:@"p"];
        if ([p.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            [self.devices replaceObjectAtIndex:i withObject:pDic];
            replace = YES;
            break;
        }
        i++;
    }
    if (replace == NO) {
        [self.devices addObject:pDic];
    }
    [self.picker reloadAllComponents];
}

- (void)BleScanFinished {
    NSLog(@"结束扫描");
    [self.testString appendString:@"结束扫描\n"];
    self.textView.text = self.testString;

}

- (void)BleDidConnected:(BOOL)connected peripheal:(CBPeripheral *) peripheral {
    [self.devices removeAllObjects];
    [self.picker reloadAllComponents];
    if (!connected) {
        [self.testString appendFormat:@"这是连接函数的返回值:(BOOL)%d，连接或认证失败，不能通讯\n", connected];
        [self.textView setText:self.testString];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接超时" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString forKey:@"UUID"];
        
        [self.testString appendFormat:@"这是连接函数的返回值:(BOOL)%d，连接并认证成功，可以通讯\n", connected];
        [self.textView setText:self.testString];

//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
        
    }
}

/**
 蓝牙状态发生变化
 */
- (void)BleDidUpdateState:(SC_BLE_STATUS)bleStatus {
    NSLog(@"蓝牙状态发生变化:%ld", (long)bleStatus);
    [self.testString appendFormat:@"蓝牙状态发生变化，状态码：%ld， 描述：%@\n", (long)bleStatus, [self convertBLEStatus:bleStatus]];
    self.textView.text = self.testString;
    //self.textView.text = [NSString stringWithFormat:@"%@\n蓝牙状态发生变化:%ld", self.textView.text, (long)bleStatus];

}


#pragma mark - UIBleInterfaceDataSource


/**
 sinocare设备返回状态码，eg.滴血符号闪烁/正在测试...
 */
- (void)didRecieveDeviceStatus:(SC_DEVICE_STATUS)status {
    NSString *statusString = nil;
    switch (status) {
        case SC_DEVICE_STATUS_FLASH:
            statusString = @"滴血符号闪烁";
            break;
        case SC_DEVICE_STATUS_BEGIN_TEST:
            statusString = @"滴血完成开始测试";
            break;
        case SC_DEVICE_STATUS_SHUT_DOWN:
            statusString = @"仪器关机";
            break;
            
        default:
            break;
    }
    NSLog(@"%@", statusString);
    [self.testString appendFormat:@"%@\n", statusString];
    self.textView.text = self.testString;

}

- (void)didReturnValue:(NSInteger)rv {
    NSLog(@"设备返回了错误码:%ld", (long)rv);
    [self.testString appendFormat:@"设备返回了错误码:%ld，描述:%@\n", (long)rv, [self convertErr:rv]];
    self.textView.text = self.testString;

}


/**
 仪器返回测试结果
 */
- (void)didRecieveTestResult:(SCBloodSugerModel *)bloodSuger {
    
    NSLog(@"仪器返回了测试结果:%@", bloodSuger);
    NSLog(@"%d年%d月%d日%d时%d分--血糖：%d--样本类型:%d--温度:%d", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, bloodSuger.bloodSuger, bloodSuger.type, bloodSuger.temperature);
    [self.testString appendString:@"仪器返回了测试结果:\n"];
    self.textView.text = self.testString;

    [self.testString appendFormat:@"%d年%d月%d日%d时%d分--血糖：%.2fmmol/L--样本类型:%d--温度:%.2f℃\n", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, (float)bloodSuger.temperature/10.];
    self.textView.text = self.testString;


}


#pragma mark - UIPickerView Delegate And DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.devices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *pDic = [self.devices objectAtIndex:row];
    CBPeripheral *peripheral = [pDic objectForKey:@"p"];
    NSString *mac = [pDic objectForKey:@"m"];
    NSString *title = [NSString stringWithFormat:@"%@-%@", peripheral.name, mac];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self hidePicker];
    
    if ([self.devices count] == 0) {
        return;
    }
    NSDictionary *pDic = [self.devices objectAtIndex:row];
    CBPeripheral *peripheral = [pDic objectForKey:@"p"];
    NSInteger rv = [[SCBleInterface sharedInterface] connectedWithDevice:peripheral];
    if (rv != SC_RV_OK) {
        [self.testString appendString:@"没有访问权限，请确保设置accessKey和secretKey\n"];
        [self.textView setText:self.testString];
    }
}


#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
