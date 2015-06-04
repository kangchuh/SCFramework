SCFramework
===========

SCFramework 是一个常用类封装和扩展的集合，主要包含常用类别、常用基类。

Introduction
===========

SCFramework 是一个基于ARC常用类封装和扩展的集合。主要包含Adapted、Category、Common、Constant、Manager、Resources、ViewControllers、Views几大分类。结构如下：
<br/>- **Adapted**
<br/>- **Category**
<br/>- **Common**
<br/>- **Constant**
<br/>- **Manager**
<br/>- **ViewControllers**
<br/>- **Views**

适配类
-------------
AdaptedDevice－设备适配<br/>
AdaptedSystem－系统适配

类别类
-------------
常用类的扩展，如: 
*NSArray*、
*NSData*、
*NSDate*、
*NSDictionary*、
*NSObject*、
*NSString*、
*NSTimer*、
*NSURL*、
*UIAlertView*、
*UIColor*、
*UIDevice*、
*UIImage*、
*UIView*、
*UITableView*、
*UIScreen*、
*UIBarButtonItem*、
*UINavigationItem*、
*UINavigationController* 等

通用类
-------------
SCApp－App的常用方法<br/>
SCModel－数据模型基类<br/>
SCMath－数学常用方法<br/>
SCUtils－工具类

常量类
-------------
SCConstant－常量类

管理类
-------------
SCDaoManager－数据库操作工具类<br/>
SCDateManager－日期与时间操作工具类<br/>
SCFileManager－文件操作工具类<br/>
SCImagePickerManager－照片库与照相机操作工具类<br/>
SCLocationManager－定位工具类<br/>
SCUserDefaultManager－用户设置工具类<br/>
SCVersionManager－版本管理工具类

视图控制器类
-------------
SCNavigationController－导航控制器类，添加了自定义返回手势<br/>
SCTableViewController－列表视图控制器类，支持下拉刷新和上拉加载

视图类
-------------
SCActionSheet－添加block回调方式<br/>
SCAlertView－添加block回调方式<br/>
SCButton<br/>
SCDatePicker－自定义日期选择器<br/>
SCLabel<br/>
SCPageControl<br/>
SCPickerView－自定义选择器，支持自定义数据模型绑定<br/>
SCTableViewCell<br/>
SCTextField<br/>
SCTextView－添加了placeholder属性等<br/>
SCToolbar<br/>

SCScrollView<br/>
- **SCBrowseView**－浏览视图，使用了重用机制，支持自动浏览<br/>
- **SCCycleScrollView**－循环滚动视图，支持自动定时滚动<br/>

SCTableView<br/>
- **SCPullRefreshView**－刷新视图<br/>
- **SCPullLoadView**－加载视图<br/>

SCView<br/>
- **SCActionView**－扩展视图，添加了部分动画

Licenses
===========

All source code is licensed.
