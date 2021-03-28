Pod::Spec.new do |spec|
  spec.name         = "YCKeyboardAdapter"
  spec.version      = "1.0.0"
  spec.summary      = "各类三方键盘弹出高度适配"
  spec.description  = <<-DESC
                      各类三方键盘弹出高度适配，包括但不限于：搜狗输入法、百度输入法、讯飞输入法、章鱼输入法、QQ输入法等
                   DESC
  spec.homepage     = "https://github.com/Sunyc666/YCKeyboardAdapter"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "Sunyc" => "987598765@qq.com" }
  spec.source       = { :git => "https://github.com/Sunyc666/YCKeyboardAdapter.git.git", :tag => "#{spec.version}" }
  spec.platform = :ios, "9.0"
  spec.ios.deployment_target = "9.0"
  # spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  # Framework
  # 我的文件路径
  #   Products
  # │   └── WxkNetKit
  # │       └── WxkNetKit.framework
  spec.vendored_frameworks = "YCKeyboardAdapter/**/*.{framework}"
end