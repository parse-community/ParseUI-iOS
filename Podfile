source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
use_frameworks!

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
