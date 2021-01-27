# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

target 'InformationSystem' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  # Pods for InformationSystem
	pod 'Kanna', '~> 5.0.0'
	pod 'IQKeyboardManagerSwift'
	pod "SkeletonView"
	pod 'SwiftyJSON', '~> 4.0'
	pod 'SwiftEmptyState'
	pod 'SwiftSoup'
	pod 'Firebase/Analytics'
	pod 'Firebase/Messaging'
	pod 'Firebase/Functions'
	pod 'Firebase/Crashlytics'
	pod 'SwiftKeychainWrapper'
	pod 'Solar'
end


deployment_target = '13.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |bc|
            bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end