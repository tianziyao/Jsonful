#
# Be sure to run `pod lib lint Jsonful.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Jsonful'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Jsonful.'

  s.homepage         = 'https://github.com/tianziyao/Jsonful'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tianziyao' => 'tianziyao@jingdata.com' }
  s.source           = { :git => 'https://github.com/tianziyao/Jsonful.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Jsonful/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Jsonful' => ['Jsonful/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
