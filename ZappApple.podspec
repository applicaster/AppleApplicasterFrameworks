
Pod::Spec.new do |s|
  s.name = 'ZappApple'
  s.version = '0.6.7'
  s.summary = 'Framework that has general logic of the Zapp Apple application'
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.swift_versions = '5.1'
  s.description = <<-DESC
  'Framework that has general logic of the Zapp Apple application'
  DESC

  s.homepage = 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
  s.license = 'Appache 2.0'
  s.author = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
  s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => "2020.2.20.0-2-0" }

  s.ios.xcconfig =  {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'ENABLE_BITCODE' => 'YES',
    'OTHER_CFLAGS'  => '-fembed-bitcode',
    'OTHER_LDFLAGS' => '$(inherited) -objc -framework "AppCenter" -framework "AppCenterDistribute" ',

  }

  s.tvos.xcconfig =  {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'ENABLE_BITCODE' => 'YES',
    'OTHER_CFLAGS'  => '-fembed-bitcode',
    'OTHER_LDFLAGS' => '$(inherited) -objc ',

  }

  s.dependency 'ZappCore'
  s.dependency 'ReachabilitySwift', '= 5.0.0'
  s.ios.dependency 'AppCenter/Distribute', '= 2.5.3'

  s.source_files = 'Frameworks/ZappApple/Files/Universal/**/*.{h,m,swift}'
  s.ios.source_files = 'Frameworks/ZappApple/Files/ios/**/*.{swift}'
  s.tvos.source_files = 'Frameworks/ZappApple/Files/tvos/**/*.{swift}'

  s.test_spec 'UnitTests' do |sp|
    sp.source_files = 'Frameworks/ZappApple/Files/Tests/**'
  end
end
