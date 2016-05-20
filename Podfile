source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '7.0'

workspace 'ParseUI'
# xcodeproj 'ParseUI.xcodeproj'

def shared_pods
  pod 'ParseFacebookUtilsV4'
  pod 'ParseTwitterUtils'
  pod 'ParseUI', :path => '.'
end

target 'ParseUIDemo' do
  shared_pods
end

target 'ParseUIDemo-Swift' do
  shared_pods
end
