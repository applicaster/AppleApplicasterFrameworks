Pod::Spec.new do |s|
  s.name             = "FirebaseBaseSettings"
  s.version          = '2.0.4'
  s.summary          = "FirebaseBaseSettings"
  s.description      = <<-DESC
  FirebaseBaseSettings container.
                       DESC
  s.homepage         = "https://github.com/applicaster/AppleApplicasterFrameworks.git"
  s.license          = 'CMPS'
	s.author           = "Applicaster LTD."
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', 
                         :tag => '2020.2.20.23-2-4'  }
  s.platform         = :ios, '11.0'
  s.requires_arc = true
  s.static_framework = true
	s.swift_versions = '5.1'

  s.source_files = 'Universal/**/*.swift'

  s.xcconfig =  { 
                  'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES'
                }
  s.dependency 'ZappCore'
  s.dependency 'Firebase/Core', '= 6.17.0'  

  s.test_spec 'UnitTests' do |sp|
    sp.source_files = 'Tests/**'
  end
end
