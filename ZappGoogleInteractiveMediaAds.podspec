Pod::Spec.new do |s|
	s.name = "ZappGoogleInteractiveMediaAds"
	s.version = "1.0.3"

	s.swift_versions = ['5.1']
	s.tvos.deployment_target = "10.0"
	s.ios.deployment_target = "10.0"
	s.summary = "ZappGoogleInteractiveMediaAds"
	s.description = "Zapp Plugins store Protocol and Managers that relevant for Applicaster Zapp Plugin System"
	s.homepage = "https://applicaster.com"
	s.license = 'Appache 2.0'
	s.author = "Applicaster LTD."
	s.source = {
		 :git => 'https://github.com/applicaster/Google-IMA-Client-TV.git',
		 :tag => s.version.to_s
  }

	s.tvos.vendored_frameworks = 'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/tvOS/GoogleInteractiveMediaAds.framework'
	s.tvos.preserve_paths = 'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/GoogleInteractiveMediaAds.framework'

	s.source_files  = 'Frameworks/Plugins/PlayerDependant/ZappGoogleInteractiveMediaAds/**/*.swift'
	s.ios.dependency 'GoogleAds-IMA-iOS-SDK'
	
	s.dependency 'ZappCore'

	s.xcconfig = { 'ENABLE_BITCODE' => 'YES',
							'OTHER_LDFLAGS' => '$(inherited)  -framework "GoogleInteractiveMediaAds"',
							'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
							'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
							'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
							'ENABLE_TESTABILITY' => 'YES',
							'OTHER_CFLAGS'  => '-fembed-bitcode',
							'FRAMEWORK_SEARCH_PATHS' => '/Applications/Xcode.app/Contents/Developer/Library/Frameworks',
							'SWIFT_VERSION' => '5.0',
							 }

end
