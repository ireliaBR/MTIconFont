#
# Be sure to run `pod lib lint Module_Chat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MTIconFont'
  s.version          = '1.0.0'
  s.summary          = 'iconfont 字体加载图标'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
	iconfont 字体加载图标
                       DESC

  s.homepage         = 'https://github.com/ireliaBR/MTIconFont'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'irelia' => '672575302@qq.com' }
  s.source           = { :git => 'https://github.com/ireliaBR/MTIconFont.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'MTIconFont/MTIconFont/**/*'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  
  s.frameworks = 'UIKit', 'AVFoundation'
end
