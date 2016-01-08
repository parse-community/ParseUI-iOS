Pod::Spec.new do |s|
  s.name             = 'ParseUI'
  s.version          = '1.2.0'
  s.license          =  { :type => 'SDK', :file => 'LICENSE'}
  s.homepage         = 'https://www.parse.com/'
  s.summary          = 'ParseUI is a library of useful User Interface components for the Parse iOS SDK.'
  s.authors          = 'Parse'
  s.social_media_url = 'https://twitter.com/ParseIt'

  s.source           = { :git => "https://github.com/ParsePlatform/ParseUI-iOS.git", :tag => s.version.to_s }

  s.platform              = :ios
  s.requires_arc          = true
  s.ios.deployment_target = '7.0'

  s.prepare_command     = <<-CMD
                          ruby ParseUI/Scripts/convert_images.rb \
                               ParseUI/Resources/Images/ \
                               ParseUI/Generated/PFResources
                          CMD
  s.source_files        = "ParseUI/**/*.{h,m}"
  s.public_header_files = 'ParseUI/Classes/LogInViewController/*.h',
                          'ParseUI/Classes/SignUpViewController/*.h',
                          'ParseUI/Classes/QueryTableViewController/*.h',
                          'ParseUI/Classes/QueryCollectionViewController/*.h',
                          'ParseUI/Classes/ProductTableViewController/*.h',
                          'ParseUI/Classes/Views/*.h',
                          'ParseUI/Classes/Cells/*.h',
                          'ParseUI/Other/*.h'
  s.resources  = ['ParseUI/Resources/Localization/*.lproj']
  s.frameworks          = 'Foundation',
                          'UIKit',
                          'CoreGraphics',
                          'QuartzCore'

  s.dependency 'Bolts/Tasks', '~> 1.3'
  s.dependency 'Parse', '~> 1.9'
end
