
Pod::Spec.new do |s|
  s.name             = "ZappGoogleAnalytics"
  s.version          = '0.4.0'
  s.summary          = "ZappGoogleAnalytics"
  s.swift_versions = '5.1'
  s.description      = <<-DESC
                      ZappAnalyticsPluginGAtvOS container.
                       DESC
  s.homepage         = "https://applicaster.com"
  s.license = 'Appache 2.0'
  s.author           = { "cmps" => "a.zchut@applicaster.com" }
  s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => '1' }
  s.platform = :tvos, :ios
  s.tvos.deployment_target = "10.0"
  s.ios.deployment_target = '10.0'

  s.dependency 'ZappCore'
  
  s.requires_arc = true

  s.source_files = ['Frameworks/Plugins/Analytics/GoogleAnalytics/Universal/**/*.{swift}']

  s.resources = [
    "Frameworks/Plugins/Analytics/GoogleAnalytics/universal/CustomDimensionMapping/CustomDimensionMapping.plist"
  ]

  s.xcconfig =  {
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'ENABLE_BITCODE' => 'YES',
  }
end
