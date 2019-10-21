# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'AppleApplicasterFrameworks' do
  use_frameworks!
  pod 'ZappCore', :path => './ZappCore.podspec'
  pod 'ZappGoogleAnalytics', :path => './ZappGoogleAnalytics.podspec'
  pod 'ZappGoogleInteractiveMediaAds', :path => './ZappGoogleInteractiveMediaAds.podspec'

  target 'AppleApplicasterFrameworksTests' do
    inherit! :search_paths
    pod 'ZappCore', :path => './ZappCore.podspec'
    pod 'ZappGoogleAnalytics', :path => './ZappGoogleAnalytics.podspec'
    pod 'ZappGoogleInteractiveMediaAds', :path => './ZappGoogleInteractiveMediaAds.podspec'
    
    # Pods for testing
  end

end
