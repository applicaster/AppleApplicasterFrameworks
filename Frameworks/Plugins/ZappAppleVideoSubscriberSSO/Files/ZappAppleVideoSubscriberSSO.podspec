Pod::Spec.new do |s|
  s.name             = "ZappAppleVideoSubscriberSSO"
  s.version          = '0.1.12'
  s.summary          = "ZappAppleVideoSubscriberSSO"
  s.description      = <<-DESC
  ZappAppleVideoSubscriberSSO container.
                       DESC
  s.homepage         = "https://github.com/applicaster/AppleApplicasterFrameworks.git"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
                         :tag => '2020.5.21.19-5-0'  }
  s.platform = :tvos, :ios
  s.tvos.deployment_target = '11.0'
  s.ios.deployment_target = '11.0'
  s.requires_arc = true
  s.static_framework = true
  s.swift_versions = '5.1'

  s.frameworks = 'VideoSubscriberAccount'

  s.source_files  = [
    'Universal/**/*.{m,swift}'
  ]

  s.xcconfig =  {
                  'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES'
                }

  s.dependency 'ZappCore'
  s.dependency 'React'

  s.test_spec 'UnitTests' do |sp|
    sp.source_files = 'Tests/**'
  end
end
