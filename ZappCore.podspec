
Pod::Spec.new do |s|
  s.name             = 'ZappCore'
  s.version          = '0.1.0'
  s.summary          = 'General Applicaster iOS and tvOS framework that provides protocol'
  s.swift_versions = ['5.0', '5.1']

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'General Applicaster iOS and tvOS framework that provides protocol and this lowest hierarchy layer'


  s.homepage         = 'https://github.com/applicaster/AppleApplicasterFrameworks.git'
  s.license          = { :type => 'Appache 2.0', :file => 'LICENSE' }
  s.author           = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'Frameworks/ZappCore/**/*.{swift}'
end
