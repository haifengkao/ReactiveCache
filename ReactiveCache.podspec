#
# Be sure to run `pod lib lint ReactiveCache.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ReactiveCache"
  s.version          = "0.12.0"
  s.summary          = "Cache for ReactiveCocoa."
  s.description      = <<-DESC
                       A cache interface for ReactiveCocoa. The underlying cache is HanekeSwift.

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/haifengkao/ReactiveCache"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Hai Feng Kao" => "haifeng@cocoaspice.in" }
  s.source           = { :git => "https://github.com/haifengkao/ReactiveCache.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
# s.resource_bundles = {
#    'ReactiveCache' => ['Pod/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'ReactiveCocoa', '~> 2.0' # swift module needs all ReactiveCocoa headers
  s.dependency 'HanekeObjc'
end
