Pod::Spec.new do |s|
	s.name = "ZappGoogleInteractiveMediaAds"
	s.version = '0.4.0'
	s.swift_versions = '5.1'

	s.summary = "ZappGoogleInteractiveMediaAds"
	s.description = "Zapp Plugins store Protocol and Managers that relevant for Applicaster Zapp Plugin System"
	s.homepage = 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
	s.license = 'Appache 2.0'
	s.author = "Applicaster LTD."
	s.source = {
		 :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
		 :tag => "1"
  }

    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
	s.tvos.vendored_frameworks = 'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/Files/tvOS/GoogleInteractiveMediaAds.framework'
	s.tvos.preserve_paths = 'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/Files/GoogleInteractiveMediaAds.framework'

	s.ios.source_files  = 'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/Files/Universal/**/*.swift'
	s.tvos.source_files  = ['Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/Files/Universal/**/*.swift',
							'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/Files/tvOS/**/*.swift'
	]
	s.ios.dependency 'GoogleAds-IMA-iOS-SDK', '= 3.11.1'
	
	s.dependency 'ZappCore'

	s.xcconfig = { 'ENABLE_BITCODE' => 'YES',
							'OTHER_LDFLAGS' => '$(inherited)  -framework "GoogleInteractiveMediaAds"',
							'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
							'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
							'ENABLE_TESTABILITY' => 'YES',
							'OTHER_CFLAGS'  => '-fembed-bitcode',
							'FRAMEWORK_SEARCH_PATHS' => '/Applications/Xcode.app/Contents/Developer/Library/Frameworks'
							 }



end
