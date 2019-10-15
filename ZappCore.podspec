
Pod::Spec.new do |s|
  s.name             = 'ZappCore'
  s.version          = '0.1.0'
  s.summary          = 'General Applicaster iOS and tvOS framework that provides protocol'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/a.kononenko@applicaster.com/ZappCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'a.kononenko@applicaster.com' => 'a.kononenko@applicaster.com' }
  s.source           = { :git => 'https://github.com/applicaster/AppleApplicasterFrameworks.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Frameworks/ZappCore/**/*.{swift}'
end
