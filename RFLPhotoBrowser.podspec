Pod::Spec.new do |s|
  s.name          =  "RFLPhotoBrowser"
  s.summary       =  "Photo Browser / Viewer inspired by Facebook's and Tweetbot's with ARC support, swipe-to-dismiss, image progress and more."
  s.version       =  "1.5.9"
  s.homepage      =  "https://github.com/ideaismobile/IDMPhotoBrowser"
  s.license       =  { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author        =  { "Ideais Mobile" => "mobile@ideais.com.br" }
  s.source        =  { :git => "https://github.com/shhommatsu/RFLPhotoBrowser.git", :tag => "1.5.9" }
  s.platform      =  :ios, '7.0'
  s.source_files  =  'Classes/*.{h,m}'
  s.resources     =  'Classes/RFLPhotoBrowser.bundle', 'Classes/RFLPBLocalizations.bundle'
  s.framework     =  'MessageUI', 'QuartzCore', 'SystemConfiguration', 'MobileCoreServices', 'Security', 'AssetsLibrary', 'AVFoundation'
  s.requires_arc  =  true
  s.dependency       'AFNetworking'
  s.dependency       'DACircularProgress'
  s.dependency       'pop'
  end
