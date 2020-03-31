Pod::Spec.new do |s|
  s.name             = "ZappLocalNotifications"
  s.version          = '0.1.4'
  s.version          = '0.1.0'
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.summary          = "ZappLocalNotifications"
  s.description      = <<-DESC
  ZappLocalNotifications container.
                       DESC
  s.homepage         = "https://github.com/applicaster/AppleApplicasterFrameworks.git"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
                         :tag => '2020.3.30.20-3-4'  }

  s.requires_arc = true
  s.static_framework = true
  s.swift_versions = '5.1'

  s.source_files = 'Universal/**/*.swift'
  s.ios.source_files = 'iOS/**/*.swift'
  s.tvos.source_files = 'tvOS/**/*.swift'

  s.xcconfig =  {
                  'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES'
                }
  s.dependency 'ZappCore'

  s.test_spec 'UnitTests' do |sp|
    sp.ios.source_files = 'Tests/iOS/**/*.{swift}'
    sp.ios.resources = ['Tests/iOS/**/*.{png}']
    sp.tvos.source_files = 'Tests/iOS/**/Dummy.swift'
  end
end
