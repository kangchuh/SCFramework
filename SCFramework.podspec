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
      ss.resources = 'SCFramework/SCFramework/SCFramework/*.{lproj}'

      ss.subspec 'Adapted' do |a|
        a.source_files = 'SCFramework/SCFramework/SCFramework/Adapted/*.{h,m}'

        a.subspec 'AdaptedDevice' do |ad|
          ad.source_files = 'SCFramework/SCFramework/SCFramework/Adapted/AdaptedDevice/*.{h,m}'
        end
        a.subspec 'AdaptedSystem' do |as|
          as.source_files = 'SCFramework/SCFramework/SCFramework/Adapted/AdaptedSystem/*.{h,m}'
        end
      end

      ss.subspec 'Category' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Category/*.{h,m}'
      end

      ss.subspec 'Common' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Common/*.{h,m}'

        c.subspec 'Utils' do |u|
          u.source_files = 'SCFramework/SCFramework/SCFramework/Common/Utils/*.{h,m}'
        end
        c.subspec 'App' do |a|
          a.source_files = 'SCFramework/SCFramework/SCFramework/Common/App/*.{h,m}'
        end
        c.subspec 'Foundation' do |f|
          f.source_files = 'SCFramework/SCFramework/SCFramework/Common/Foundation/*.{h,m}'
        end
        c.subspec 'Math' do |m|
          m.source_files = 'SCFramework/SCFramework/SCFramework/Common/Math/*.{h,m}'
        end
      end

      ss.subspec 'Constant' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Constant/*.{h,m}'
      end

      ss.subspec 'Manager' do |c|
        c.source_files = 'SCFramework/SCFramework/SCFramework/Manager/*.{h,m}'

        c.subspec 'DaoManager' do |d|
          d.source_files = 'SCFramework/SCFramework/SCFramework/Manager/DaoManager/*.{h,m}'
        end
        c.subspec 'DateManager' do |d|
          d.source_files = 'SCFramework/SCFramework/SCFramework/Manager/DateManager/*.{h,m}'
        end
        c.subspec 'FileManager' do |f|
          f.source_files = 'SCFramework/SCFramework/SCFramework/Manager/FileManager/*.{h,m}'
        end
        c.subspec 'ImagePickerManager' do |i|
          i.source_files = 'SCFramework/SCFramework/SCFramework/Manager/ImagePickerManager/*.{h,m}'
        end
        c.subspec 'LocationManager' do |l|
          l.source_files = 'SCFramework/SCFramework/SCFramework/Manager/LocationManager/*.{h,m}'
        end
        c.subspec 'UserDefaultManager' do |u|
          u.source_files = 'SCFramework/SCFramework/SCFramework/Manager/UserDefaultManager/*.{h,m}'
        end
        c.subspec 'VersionManager' do |v|
          v.source_files = 'SCFramework/SCFramework/SCFramework/Manager/VersionManager/*.{h,m}'
        end
      end

      ss.subspec 'Vendor' do |v|
        v.source_files = 'SCFramework/SCFramework/SCFramework/Vendor/*.{h,m}'
      end

      ss.subspec 'ViewControllers' do |vcs|
        vcs.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/*.{h,m}'

        vcs.subspec 'SCNavigationController' do |nvc|
          nvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCNavigationController/*.{h,m}'
        end
        vcs.subspec 'SCPageViewController' do |pvc|
          pvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCPageViewController/*.{h,m}'
        end
        vcs.subspec 'SCTabBarController' do |tbvc|
          tbvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCTabBarController/*.{h,m}'
        end
        vcs.subspec 'SCTableViewController' do |tvc|
          tvc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCTableViewController/*.{h,m}'
        end
        vcs.subspec 'SCViewController' do |vc|
          vc.source_files = 'SCFramework/SCFramework/SCFramework/ViewControllers/SCViewController/*.{h,m}'
        end
      end

        ss.subspec 'Views' do |vs|
        vs.source_files = 'SCFramework/SCFramework/SCFramework/Views/*.{h,m}'

        vs.subspec 'SCActionSheet' do |as|
          as.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCActionSheet/*.{h,m}'
        end
        vs.subspec 'SCAlertView' do |av|
          av.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCAlertView/*.{h,m}'
        end
        vs.subspec 'SCToolbar' do |tb|
          tb.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCToolbar/*.{h,m}'
        end
        vs.subspec 'SCButton' do |b|
          b.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCButton/*.{h,m}'
        end
        vs.subspec 'SCDatePicker' do |dp|
          dp.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCDatePicker/*.{h,m}'
        end
        vs.subspec 'SCLabel' do |l|
          l.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCLabel/*.{h,m}'
        end
        vs.subspec 'SCPickerView' do |pv|
          pv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCPickerView/*.{h,m}'
        end
        vs.subspec 'SCScrollView' do |sv|
          sv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCScrollView/*.{h,m}'
        end
        vs.subspec 'SCTableView' do |tv|
          tv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTableView/*.{h,m}'
        end
        vs.subspec 'SCTableViewCell' do |tvc|
          tvc.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTableViewCell/*.{h,m}'
        end
        vs.subspec 'SCTextField' do |tf|
          tf.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTextField/*.{h,m}'
        end
        vs.subspec 'SCTextView' do |tv|
          tv.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCTextView/*.{h,m}'
        end
        vs.subspec 'SCView' do |v|
          v.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCView/*.{h,m}'
        end
        vs.subspec 'SCPageControl' do |pc|
          pc.source_files = 'SCFramework/SCFramework/SCFramework/Views/SCPageControl/*.{h,m}'
        end
      end
    end
  end

  s.dependency 'FMDB', '~> 2.5'

  s.platform = :ios

  s.library = 'z'

  s.ios.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'CoreLocation', 'CoreData', 'AssetsLibrary', 'AVFoundation'

  s.ios.deployment_target = '7.0' # minimum SDK with autolayout

  s.requires_arc = true
end
