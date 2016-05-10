Pod::Spec.new do |s|
  s.name             = "SwiftyMavenlink"
  s.version          = "0.1.0"
  s.summary          = "An SDK library for MavenLink written in Swift."

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = "https://github.com/hathway/SwiftyMavenlink"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Mike Maxwell" => "mike@wearehathway.com" }
  s.source           = { :git => "https://github.com/hathway/SwiftyMavenlink.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/wearehathway'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftyMavenlink/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftyMavenlink' => ['SwiftyMavenlink/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "SwiftyJSON"
  s.dependency "JSONRequest"
end
