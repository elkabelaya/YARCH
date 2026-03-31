# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'YARCH' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for YARCH
  pod 'SnapKit'
  pod 'SwiftLint'

  target 'YARCHTests' do
    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
  end

end

target 'TV' do
platform :tvos, '16.0'
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TV
  pod 'SnapKit'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0' # Or your desired version
    end
  end
end
