Pod::Spec.new do |s|
  s.name  = "QuickBrickApple"
  s.version = '1.0.0'
	s.platform = :ios, :tvos
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.summary = "QuickBrickApple"
  s.description = "QuickBrickApple framework"
  s.homepage  = "https://github.com/applicaster/QuickBrick-Apple.git"
  s.license = 'CMPS'
	s.author = 'Applicaster LTD.'

  s.source  = { :git => "https://github.com/applicaster/QuickBrick-Apple.git`", :tag => s.version.to_s }
  s.requires_arc = true
  s.static_framework = false

  s.source_files  = 'QuickBrickApple/QuickBrickApple/**/*.{m,swift}'
  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                'ENABLE_BITCODE' => 'YES',
                'SWIFT_VERSION' => '5.0',
                'OTHER_CFLAGS'  => '-fembed-bitcode',
              }

  s.dependency 'ZappPlugins'
  s.dependency 'React'

end
