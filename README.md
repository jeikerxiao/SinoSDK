
![](logo.png)

# SinoSDK

    SinoSDK 是三诺生物传感股份有限公司的蓝牙血糖仪连接的SDK.
    
# 如何安装

## 1.使用CocoaPods安装

推荐使用这种安装方式。

### step1:添加下面一条语句到Podfile:
````
pod 'SinoSDK','~> 2.0.3'
````
### step2:导入.h文件
````objc
#import "SinoSDK/SinoSDK.h"
````

## 2.手动安装
不推荐。

### step1:添加SinoSDK.framework到工程中。

### step2:添加下开源项目到工程中：

- FMDB v2.6.2
- LKDBHelper v2.4
- ProtocolBuffers v1.9.11

### step3:导入.h文件
````objc
#import "SinoSDK/SinoSDK.h"
````


# 如何使用

## 1.设置代理和数据源

```objc
@interface MainViewController ()<SCBLEInterfaceDelegate, SCBLEInterfaceDataSource>
```

## 2.初始化SDK配置

```objc
- (void)initSinoSDK {
    
    [SCBleInterface sharedInterface].delegate = self;
    [SCBleInterface sharedInterface].dataSource = self;
    
    self.WL_1 = YES;
    
    if (self.isWL_1) {
        NSLog(@"是直连版WL_1血糖仪");
        // 默认isWL_1 = NO;
        [SCBleInterface sharedInterface].isWL_1 = YES;
    }else{
        NSLog(@"是微信版血糖仪");
        [SCBleInterface sharedInterface].isWL_1 = NO;
    }
    
    [[SCBleInterface sharedInterface] setAccessKey:self.accessKey secretKey:self.secretKey];
}
```

## 3.扫描

```objc
NSInteger rv = [[SCBleInterface sharedInterface] scan:8];
```

## 4.连接

```objc
NSInteger rv = [[SCBleInterface sharedInterface] connectedWithDevice:peripheral];
```

详细使用请查看SinoSDKDemo-v2.

# 兼容性
- 本项目和示例程序是使用Xcode8开发

# 更新日志

## v2.0.3 (2017/07/14)

- 优化性能

## v2.0.2 (2017/06/26)

- 支持IVT蓝牙血糖仪

## v2.0.1 (2017/06/15)

- 移除 AFNetworking 3.0 版本依赖
- 优化性能

## v2.0.0 (2017/01/13)
- SinoSDK v2.0.0 增加安稳+血糖仪支持。
- SinoSDKDemo-v2 Demo全新改版，对程序猿更友好。

## v1.0.6 (2017/01/04)
- 更新SinoSDKDemo(默认打开直连版开关).

## v1.0.6 (2016/10/30)
- 添加CocoaPods支持
- 增加SinoSDKDemo.
