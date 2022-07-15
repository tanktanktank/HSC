#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
    
use_modular_headers!
inhibit_all_warnings!

target "coiuntrade-ios" do
use_frameworks! :linkage => :static

#布局
pod 'SnapKit'
#pod 'RxSwift'
pod 'RxCocoa'
pod 'SwiftyJSON'
pod 'HandyJSON'
pod 'Moya'
pod 'JXPageControl'
#数据库
pod 'RealmSwift'
#loding,吐司
pod 'ProgressHUD'
pod 'ImageViewer.swift'
pod 'SectionIndexView'
#二维码
pod 'swiftScan'
pod 'LXQRCodeManager'
#折线图，饼状图
pod 'SwiftChart'
#pod 'RxDataSources'
pod 'Starscream', '~> 4.0.0'
#国际化
pod 'Localize-Swift'
#loading
pod 'SVProgressHUD'
#图片加载框架
pod 'Kingfisher', '~> 6.3.1'
#轮播图
pod 'ZCycleView','1.0.3'
#Segmented
pod 'JXSegmentedView'
pod 'JXPagingView/Paging', '2.1.0'
pod 'OYMarqueeView'
#图表
pod 'Charts', '~> 3.2.2'
pod 'MZCircleProgress', '~> 0.0.1'
#气泡弹窗
pod 'PrincekinPopoverView'
#空视图
pod 'XYEmptyDataView'
#富文本label ，带点击事件
pod 'ActiveLabel'
#键盘管理
pod 'IQKeyboardManagerSwift'
#腾讯UI库
pod 'QMUIKit', '~> 4.3.0'
#OC 列表刷新框架
pod 'MJRefresh', '~> 3.7.2'
#日志收集
pod 'Bugly'
pod 'LookinServer', :configurations => ['Debug'] #UI调试
#pod 'AMLeaksFinder', '2.2.3',  :configurations => ['Debug']
#极验
pod 'GT3Captcha-iOS'
#pod 'XLActionController'
#end

post_install do |installer|
  remove_swift_ui()
     installer.pods_project.targets.each do |target|
       #if target.name =="App" || target.name =="Flutter"
       target.build_configurations.each do |config|
         config.build_settings['ENABLE_BITCODE'] ='NO'
         config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'NO'
         config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
#         config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
       end
     end
  end
end
    
def remove_swift_ui
  system("rm -rf ./Pods/Kingfisher/Sources/SwiftUI")
  code_file = "./Pods/Kingfisher/Sources/General/KFOptionsSetter.swift"
  code_text = File.read(code_file)
  code_text.gsub!(/#if canImport\(SwiftUI\) \&\& canImport\(Combine\)(.|\n)+#endif/,'')
  system("rm -rf " + code_file)
  aFile = File.new(code_file, 'w+')
  aFile.syswrite(code_text)
  aFile.close()
end
