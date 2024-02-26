source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
use_frameworks!

target 'MassageDT' do
  # 界面布局
  pod 'SnapKit'
  pod 'AutoInch'
  pod 'JFPopup', '1.5.4'

  # 网络处理
  pod 'Alamofire'
  pod 'ProgressHUD'
  pod 'HandyJSON'

  # UIKit扩展
  pod 'UIColor_Hex_Swift'
  pod 'YYText', :modular_headers => true

  # 键盘管理
  pod 'IQKeyboardManagerSwift'


  pod 'SDWebImage', :modular_headers => true
  
  # 三方验证库
  pod 'CL_ShanYanSDK' # 手机号验证（闪验）
 
 pod 'ExytePopupView'
  pod 'SDWebImageSwiftUI'
  

  pod 'SJVideoPlayer'
  pod 'SwiftSoup'
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
#            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#            config.build_settings["EXCLUDED_ARCHS[sdk=*]"] = "arm64"
            config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
         end
    end
  end
end

