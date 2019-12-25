Pod::Spec.new do |s|
  s.name             = "ZappCrashlogsPluginMsAppCenter"
  s.version          = '4.0.0'
  s.summary          = "ZappCrashlogsPluginMsAppCenter"
  s.description      = <<-DESC
                        ZappCrashlogsPluginMsAppCenter container.
                       DESC
  s.homepage         = "https://github.com/applicaster/ZappCrashlogsPluginMsAppCenter-iOS"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => "0.4.0"  }
  s.platform         = :ios, '10.0'
  s.requires_arc = true
  s.static_framework = true

  s.source_files = 'Frameworks/Plugins/Crashlogs/MsAppCenter/**/*.swift'
]
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES',
                    'SWIFT_VERSION' => '5.1'
                }

  s.dependency 'AppCenter/Crashes', '~> 2.3.0'
end
