Pod::Spec.new do |spec|

  spec.name         = "RequestHelper-IOS"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of RequestHelper-IOS."
  spec.homepage     = "https://github.com/xorowo/RequestHelper-IOS"

  spec.author       = { "Artem Drebednev" => "drebednev@mail.ru" }
  spec.platform     = :ios
  spec.source       = { :git => "https://github.com/xorowo/RequestHelper-IOS", :branch => spec.version }

  spec.ios.deployment_target 	= '11.0'
  spec.source_files 		= 'RequestHelper/**/*.{h,m,swift}'
  spec.ios.framework		= 'UIKit'

end
