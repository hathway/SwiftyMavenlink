Pod::Spec.new do |s|

  s.name         = "SwiftyMavenlink"
  s.version      = "0.0.1"
  s.summary      = "A short description of SwiftyMavenlink."

  s.homepage     = "https://github.com/hathway/SwiftyMavenlink"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  s.author             = { "Mike Maxwell" => "mike@wearehathway.com" }
  s.social_media_url   = "http://twitter.com/themisterwell"

  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/hathway/SwiftyMavenlink.git", :tag => s.version }
  s.source_files  = "Sources/**/*.swift"

  s.dependency "SwiftyJSON"
  s.dependency "JSONRequest"

end
