Pod::Spec.new do |s|
  s.name             = "ZappAppleVideoSubscriptionRegistration"
  s.version          = '0.1.2'
  s.summary          = "ZappAppleVideoSubscriptionRegistration"
  s.description      = <<-DESC
  ZappAppleVideoSubscriptionRegistration container.
                       DESC
  s.homepage         = "https://github.com/applicaster/AppleApplicasterFrameworks.git"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
                         :tag => '2020.2.9.9-2-0'  }
  s.platform = :tvos, :ios
  s.tvos.deployment_target = '11.0'
  s.ios.deployment_target = '11.0'
  s.requires_arc = true
  s.static_framework = true
  s.swift_versions = '5.1'

  s.source_files = 'Universal/**/*.swift'

  s.frameworks = 'VideoSubscriberAccount'

  s.xcconfig =  {
                  'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES'
                }
  s.dependency 'ZappCore'

  s.test_spec 'UnitTests' do |sp|
    sp.source_files = 'Tests/**'
  end
end
