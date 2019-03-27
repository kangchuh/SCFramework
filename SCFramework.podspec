#
# Be sure to run `pod lib lint SCFramework.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name     = 'SCFramework'
  s.version  = '1.1.2'
  s.license  = 'MIT'
  s.summary  = 'SCFramework.'
  s.homepage = 'https://github.com/kangchuh/SCFramework'
  s.author   = { 'Angzn' => 'gangshuai08@gmail.com' }
  s.social_media_url = 'http://twitter.com/KangChuh'
  s.source   = { :git => 'https://github.com/kangchuh/SCFramework.git', :tag => s.version.to_s }
  s.description = <<-DESC
                  SCFramework.
                  DESC

  s.source_files = 'SCFramework/**/*.{h,m}'
  s.public_header_files = 'SCFramework/**/*.h'
  s.resources = 'SCFramework/**/*.{lproj}'

  s.dependency 'FMDB', '~> 2.7.0'
  s.platform = :ios
  s.library = 'z'
  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'CoreLocation', 'CoreData', 'AssetsLibrary', 'AVFoundation'
  s.ios.deployment_target = '7.0' # minimum SDK with autolayout
  s.requires_arc = true
end
