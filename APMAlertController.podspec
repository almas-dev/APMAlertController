#
# Be sure to run `pod lib lint APMAlertController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "APMAlertController"
  s.version          = "0.9.1"
  s.summary          = "AlertController written in Swift 3"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
Light and convenient replacement for UIAlertController with many customization options
                         DESC

  s.homepage         = "https://github.com/almas-dev/APMAlertController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alexander Maslennikov" => "almas.dev@gmail.com" }
  s.source           = { :git => "https://github.com/almas-dev/APMAlertController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  # s.resource_bundles = {
  #   'APMAlertController' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
      ss.source_files = 'Pod/Classes/**/*'
      ss.dependency 'SnapKit', '~>3.0.0'
  end

end
