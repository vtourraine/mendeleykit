Pod::Spec.new do |s|
  s.name              = "MendeleyKitOSX"
  s.version           = "3.2.1"
  s.summary           = "The Mendeley Objective C client SDK."

  s.description       = <<-DESC
                   # MendeleyKit
                   The open source Mendeley Objective C Kit.

                   ## Features
                   * Access to Mendeley REST API endpoints and handling of JSON responses
                   * Provide model classes for essential Mendeley objects such as Mendeley documents
                   * OAuth2 authentication and login as well as automatic handling of access refresh
DESC
  s.homepage          = "https://github.com/Mendeley/mendeleykit"

  s.license           = 'Apache Licence, Version 2.0'

  s.authors           = { "Mendeley iOS" => "ios@mendeley.com"}
  s.requires_arc      = true
  s.source            = { :git => "https://github.com/Mendeley/mendeleykit.git", :tag => "3.2.1" }
  s.module_name       = "MendeleyKitOSX"
  s.osx.deployment_target = '10.10'
  s.source_files      = "MendeleyKit/MendeleyKitOSX/MendeleyKitOSX.h", "MendeleyKit/MendeleyKitOSX/AppKit", "MendeleyKit/MendeleyKit/*.h", "MendeleyKit/MendeleyKit/**/*.{h,m,swift}"
  s.frameworks        = 'Foundation', 'CoreFoundation', 'AppKit', 'Security', 'WebKit', 'CoreServices'
  s.osx.exclude_files     = 'MendeleyKit/MendeleyKit/UIKit/*.{h,m,swift}'
end
