Pod::Spec.new do |s|

  s.name          = "Loop"
  s.version       = "1.0.0"
  s.summary       = "Unidirectional reactive architecture"

  s.description   = <<-DESC
                    A unidirectional data flow µframework, built on top of ReactiveSwift.
                    DESC

  s.homepage      = "https://github.com/ReactiveCocoa/Loop/"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = "ReactiveCocoa Community"
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.source        = { :git => "https://github.com/ReactiveCocoa/Loop.git", :tag => "#{s.version}" }
  s.source_files  = "Loop/*.{swift}"

  s.cocoapods_version = ">= 1.7.0"
  s.swift_versions = ["5.0", "5.1"]

  s.dependency "ReactiveSwift", "~> 6.0"
end
