Pod::Spec.new do |s|
  s.name             = "APESuperHUD"
  s.summary          = ""
  s.version          = "0.2"
  s.homepage         = "https://github.com/apegroup/APESuperHUD"
  s.license          = 'MIT'
  s.author           = { "apegroup AB" => "support@apegroup.com" }
  s.source           = { :git => "https://github.com/apegroup/APESuperHUD.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/apegroup'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'

  s.frameworks = 'UIKit', 'Foundation'
end
