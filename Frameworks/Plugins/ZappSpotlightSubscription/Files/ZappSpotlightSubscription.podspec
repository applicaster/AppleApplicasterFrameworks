Pod::Spec.new do |s|
  s.name             = "ZappSpotlightSubscription"
  s.version          = '7.0.0'
  s.summary          = "ZappSpotlightSubscription"
  s.description      = <<-DESC
  ZappSpotlightSubscription container.
                       DESC
  s.homepage         = "https://github.com/applicaster/AppleApplicasterFrameworks.git"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
                         :tag => '2020.2.4.19-2-2'  }
  s.platform         = :ios, '11.0'
  s.requires_arc = true
  s.static_framework = true
	s.swift_versions = '5.1'

  s.source_files = 'iOS/**/*.swift'

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
