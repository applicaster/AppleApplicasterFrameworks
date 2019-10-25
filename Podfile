source 'git@github.com:applicaster/CocoaPods.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '10.0'

target 'AppleApplicasterFrameworks' do
  use_frameworks!
  # pod 'ZappCore'
  pod 'ZappCore', :path => './ZappCore.podspec'
  pod 'ZappGoogleAnalytics', :path => './ZappGoogleAnalytics.podspec'
  pod 'ZappGoogleInteractiveMediaAds', :path => './ZappGoogleInteractiveMediaAds.podspec'

  target 'AppleApplicasterFrameworksTests' do
    inherit! :search_paths
    # pod 'ZappCore'
    pod 'ZappCore', :path => './ZappCore.podspec'
    pod 'ZappGoogleAnalytics', :path => './ZappGoogleAnalytics.podspec'
    pod 'ZappGoogleInteractiveMediaAds', :path => './ZappGoogleInteractiveMediaAds.podspec'
    
    # Pods for testing
  end

end
