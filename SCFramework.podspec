Pod::Spec.new do |s|
  s.name     = 'SCFramework'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'SCFramework.'
  s.homepage = 'https://github.com/kangchuh/SCFramework'
  s.author   = { 'Angzn' => 'gangshuai08@gmail.com' }
  s.social_media_url = "http://twitter.com/KangChuh"

  s.source   = { :git => 'https://github.com/kangchuh/SCFramework.git', :tag => 'v1.0.0' }

  s.description = %{
    SCFramework.
  }

  s.source_files = 'SCFramework/SCFramework/*.{h,m}'

  s.platform = :ios

  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'CoreLocation', 'CoreData', 'libz'

  s.ios.deployment_target = '7.0' # minimum SDK with autolayout

  s.requires_arc = true
end
