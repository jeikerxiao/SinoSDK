Pod::Spec.new do |s|
  s.name             = "SinoSDK"
  s.version          = "1.0.2"
  s.summary          = "A Sinocare SDK used on iOS."
  s.description      = <<-DESC
                       It is a Sinocare BLE SDK used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/jeikerxiao/SinoSDK"
  s.license          = 'MIT'
  s.author           = { "jeikerxiao" => "jeiker@126.com" }
  s.source           = { :git => "https://github.com/jeikerxiao/SinoSDK.git", :tag => s.version }

  s.platform     = :ios,'8.0'
  s.requires_arc = true
  s.vendored_frameworks = 'SinoSDK.framework'
  s.frameworks = 'Foundation','UIKit'
  s.dependency 'AFNetworking', '~> 3.0.4'
  s.dependency 'LKDBHelper', '~> 2.4'
  s.dependency 'ProtocolBuffers', '~> 1.9.11'

end
