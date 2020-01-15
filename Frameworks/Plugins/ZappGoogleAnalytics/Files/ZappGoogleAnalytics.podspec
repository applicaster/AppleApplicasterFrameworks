Pod::Spec.new do |s|
s.name             = "ZappGoogleAnalytics"
s.version          = '0.6.1'
s.summary          = "ZappGoogleAnalytics"
s.swift_versions = '5.1'
s.description      = <<-DESC
ZappAnalyticsPluginGAtvOS container.
DESC
s.homepage         = "https://applicaster.com"
s.license = 'Appache 2.0'
s.author           = { "cmps" => "a.zchut@applicaster.com" }
s.source = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git',
:tag => '2020.1.15.19-1-9' }
s.platform = :tvos, :ios
s.tvos.deployment_target = "10.0"
s.ios.deployment_target = '10.0'

s.dependency 'ZappCore'

s.requires_arc = true

s.source_files = ['Universal/**/*.{swift}']

s.resources = [
"Universal/CustomDimensionMapping/CustomDimensionMapping.plist"
]

s.xcconfig =  {
'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
'ENABLE_BITCODE' => 'YES',
}

    s.test_spec 'UnitTests' do |sp|
        sp.source_files = 'Tests/**'
    end
end
