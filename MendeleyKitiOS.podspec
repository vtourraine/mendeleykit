Pod::Spec.new do |s|
  s.name = "MendeleyKitiOS"
  s.version = "3.1.3"
  s.summary      = "The Mendeley Objective C client SDK."

  s.description  = <<-DESC
                   # MendeleyKit
                   The open source Mendeley Objective C Kit.

                   ## Features
                   * Access to Mendeley REST API endpoints and handling of JSON responses
                   * Provide model classes for essential Mendeley objects such as Mendeley documents
                   * OAuth2 authentication and login as well as automatic handling of access refresh
DESC
  s.homepage     = "https://github.com/Mendeley/mendeleykit"

  s.license      = 'Apache Licence, Version 2.0'

  s.authors      = { "Mendeley iOS" => "ios@mendeley.com"}
  s.requires_arc  = true
  s.source       = { :git => "https://github.com/Mendeley/mendeleykit.git", :tag => "3.1.3" }
  s.module_name = "MendeleyKitiOS"
  s.ios.deployment_target = '8.0'
  s.source_files  = "MendeleyKit/MendeleyKitiOS/MendeleyKitiOS.h", "MendeleyKit/MendeleyKit/*.h", "MendeleyKit/MendeleyKit/**/*.{h,m,swift}"
  s.resource_bundles = {
    'MendeleyKitiOS' => ['MendeleyKit/MendeleyKit/**/*.{storyboard,xib}']
  }
end
