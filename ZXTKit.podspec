#
#  Be sure to run `pod spec lint ZQExtension.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ZXTKit"
  spec.version      = "0.0.3"
  spec.summary      = "Swift分类扩展,不断更新中。。"
  spec.description  = "Pod 分类扩展"
  spec.homepage     = "https://github.com/lizzie8023/ZXTKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "lizzie8023" => "zhangquan896@hotmail.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/lizzie8023/ZXTKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "ZXTKit", "ZXTKit/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"
end
