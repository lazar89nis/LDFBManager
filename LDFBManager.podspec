Pod::Spec.new do |s|

s.platform = :ios
s.name             = "LDFBManager"
s.version          = "1.0.1"
s.summary          = "This is internal library."

s.description      = <<-DESC
This is internal library. I will not add new functions on request.
DESC

s.homepage         = "https://github.com/lazar89nis/LDFBManager"
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author           = { "Lazar" => "lazar89nis@gmail.com" }
s.source           = { :git => "https://github.com/lazar89nis/LDFBManager.git", :tag => "#{s.version}"}

s.ios.deployment_target = "9.0"
s.source_files = "LDFBManager", "LDFBManager/*", "LDFBManager/**/*"

s.dependency 'FacebookCore'
s.dependency 'FacebookLogin'
s.dependency 'FacebookShare'
s.dependency 'FBSDKCoreKit'
s.dependency 'FBSDKLoginKit'
s.dependency 'FBSDKShareKit'

end
