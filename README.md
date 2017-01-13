
![](logo.png)

# SinoSDK

    SinoSDK 是三诺生物传感股份有限公司的蓝牙血糖仪连接的SDK.
    
# 如何安装

##1.使用CocoaPods安装

推荐使用这种安装方式。

###step1:添加下面一条语句到Podfile:
````
pod 'SinoSDK','~> 2.0.0'
````
###step2:导入.h文件
````objc
#import "SinoSDK/SinoSDK.h"
````

##2.手动安装
不推荐。

###step1:添加SinoSDK.framework到工程中。

###step2:添加下开源项目到工程中：

- AFNetworking v3.0.4
- FMDB v2.6.2
- LKDBHelper v2.4
- ProtocolBuffers v1.9.11

###step3:导入.h文件
````objc
#import "SinoSDK/SinoSDK.h"
````


# 如何使用

请查看SinoSDKDemo-v2.

# 兼容性
- 本项目和示例程序是使用Xcode8开发

# 更新日志
##v2.0.0 (2017/01/13)
- SinoSDK v2.0.0 增加安稳+血糖仪支持。
- SinoSDKDemo-v2 Demo全新改版，对程序猿更友好。

##v1.0.6 (2017/01/04)
- 更新SinoSDKDemo(默认打开直连版开关).

##v1.0.6 (2016/10/30)
- 添加CocoaPods支持
- 增加SinoSDKDemo.
