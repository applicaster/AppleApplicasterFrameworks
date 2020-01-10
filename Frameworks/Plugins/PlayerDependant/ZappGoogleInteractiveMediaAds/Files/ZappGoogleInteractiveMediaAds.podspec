Pod::Spec.new do |s|
	s.name = "ZappGoogleInteractiveMediaAds"
	s.version = '0.4.1'
	s.swift_versions = '5.1'

	s.summary = "ZappGoogleInteractiveMediaAds"
	s.description = "Zapp Plugins store Protocol and Managers that relevant for Applicaster Zapp Plugin System"
	s.homepage = 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
	s.license = 'Appache 2.0'
	s.author = "Applicaster LTD."
	s.source = {
		 :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
		 :tag => "2020.1.10.15-1-2"
  }

    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
	s.tvos.vendored_frameworks = 'tvOS/GoogleInteractiveMediaAds.framework'
	s.tvos.preserve_paths = 'tvOS/GoogleInteractiveMediaAds.framework'

	s.ios.source_files  = 'Universal/**/*.swift'
	s.tvos.source_files  = ['Universal/**/*.swift',
							'tvOS/**/*.swift'
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
