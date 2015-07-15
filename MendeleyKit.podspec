Pod::Spec.new do |s|
  s.name = "MendeleyKit"
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
  s.source       = { :git => "https://github.com/Mendeley/mendeleykit.git", :tag => "1.0.9" }
  s.default_subspec = 'Standard'

  s.subspec 'Standard' do |standard|
     standard.source_files  = 'MendeleyKit', 'MendeleyKit/**/*.{h,m}'
     standard.exclude_files = 'MendeleyKit/MendeleyKitTests', 'MendeleyKit/MendeleyKitExample'     standard.ios.deployment_target = '7.0'
     standard.osx.deployment_target = '10.8'
     standard.ios.exclude_files = 'MendeleyKit/MendeleyKitOSX'
     standard.osx.exclude_files = 'MendeleyKit/**/UIKit/*.{h,m}', 'MendeleyKit/MendeleyKitiOS'
     standard.ios.frameworks  = 'MobileCoreServices', 'SystemConfiguration', 'Security', 'Foundation'
     standard.osx.frameworks  = 'Foundation', 'CoreFoundation', 'AppKit', 'Security', 'WebKit', 'CoreServices'
     standard.prefix_header_contents = <<-EOS
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

  s.subspec 'iOSFramework' do |framework|
    framework.module_name = "MendeleyKitiOS"
    framework.ios.deployment_target = '8.0'
    framework.source_files  = "MendeleyKit/MendeleyKitiOS/MendeleyKitiOS.h", "MendeleyKit/MendeleyKit/*.h", "MendeleyKit/MendeleyKit/**/$
  end
end
