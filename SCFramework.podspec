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

  s.subspec 'SCFramework' do |s|
    s.subspec 'SCFramework' do |ss|
      ss.source_files = 'SCFramework/SCFramework/SCFramework/*.{h,m}'
      ss.public_header_files = 'SCFramework/SCFramework/SCFramework/*.h'
      ss.resources = 'SCFramework/SCFramework/SCFramework/*.{lproj}'

      ss.subspec 'Adapted' do |a|
        a.source_files = 'SCFramework/SCFramework/SCFramework/Adapted/*.{h,m}'
        a.public_header_files = 'SCFramework/SCFramework/SCFramework/Adapted/*.h'

        a.subspec 'AdaptedDevice' do |ad|
          ad.source_files = 'SCFramework/SCFramework/SCFramework/Adapted/AdaptedDevice/*.{h,m}'
          ad.public_header_files = 'SCFramework/SCFramework/SCFramework/Adapted/AdaptedDevice/*.h'
        end
        a.subspec 'AdaptedSystem' do |as|
          as.source_files = 'SCFramework/SCFramework/SCFramework/Adapted/AdaptedSystem/*.{h,m}'
          as.public_header_files = 'SCFramework/SCFramework/SCFramework/Adapted/AdaptedSystem/*.h'
        end
      end

      ss.subspec 'Category' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Category/*.{h,m}'
        c.public_header_files = 'SCFramework/SCFramework/SCFramework/Category/*.h'
      end

      ss.subspec 'Common' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Common/*.{h,m}'
        c.public_header_files = 'SCFramework/SCFramework/SCFramework/Common/*.h'

        c.subspec 'Utils' do |u|
          u.source_files = 'SCFramework/SCFramework/SCFramework/Common/Utils/*.{h,m}'
          u.public_header_files = 'SCFramework/SCFramework/SCFramework/Common/Utils/*.h'
        end
        c.subspec 'App' do |a|
          a.source_files = 'SCFramework/SCFramework/SCFramework/Common/App/*.{h,m}'
          a.public_header_files = 'SCFramework/SCFramework/SCFramework/Common/App/*.h'
        end
        c.subspec 'Foundation' do |f|
          f.source_files = 'SCFramework/SCFramework/SCFramework/Common/Foundation/*.{h,m}'
          f.public_header_files = 'SCFramework/SCFramework/SCFramework/Common/Foundation/*.h'
        end
        c.subspec 'Math' do |m|
          m.source_files = 'SCFramework/SCFramework/SCFramework/Common/Math/*.{h,m}'
          m.public_header_files = 'SCFramework/SCFramework/SCFramework/Common/Math/*.h'
        end
      end

      ss.subspec 'Constant' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Constant/*.{h,m}'
        c.public_header_files = 'SCFramework/SCFramework/SCFramework/Constant/*.h'
      end

      ss.subspec 'Manager' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Manager/*.{h,m}'
        c.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/*.h'

        c.subspec 'DaoManager' do |d|
          d.source_files = 'SCFramework/SCFramework/SCFramework/Manager/DaoManager/*.{h,m}'
          d.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/DaoManager/*.h'
        end
        c.subspec 'DateManager' do |d|
          d.source_files = 'SCFramework/SCFramework/SCFramework/Manager/DateManager/*.{h,m}'
          d.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/DateManager/*.h'
        end
        c.subspec 'FileManager' do |f|
          f.source_files = 'SCFramework/SCFramework/SCFramework/Manager/FileManager/*.{h,m}'
          f.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/FileManager/*.h'
        end
        c.subspec 'ImagePickerManager' do |i|
          i.source_files = 'SCFramework/SCFramework/SCFramework/Manager/ImagePickerManager/*.{h,m}'
          i.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/ImagePickerManager/*.h'
        end
        c.subspec 'LocationManager' do |l|
          l.source_files = 'SCFramework/SCFramework/SCFramework/Manager/LocationManager/*.{h,m}'
          l.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/LocationManager/*.h'
        end
        c.subspec 'UserDefaultManager' do |u|
          u.source_files = 'SCFramework/SCFramework/SCFramework/Manager/UserDefaultManager/*.{h,m}'
          u.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/UserDefaultManager/*.h'
        end
        c.subspec 'VersionManager' do |v|
          v.source_files = 'SCFramework/SCFramework/SCFramework/Manager/VersionManager/*.{h,m}'
          v.public_header_files = 'SCFramework/SCFramework/SCFramework/Manager/VersionManager/*.h'
        end
      end

      ss.subspec 'Vendor' do |v|
        v.source_files = 'SCFramework/SCFramework/SCFramework/Vendor/*.{h,m}'
        v.public_header_files = 'SCFramework/SCFramework/SCFramework/Vendor/*.h'
      end

      ss.subspec 'ViewControllers' do |vcs|
        vcs.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/*.{h,m}'
        vcs.public_header_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/*.h'

        vcs.subspec 'SCNavigationController' do |nvc|
          nvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCNavigationController/*.{h,m}'
          nvc.public_header_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCNavigationController/*.h'
        end
        vcs.subspec 'SCPageViewController' do |pvc|
          pvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCPageViewController/*.{h,m}'
          pvc.public_header_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCPageViewController/*.h'
        end
        vcs.subspec 'SCTabBarController' do |tbvc|
          tbvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCTabBarController/*.{h,m}'
          tbvc.public_header_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCTabBarController/*.h'
        end
        vcs.subspec 'SCTableViewController' do |tvc|
          tvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCTableViewController/*.{h,m}'
          tvc.public_header_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCTableViewController/*.h'
        end
        vcs.subspec 'SCViewController' do |vc|
          vc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCViewController/*.{h,m}'
          vc.public_header_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCViewController/*.h'
        end
      end

        ss.subspec 'Views' do |vs|
        vs.source_files = 'SCFramework/SCFramework/SCFramework/Views/*.{h,m}'
        vs.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/*.h'

        vs.subspec 'SCActionSheet' do |as|
          as.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCActionSheet/*.{h,m}'
          as.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCActionSheet/*.h'
        end
        vs.subspec 'SCAlertView' do |av|
          av.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCAlertView/*.{h,m}'
          av.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCAlertView/*.h'
        end
        vs.subspec 'SCToolbar' do |tb|
          tb.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCToolbar/*.{h,m}'
          tb.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCToolbar/*.h'
        end
        vs.subspec 'SCButton' do |b|
          b.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCButton/*.{h,m}'
          b.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCButton/*.h'
        end
        vs.subspec 'SCDatePicker' do |dp|
          dp.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCDatePicker/*.{h,m}'
          dp.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCDatePicker/*.h'
        end
        vs.subspec 'SCLabel' do |l|
          l.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCLabel/*.{h,m}'
          l.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCLabel/*.h'
        end
        vs.subspec 'SCPickerView' do |pv|
          pv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCPickerView/*.{h,m}'
          pv.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCPickerView/*.h'
        end
        vs.subspec 'SCScrollView' do |sv|
          sv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCScrollView/*.{h,m}'
          sv.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCScrollView/*.h'
        end
        vs.subspec 'SCTableView' do |tv|
          tv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTableView/*.{h,m}'
          tv.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCTableView/*.h'
        end
        vs.subspec 'SCTableViewCell' do |tvc|
          tvc.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTableViewCell/*.{h,m}'
          tvc.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCTableViewCell/*.h'
        end
        vs.subspec 'SCTextField' do |tf|
          tf.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTextField/*.{h,m}'
          tf.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCTextField/*.h'
        end
        vs.subspec 'SCTextView' do |tv|
          tv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTextView/*.{h,m}'
          tv.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCTextView/*.h'
        end
        vs.subspec 'SCView' do |v|
          v.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCView/*.{h,m}'
          v.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCView/*.h'
        end
        vs.subspec 'SCPageControl' do |pc|
          pc.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCPageControl/*.{h,m}'
          pc.public_header_files = 'SCFramework/SCFramework/SCFramework/Views/SCPageControl/*.h'
        end
      end
    end
  end

  s.dependency 'FMDB', '~> 2.7.0'

  s.platform = :ios

  s.library = 'z'

  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'CoreLocation', 'CoreData', 'AssetsLibrary', 'AVFoundation'

  s.ios.deployment_target = '7.0' # minimum SDK with autolayout

  s.requires_arc = true
end
