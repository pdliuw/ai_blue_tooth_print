#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ai_blue_tooth_print.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ai_blue_tooth_print'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter blue tooth print plugin.'
  s.description      = <<-DESC
A new Flutter blue tooth print plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'

  s.platform = :ios, '9.0'
  s.static_framework = true
  # view(start)
  s.dependency 'Alamofire'
  s.dependency 'SVProgressHUD'
  s.dependency 'SDWebImage'
  s.dependency 'MJExtension'
  s.dependency 'SwiftyJSON'
  s.dependency 'MJRefresh'
  s.dependency 'SnapKit'
  s.dependency 'Reusable'
  s.dependency 'HMSegmentedControl'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'Then'
  # view(end)
  
  # include project framework
  s.vendored_frameworks = '**/*.framework'
  # include project .a
  s.vendored_libraries = '**/*.a'
  # ios system framework
  s.frameworks = [
        "PrinterSDK", "SystemConfiguration"
  ]
  # ios system library
  s.libraries = [
        
  ]
  # resources
  s.resources = '*.framework/*.bundle'
  # s.resource_bundles = {
  #   'hanyin_printer_fluttify' => ['*.framework/*.bundle']
  # }


  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
