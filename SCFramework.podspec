Pod::Spec.new do |s|
  s.name     = 'SCFramework'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'SCFramework.'
  s.homepage = 'https://github.com/kangchuh/SCFramework'
  s.author   = { 'Angzn' => 'gangshuai08@gmail.com' }
  s.social_media_url = 'http://twitter.com/KangChuh'

  s.source   = { :git => 'https://github.com/kangchuh/SCFramework.git', :tag => s.version.to_s }

  s.description = %{
    SCFramework.
  }

  s.source_files = 'SCFramework/SCFramework/SCFramework/*'

  s.subspec 'Adapted' do |s|
    s.subspec 'AdaptedDevice' do |ad|
      ad.source_files = 'SCFramework/Adapted/AdaptedDevice/*.{h,m}'
    end
    s.subspec 'AdaptedSystem' do |as|
      as.source_files = 'SCFramework/Adapted/AdaptedSystem/*.{h,m}'
    end
  end

  s.platform = :ios

  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'CoreLocation', 'CoreData'

  s.ios.deployment_target = '7.0' # minimum SDK with autolayout

  s.requires_arc = true
end
