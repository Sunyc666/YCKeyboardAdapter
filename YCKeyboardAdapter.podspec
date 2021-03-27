Pod::Spec.new do |s|
  s.name         = "YCKeyboardAdapter"
  s.version      = "1.0.0"
  s.summary      = "各类三方键盘弹出高度适配"
  s.description  = <<-DESC
                       各类三方键盘弹出高度适配，包括但不限于：搜狗输入法、百度输入法、讯飞输入法、章鱼输入法、QQ输入法等
                   DESC
  s.homepage     = "https://github.com/Sunyc666/YCKeyboardAdapter"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Sunyc"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/Sunyc666/YCKeyboardAdapter.git", :tag => "#{s.version}" }
  # the framework upload to CocoaPods
  s.vendored_frameworks = 'YCKeyboardAdapter.framework'
  s.frameworks = 'UIKit','Foundation'

