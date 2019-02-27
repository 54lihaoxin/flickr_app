platform :ios, '11.0'

target 'FlickrApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  source 'https://github.com/54lihaoxin/flickr_foundation.git'

  # Pods for FlickrApp

  ## 💀💀 NOTE: After there is any issue after switching between git and local version of `PokipediaFoundation`, delete `Pods` from workspace and `pod install` to update. 💀💀 ##
  #pod 'FlickrFoundation', :path => '../FlickrFoundation/FlickrFoundation.podspec' # use this to test the pod locally with the right path, otherwise use the one in the next line
  pod 'FlickrFoundation', :git => 'https://github.com/54lihaoxin/flickr_foundation.git'

  target 'FlickrAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
