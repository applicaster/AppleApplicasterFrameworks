
Pod::Spec.new do |s|
  s.name             = "ZappFirebaseAnalytics"
  s.version          = '0.2.0'
  s.summary          = "ZappFirebaseAnalytics"
  s.swift_versions = '5.1'
  s.description      = <<-DESC
                      ZappFirebaseAnalytics container.
                       DESC
  s.homepage         = "https://applicaster.com"
  s.license = 'Appache 2.0'
  s.author           = { "cmps" => "a.kononenko@applicaster.com" }
  s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => '1' }
  s.platform = :tvos, :ios
  s.tvos.deployment_target = "10.0"
  s.ios.deployment_target = '10.0'

  s.dependency 'ZappCore'
  s.dependency 'Firebase/Analytics', '= 6.14.0'

  s.requires_arc = true

  s.source_files = ['Frameworks/Plugins/Analytics/Firebase/Files/Universal/**/*.{swift}']

  s.xcconfig =  {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'ENABLE_BITCODE' => 'YES',
    'OTHER_CFLAGS'  => '-fembed-bitcode',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/Firebase/**',
    'OTHER_LDFLAGS' => '$(inherited) -objc -framework "FIRAnalyticsConnector" -framework "FirebaseAnalytics" -framework "FirebaseCore" -framework "FirebaseCoreDiagnostics" -framework "FirebaseInstanceID" -framework "GoogleAppMeasurement" -framework "GoogleDataTransport" -framework "GoogleDataTransportCCTSupport" -framework "GoogleUtilities" -framework "nanopb"',
    'USER_HEADER_SEARCH_PATHS' => '"$(inherited)" "${PODS_ROOT}"/Firebase/**'
  }
end
