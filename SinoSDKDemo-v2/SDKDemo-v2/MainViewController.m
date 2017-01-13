//
//  MainViewController.m
//  SDKDemo-v2
//
//  Created by xiao on 17/1/5.
//  Copyright © 2017年 jeikerxiao. All rights reserved.
//

#import "MainViewController.h"

// SinoSDKDemo的第三方开源控件
#import "XXPickerView.h"
#import "YCXMenu.h"

// 导入SinoSDK头文件
//#import "SCBleInterface.h"
//#import "SCBloodSugerModel.h"
//#import "SCProtocol.h"
#import "SinoSDK/SinoSDK.h"

@interface MainViewController ()<SCBLEInterfaceDelegate, SCBLEInterfaceDataSource,XXPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (nonatomic, strong)NSMutableArray *devices;
@property (nonatomic, strong)NSMutableArray *macStrMutAry;

@property (nonatomic, strong)NSMutableString *testString;
@property (nonatomic, strong)XXPickerView *picker;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Log";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置导航栏按钮
    [self setNavigationButton];
    // 初始化Demo
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    // 初始化SDK
    [self initSinoSDK];

}

- (void)setNavigationButton {
    //创建导航栏右上方的按钮
    UIBarButtonItem *rightMaxBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(searchBtnClick:)];
    UIBarButtonItem *rightSharBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addBtnClick:)];
    NSArray *buttonItem = @[rightSharBt,rightMaxBt];
    self.navigationItem.rightBarButtonItems = buttonItem;
}

- (void)initData {
    
    self.devices = [NSMutableArray array];
    self.macStrMutAry = [NSMutableArray array];
    self.testString = [NSMutableString string];
    /*
     说明:
     1.请确保手机蓝牙打开。
     2.请确保使用与血糖仪对应的accessKey和secretKey。
     3.请确保血糖仪型号正确：微信版或安稳+血糖仪请关闭直连版WL-1开关。
     操作说明:
     1.请点击右上角放大镜图标进行扫描血糖仪（没有扫描到，请重复点击）。
     2.扫描到设备后请选择要连接的设备，点‘确定’连接。
     3.连接上设备后，可直接用血糖仪测试血糖。
     4.还可以点击‘+’号向血糖仪发送命令。";
     */
    self.logTextView.text = @"说明:\n1.请确保手机蓝牙打开。\n2.请确保使用与血糖仪对应的accessKey和secretKey。\n3.请确保血糖仪型号正确：微信版或安稳+血糖仪请关闭直连版WL-1开关。\n操作说明:\n1.请点击右上角放大镜图标进行扫描血糖仪（没有扫描到，请重复点击）。\n2.扫描到设备后请选择要连接的设备，点‘确定’连接。\n3.连接上设备后，可直接用血糖仪测试血糖。\n4.还可以点击‘+’号向血糖仪发送命令。\n";
}

#pragma mark - SinoSDK config

- (void)initSinoSDK {
    
    [SCBleInterface sharedInterface].delegate = self;
    [SCBleInterface sharedInterface].dataSource = self;
    
    self.WL_1 = NO;
    
    if (self.isWL_1) {
        NSLog(@"是直连版WL_1血糖仪");
        [self.testString appendString:@"直连版WL_1血糖仪。\n"];
        self.logTextView.text = self.testString;
        // 默认isWL_1 = NO;
        [SCBleInterface sharedInterface].isWL_1 = YES;
    }else{
        NSLog(@"是微信版血糖仪");
        [self.testString appendString:@"微信版血糖仪。\n"];
        self.logTextView.text = self.testString;
        
        [SCBleInterface sharedInterface].isWL_1 = NO;
    }
    
    [[SCBleInterface sharedInterface] setAccessKey:self.accessKey secretKey:self.secretKey];
}


#pragma mark - rightButtonClick

- (void)searchBtnClick:(UIButton *)searchBtn {
    
    // 判断”+“号菜单是否显示
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    }
    
    [self disConnected];
    
    [self.testString appendString:@"正在扫描\n"];
    self.logTextView.text = self.testString;
    
    NSInteger rv = [[SCBleInterface sharedInterface] scan:8];
    if (rv == SC_RV_CUSTOM_VERIFY) {
        [self.testString appendString:@"没有访问权限，请确保设置accessKey和secretKey\n"];
        self.logTextView.text = self.testString;
    } else if (rv == SC_RV_OK) {
        
        if ([self.devices count] == 0) {
            // 没有扫描到设备
            [self.testString appendString:@"没有扫描到设备\n"];
            self.logTextView.text = self.testString;
        }else {
            // 扫描到的设备
            self.picker = [[XXPickerView alloc] initWithTitle:@"扫描到的蓝牙设备" delegate:self];
            self.picker.titleFont = [UIFont systemFontOfSize:12];
            self.picker.titleColor = [UIColor redColor];
            [self.picker setTag:1];
            
            self.macStrMutAry = [NSMutableArray array];
            for (NSDictionary *deviceDic in self.devices) {
                CBPeripheral *peripheral = [deviceDic objectForKey:@"p"];
                NSString *mac = [deviceDic objectForKey:@"m"];
                NSString *title = [NSString stringWithFormat:@"%@-%@", peripheral.name, mac];
                [self.macStrMutAry addObject:title];
            }
        
            [self.picker setTitlesForComponents:@[self.macStrMutAry]];
            [self.picker show];
        }
    }

}

- (void)xxPickerView:(XXPickerView *)pickerView didSelectTitles:(NSArray *)titles selectedRows:(NSArray *)rows {
    // 选择蓝牙设备
    if (pickerView.tag == 1) {
        
        if ([self.devices count] == 0) {
            return;
        }

        NSInteger selectRow = [rows[0] integerValue];
        NSDictionary *pDic = [self.devices objectAtIndex:selectRow];
        CBPeripheral *peripheral = [pDic objectForKey:@"p"];
        NSInteger rv = [[SCBleInterface sharedInterface] connectedWithDevice:peripheral];
        if (rv != SC_RV_OK) {
            [self.testString appendString:@"没有访问权限，请确保设置accessKey和secretKey\n"];
            [self.logTextView setText:self.testString];
        }
        self.logTextView.text = titles[0];
    }
    
    // 选择校正码
    if (pickerView.tag == 3) {
        NSString *codeStr = titles[0];
        NSInteger codeInt = [codeStr integerValue];
        [self setAdjustmentCode:codeInt];
    }
}

- (void)addBtnClick:(UIButton *)addBtn {
    
    // 设置标题
    YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"命令菜单" WithIcon:nil];
    menuTitle.foreColor = [UIColor whiteColor];
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    
    // 断开当前的血糖仪连接
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"断开血糖仪连接" image:nil target:self action:@selector(logout:)];
    logoutItem.foreColor = [UIColor redColor];
    logoutItem.alignment = NSTextAlignmentCenter;
    
    NSArray *items = @[
                       menuTitle,
                       [YCXMenuItem menuItem:@"1.读取当前血糖数据"
                                       image:nil
                                         tag:101
                                    userInfo:nil],
                       
                       [YCXMenuItem menuItem:@"2.读取历史血糖数据"
                                       image:nil
                                         tag:102
                                    userInfo:nil],
                       
                       [YCXMenuItem menuItem:@"3.删除历史血糖数据"
                                       image:nil
                                         tag:103
                                    userInfo:nil],
                       
                       [YCXMenuItem menuItem:@"4.设置血糖仪校正码"
                                       image:nil
                                         tag:104
                                    userInfo:nil],
                       
                       [YCXMenuItem menuItem:@"5.设置血糖仪的时间"
                                       image:nil
                                         tag:105
                                    userInfo:nil],
                       
                       [YCXMenuItem menuItem:@"6.清空当前界面日志"
                                       image:nil
                                         tag:106
                                    userInfo:nil],
                       
                       [YCXMenuItem menuItem:@"7.连接已连过的设备"
                                       image:nil
                                         tag:107
                                    userInfo:nil],
                       
                       logoutItem
                       ];
    
    // 通过addButton显示Menu
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 65, 50, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
            switch (item.tag) {
                case 101:
                    // 1.读取当前血糖数据
                    [self readCurrent];
                    break;
                case 102:
                    // 2.读取历史血糖数据
                    [self readHistory];
                    break;
                case 103:
                    // 3.删除历史血糖数据
                    [self clearHistory];
                    break;
                case 104:
                    // 4.设置血糖仪校正码
                    [self setAdjustmentCode];
                    break;
                case 105:
                    // 5.设置血糖仪的时间
                    [self pickerTime];
                    break;
                case 106:
                    // 6.清空当前界面日志
                    [self clearLog];
                    break;
                case 107:
                    // 7.连接已连过的设备
                    [self directConnect];
                    break;
                default:
                    break;
            }
        }];
    }
    
}
// 断开血糖仪连接
- (void)logout:(UIButton *)logoutBtn {
    [self disConnected];
}

// 5.设置血糖仪时间
- (void)pickerTime {
    // 时间滚轮
    XXPickerView *picker = [[XXPickerView alloc] initWithTitle:@"设置时间" delegate:self];
    [picker setTag:2];
    [picker setPickerStyle:XXPickerStyleDateTimePicker];
    [picker show];
}

- (void)xxPickerView:(XXPickerView *)pickerView didSelectDate:(NSDate *)date {
    // 选择时间
    if (pickerView.tag == 2) {
        
        [self setTime:date];
    }
}

#pragma mark - 命令

/**
 通过UUID直连连接过的血糖，换血糖仪mac地址改变，则需要重新扫描连接。
 */
- (void)directConnect {
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"];
    
    if (uuid && uuid.length > 0) {
        NSLog(@"已连接过设备，直连");
        NSInteger rv = [[SCBleInterface sharedInterface] connectedWithString:uuid];
        if (rv == SC_RV_CUSTOM_VERIFY) {
            [self.testString appendString:@"没有访问权限，请确保设置accessKey和secretKey\n"];
            self.logTextView.text = self.testString;
        }
        
    } else {
        NSLog(@"未连接过设备，无法直连");
        [self.testString appendString:@"未连接过该设备，无法直连，请先扫描设备\n"];
        self.logTextView.text = self.testString;
    }
}

/**
 读血糖仪历史数据
 */
- (void)readHistory{
    
    [[SCBleInterface sharedInterface] readHistoryData:^(NSInteger rv, NSArray<SCBloodSugerModel *> *bloodSugers, BOOL finished) {
        NSLog(@"读取历史数据错误码:%ld", (long)rv);
        [self.testString appendFormat:@"读取历史数据错误码:\n %ld-描述:%@\n", (long)rv, [self convertErr:rv]];
        self.logTextView.text = self.testString;
        
        if (rv != SC_RV_OK) return;
        for (SCBloodSugerModel *bloodSuger in bloodSugers) {
            [self.testString appendString:@"*********************** \n"];
            self.logTextView.text = self.testString;
            
            NSLog(@"读历史数据： 20%d年%d月%d日%d时%d分--血糖：%.2f--样本类型:%d--温度:%.2f", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, (float)bloodSuger.temperature/10.);
            [self.testString appendFormat:@"20%d年%d月%d日%d时%d分\n血糖：%.2fmmol/L\n样本类型：%d\n温度：%.2f\n", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, bloodSuger.temperature/10.];
            self.logTextView.text = self.testString;
            
            [self.testString appendString:@"*********************** \n"];
            self.logTextView.text = self.testString;
        }
    }];
}

/**
 清空血糖仪历史数据
 */
- (void)clearHistory {
    
    [[SCBleInterface sharedInterface] clearHistoryData:^(NSInteger rv) {
        if (rv == SC_RV_OK) {
            NSLog(@"清空历史数据成功");
            [self.testString appendString:@"清空历史数据成功\n"];
            self.logTextView.text = self.testString;
            
        } else {
            NSLog(@"清空历史数据失败,错误码:%ld-描述：%@", (long)rv, [self convertErr:rv]);
            [self.testString appendFormat:@"清空历史数据失败\n %ld-描述:%@\n", (long)rv, [self convertErr:rv]];
            self.logTextView.text = self.testString;
            
        }
    }];
    
}

/**
 设置血糖仪校正码
 */
- (void)setAdjustmentCode {
    // 设置血糖仪校正码
    XXPickerView *codePicker = [[XXPickerView alloc] initWithTitle:@"设置血糖仪校正码" delegate:self];
    codePicker.titleFont = [UIFont systemFontOfSize:14];
    codePicker.titleColor = [UIColor blackColor];
    [codePicker setTag:3];
    
    NSMutableArray *codeStrMutAry = [NSMutableArray array];
    for (int i=0;i<=40;i++) {
        NSString *codeStr = [NSString stringWithFormat:@"%d", i];
        [codeStrMutAry addObject:codeStr];
    }
    [codePicker setTitlesForComponents:@[codeStrMutAry]];
    [codePicker show];
    
}

/**
 设置血糖仪校正码

 @param code 要设置的校正码
 */
- (void)setAdjustmentCode:(NSInteger)code {
    // 免调码系列产品，则此命令无效。可调码产品的调码范围为：0～40
    [[SCBleInterface sharedInterface] setAdjustmentCode:code block:^(NSInteger rv) {
        if (rv == SC_RV_OK) {
            NSLog(@"设置校正码成功");
            [self.testString appendString:@"设置校正码成功\n"];
            self.logTextView.text = self.testString;
            
            [self.testString appendString:[NSString stringWithFormat:@"设置当前仪器的校正码为:%ld\n",code]];
            self.logTextView.text = self.testString;
            
        } else {
            NSLog(@"设置校正码失败，错误码:%ld，描述：%@", (long)rv, [self convertErr:rv]);
            [self.testString appendFormat:@"设置校正码失败\n %ld-描述:%@\n", (long)rv, [self convertErr:rv]];
            self.logTextView.text = self.testString;
            
        }
    }];
}

/**
 设置血糖仪时间

 @param date 要设置的时间
 */
- (void)setTime:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:date];
    NSLog(@"设置为当前时间：%@", string);
    [self.testString appendString:@"当前选择的时间为："];
    [self.testString appendString:string];
    
    self.logTextView.text = self.testString;
    
    [[SCBleInterface sharedInterface] setTimeWithDate:date block:^(NSInteger rv) {
        if (rv == SC_RV_OK) {
            NSLog(@"\n设置为当前时间成功");
            [self.testString appendString:@"\n设置为当前时间成功\n"];
            self.logTextView.text = self.testString;
            
        } else {
            NSLog(@"设置时间失败，错误码:%ld，描述：%@", (long)rv, [self convertErr:rv]);
            [self.testString appendFormat:@"设置时间失败\n %ld-描述:%@\n", (long)rv, [self convertErr:rv]];
            self.logTextView.text = self.testString;
        }
    }];
}

/**
 读取当前血糖结果
 */
- (void)readCurrent {
    
    [[SCBleInterface sharedInterface] readCurrentData:^(NSInteger rv, SCBloodSugerModel *bloodSuger) {
        NSLog(@"读当前数据错误码:%ld，描述:%@", (long)rv, [self convertErr:rv]);
        [self.testString appendFormat:@"读当前数据错误码:\n %ld-描述:%@\n", (long)rv, [self convertErr:rv]];
        self.logTextView.text = self.testString;
        
        if (rv == SC_RV_OK) {
            [self.testString appendString:@"*********************** \n"];
            self.logTextView.text = self.testString;
            
            NSLog(@"读当前数据：20%d年%d月%d日%d时%d分--血糖：%d--样本类型:%d--温度:%d", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, bloodSuger.bloodSuger, bloodSuger.type, bloodSuger.temperature);
            [self.testString appendFormat:@"20%d年%d月%d日%d时%d分--血糖：%.2fmmol/L--样本类型:%d--温度:%.2f℃\n", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, (float)bloodSuger.temperature/10.];
            self.logTextView.text = self.testString;
            
            [self.testString appendString:@"*********************** \n"];
            self.logTextView.text = self.testString;
        }
        
    }];
}

/**
 清空Demo屏幕上的日志信息
 */
- (void)clearLog {
    
    self.testString = [NSMutableString stringWithString:@""];
    self.logTextView.text = self.testString;
    
}

/**
 断开蓝牙连接
 */
- (void)disConnected {
    
    [[SCBleInterface sharedInterface] disConnected];
}

#pragma mark - UIBLEInterfaceDelegate

- (void)BleDidDiscover:(CBPeripheral *)peripheral macAddress:(NSString *)macAddress RSSI:(NSNumber *)RSSI {

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
    self.logTextView.text = self.testString;
    
}

- (void)BleDidConnected:(BOOL)connected peripheal:(CBPeripheral *) peripheral {
    [self.devices removeAllObjects];
    [self.picker reloadAllComponents];
    
    if (!connected) {
        [self.testString appendFormat:@"连接函数的返回值:\n %d(BOOL)-连接或认证失败，不能通讯\n", connected];
        [self.logTextView setText:self.testString];
        
    } else {
        // 存储连接成功的设备UUID，方便下次直接连接
        [[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString forKey:@"UUID"];
        
        [self.testString appendFormat:@"连接函数的返回值:\n %d(BOOL)-连接并认证成功，可以通讯\n", connected];
        [self.logTextView setText:self.testString];
    }
}

/**
 蓝牙状态发生变化
 */
- (void)BleDidUpdateState:(SC_BLE_STATUS)bleStatus {
    NSLog(@"蓝牙状态发生变化:%ld", (long)bleStatus);
    [self.testString appendFormat:@"蓝牙状态发生变化:\n %ld-描述:%@ \n", (long)bleStatus, [self convertBLEStatus:bleStatus]];
    self.logTextView.text = self.testString;
    
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
    self.logTextView.text = self.testString;
    
}
/**
 仪器返回错误码
 */
- (void)didReturnValue:(NSInteger)rv {
    NSLog(@"设备返回了错误码:%ld", (long)rv);
    [self.testString appendFormat:@"血糖仪返回错误码:\n %ld-描述:%@ \n", (long)rv, [self convertErr:rv]];
    self.logTextView.text = self.testString;
    
}

/**
 仪器返回测试结果
 */
- (void)didRecieveTestResult:(SCBloodSugerModel *)bloodSuger {
    
    NSLog(@"仪器返回了测试结果:%@", bloodSuger);
    NSLog(@"20%d年%d月%d日%d时%d分 --血糖:%d --样本类型:%d--温度:%d", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, bloodSuger.bloodSuger, bloodSuger.type, bloodSuger.temperature);
    [self.testString appendString:@"仪器返回了测试结果:\n"];
    self.logTextView.text = self.testString;
    [self.testString appendString:@"*********************** \n"];
    self.logTextView.text = self.testString;
    
    [self.testString appendFormat:@"20%d年%d月%d日%d时%d分 \n 血糖：%.2fmmol/L \n 样本类型：%d \n 温度：%.2f℃\n", bloodSuger.year, bloodSuger.month, bloodSuger.day, bloodSuger.hour, bloodSuger.minute, (float)bloodSuger.bloodSuger/10., bloodSuger.type, (float)bloodSuger.temperature/10.];
    self.logTextView.text = self.testString;
    
    [self.testString appendString:@"*********************** \n"];
    self.logTextView.text = self.testString;
}

#pragma mark - convertSinoSDKStatus

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
            des = @"E1错误 - 血糖仪电量过低";
            break;
        case SC_RV_E2:
            des = @"E2错误 - 血糖仪温度超出范围";
            break;
        case SC_RV_E3:
            des = @"E3错误 - 血糖仪试条错误";
            break;
        case SC_RV_HI:
            des = @"HI错误 - 测试结果值过高";
            break;
        case SC_RV_LO:
            des = @"LO错误 - 测试结果值过低";
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


@end
