#
# Be sure to run `pod lib lint UpLoadMoreControl.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UpLoadMoreControl"
  s.version          = "0.1.0"
  s.summary          = "A easy and light way to use pull-to-loadmore."
  s.homepage         = "https://github.com/pgbo/UpLoadMoreControl"
  s.license          = 'MIT'
  s.author           = { "pgbo" => "460667915@qq.com" }
  s.source           = { :git => "https://github.com/pgbo/UpLoadMoreControl.git", :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/pgbo'

  s.platform	 = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'UpLoadMoreControl' => ['Pod/Localized/*.lproj']
  }

  s.frameworks = 'UIKit'
end
