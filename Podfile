# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyOutdoorAgent' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyOutdoorAgent
    pod 'IQKeyboardManager'
    pod 'SDWebImage'
    pod 'DropDown'
    pod 'GoogleMaps'
    pod 'PKHUD'
    pod 'Alamofire', '~> 5.5'
    pod 'FacebookSDK'
    pod 'FBSDKLoginKit'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod 'GoogleSignIn'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'FSCalendar'
    pod 'Google-Maps-iOS-Utils', '~> 4.1.0'
    pod 'DPOTPView'
    pod "RecaptchaEnterprise", "18.6.0-beta02"
end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                  config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
                  config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
               end
          end
   end
end
