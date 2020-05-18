Pod::Spec.new do |s|
  s.name             = "ZappChromecast"
  s.version          = '0.1.10'
  s.summary          = "ZappChromecast"
  s.description      = <<-DESC
  ZappChromecast container.
                       DESC
  s.homepage         = "https://github.com/applicaster/AppleApplicasterFrameworks.git"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
                         :tag => '2020.5.15.17-5-3'  }
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.requires_arc = true
  s.static_framework = true
  s.swift_versions = '5.1'

  s.source_files = 'ios/**/*.{m,swift}'

  s.xcconfig =  {
                  'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES'
                }
  s.dependency 'ZappCore'
  s.dependency 'React'
  s.dependency 'google-cast-sdk-no-bluetooth', '= 4.4.6'

  s.test_spec 'UnitTests' do |sp|
    sp.source_files = 'Tests/**'
  end
end
