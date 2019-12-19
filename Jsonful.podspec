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
  s.summary          = 'Jsonful可以让你像JavaScript使用JSON一样使用Swift原生数据和模型.'

  s.homepage         = 'https://github.com/tianziyao/Jsonful'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tianziyao' => 'ziyao.tian@gmail.com' }
  s.source           = { :git => 'https://github.com/tianziyao/Jsonful.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  s.source_files = 'Jsonful/Classes/**/*'
  
  s.ios.framework = ['UIKit', 'CoreGraphics']
  
end
