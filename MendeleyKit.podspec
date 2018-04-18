Pod::Spec.new do |s|
  s.name = "MendeleyKit"
  s.version = "3.3.0"
  s.summary = "The Mendeley Objective-C/Swift client SDK."
  s.description = <<-DESC
                  # MendeleyKit
                  The open source Mendeley Objective-C/Swift Kit.

                  ## Features
                  * Access to Mendeley REST API endpoints and handling of JSON responses
                  * Provide model classes for essential Mendeley objects such as Mendeley documents
                  * OAuth2 authentication and login as well as automatic handling of access refresh
DESC
  s.homepage = "https://github.com/Mendeley/mendeleykit"
  s.license = 'Apache Licence, Version 2.0'
  s.authors = { "Mendeley iOS" => "ios@mendeley.com"}

  s.source = { :git => "https://github.com/Mendeley/mendeleykit.git", :tag => "3.3.0" }
  s.module_name  = "MendeleyKit"
  s.swift_version = '3.2'
  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.ios.source_files = "MendeleyKit/MendeleyKit/*.h", "MendeleyKit/MendeleyKit/**/*.{h,m,swift}"

  s.macos.deployment_target = '10.9'
  s.macos.source_files = "MendeleyKit/MendeleyKitOSX/AppKit", "MendeleyKit/MendeleyKit/*.h", "MendeleyKit/MendeleyKit/**/*.{h,m,swift}"
  s.macos.exclude_files = 'MendeleyKit/MendeleyKit/UIKit/*.{h,m,swift}'
end
