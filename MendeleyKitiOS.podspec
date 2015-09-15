Pod::Spec.new do |s|
  s.name = "MendeleyKitiOS"
  s.version = "1.1.0"
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
  s.source       = { :git => "https://github.com/Mendeley/mendeleykit.git", :tag => "1.1.0" }
  s.module_name = "MendeleyKitiOS"
  s.ios.deployment_target = '7.0'
  s.source_files  = "MendeleyKit/MendeleyKitiOS/MendeleyKitiOS.h", "MendeleyKit/MendeleyKit/*.h", "MendeleyKit/MendeleyKit/**/*.{h,m,swift}"
end
