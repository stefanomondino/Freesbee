# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
def shared_pods
pod 'Boomerang', :path => "../Boomerang"
pod 'Gloss'
pod 'Moya/RxSwift'


pod 'pop'
pod 'MBProgressHUD'


pod 'Fabric'
pod 'Crashlytics'

pod 'SnapKit', '~> 3.0.2'


pod 'Localize-Swift'
pod 'AlamofireImage'

pod 'Action', :git => "https://github.com/RxSwiftCommunity/Action.git"
pod 'MZFormSheetPresentationController'

pod 'Hero'
end
def ios_pods
    pod 'SpinKit'
    pod 'RMActionController'
    pod 'FBSDKLoginKit'
    pod 'ActiveLabel'
    pod 'Lockbox'
    pod 'IDMPhotoBrowser'
end

def tvos_pods
    pod 'ParallaxView'
end
target 'Freesbee' do
  use_frameworks!
  shared_pods
  ios_pods
  
end

target 'FreesbeeTV' do
    use_frameworks!
    shared_pods
    tvos_pods
end
