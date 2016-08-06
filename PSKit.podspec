#
# Be sure to run `pod lib lint PSKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PSKit"
  s.version          = "1.0.2"
  s.summary          = "PSKit."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  PSKit不再维护
                       DESC

  s.homepage         = "https://github.com/poi-son/PSKit"
  s.license          = 'MIT'
  s.author           = { "Alan Yeh" => "git@yerl.cn" }
  s.source           = { :git => "https://github.com/poi-son/PSKit.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'PSKit/Classes/**/*'
  s.public_header_files = 'PSKit/Classes/**/*.h'
end
