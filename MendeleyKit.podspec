Pod::Spec.new do |s|

  s.name         = "MendeleyKit"
  s.version      = "0.8.7"
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

  s.platform     = :ios, '7.0'

  s.requires_arc  = true

  s.source       = { :git => "https://github.com/Mendeley/mendeleykit.git", :tag => "0.8.7" }

  s.source_files  = 'MendeleyKit', 'MendeleyKit/**/*.{h,m}'
  s.exclude_files = 'MendeleyKit/MendeleyKitTests', 'MendeleyKit/MendeleyKitExample'

  s.ios.frameworks  = 'MobileCoreServices', 'SystemConfiguration', 'Security', 'Foundation'

  s.prefix_header_contents = <<-EOS
  #ifdef __OBJC__
    #import <Security/Security.h>
    #if __IPHONE_OS_VERSION_MIN_REQUIRED
      #import <SystemConfiguration/SystemConfiguration.h>
      #import <MobileCoreServices/MobileCoreServices.h>
    #else
      #import <SystemConfiguration/SystemConfiguration.h>
      #import <CoreServices/CoreServices.h>
    #endif
    #import "MendeleyLog.h"
    #import "MendeleyGlobals.h"
    #import "MendeleyError.h"
    #import "MendeleyErrorManager.h"
    #import "NSError+Exceptions.h"
  #endif /* __OBJC__*/
  EOS

end
