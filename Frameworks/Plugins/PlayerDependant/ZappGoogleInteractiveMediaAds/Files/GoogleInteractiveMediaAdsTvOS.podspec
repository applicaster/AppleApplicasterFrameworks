Pod::Spec.new do |s|
	s.name = "GoogleInteractiveMediaAdsTvOS"
	s.version = "1.0.3"
	s.platform = :tvos
	s.swift_versions = ['5.0']
	s.tvos.deployment_target = "10.0"
	s.summary = "GoogleInteractiveMediaAds"
	s.description = "Zapp Plugins store Protocol and Managers that relevant for Applicaster Zapp Plugin System"
	s.homepage = "https://applicaster.com"
	s.license = 'Appache 2.0'
	s.author = "Applicaster LTD."
	s.source = {
		 :git => 'https://github.com/applicaster/Google-IMA-Client-TV.git',
		 :tag => s.version.to_s
  }

	s.vendored_frameworks = 'tvOS/GoogleInteractiveMediaAdsTvOS/GoogleInteractiveMediaAdsTvOS/GoogleInteractiveAds/GoogleInteractiveMediaAds.framework'
	s.preserve_paths = 'tvOS/GoogleInteractiveMediaAdsTvOS/GoogleInteractiveMediaAdsTvOS/GoogleInteractiveAds/GoogleInteractiveMediaAds.framework'

	s.source_files  = 'tvOS/GoogleInteractiveMediaAdsTvOS/GoogleInteractiveMediaAdsTvOS/**/*.swift'
	s.dependency 'ZappPlugins'

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
