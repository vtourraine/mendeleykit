# MendeleyKit the Mendeley SDK for Objective C #

Released: May 2016 (2.1.3)


## About MendeleyKit 2.1.x ##
MendeleyKit is a standalone library/framework providing convenience methods
and classes for using the [Mendeley API](http://dev.mendeley.com) in Mac OSX or
iOS applications.

Since its launch in Oct 2014 MendeleyKit has gone through a number of changes and improvements.
Version 2 of the SDK is introducing a MendeleyKitiOS dynamic framework, including Swift 2.0 code.
In addition to that some API additions were introduced (e.g. Mendeley features API enabling remote feature enabling).

Version 2 still supports MendeleyKit as a standalone static library for iOS and OSX. However, users of the SDK
should be advised that the use of static library is deprecated and may be discontinued at a future release.

## Minimum Requirements ##

### Minimum Requirements - Static Library MendeleyKit ###
XCode 6.x
iOS 7.x or higher

### Minimum Requirements - Framework ###
XCode 7
iOS 8 or higher
OSX 10.9 or higher

## Installation/Cocoapod ##
The easiest way to include MendeleyKit in your project is to use cocoapods. In order to support both
dynamic frameworks and legacy static library of MendeleyKit, we introduced separate Podspec files
- MendeleyKit.podspec: use this for static library of MendeleyKit (will not contain Swift code and some of the new APIs, such as analytics). Note this is deprecated and may be removed in future releases.
- MendeleyKitiOS.podspec - the iOS dynamic Framework. Requires iOS8 min and XCode 7
- MendeleyKitOSX.podspec - the OSX framework.

### Cocoapods for frameworks ###

#### Your client Podfile using the iOS Framework ####
Use this in your Podfile:
```ruby
use_frameworks!
pod 'MendeleyKitiOS', :git => 'https://github.com/Mendeley/mendeleykit.git'
```

*Note*: the framework supports both WebKit and UIWebView for login process (the latter is deprecated). To ensure you use the WebKit version
of the Kit you may want to include the following lines in your Podfile:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'MendeleyKitiOSFramework']
      #add any other build settings 
    end
  end
end
```
(for cocoapods versions earlier than 0.38 use installer.project.targets.each instead of installer.pods_project.targets.each)

*Note*: 
Using *use_frameworks!* means that all included dependencies will be interpreted as frameworks. At this stage there is no provision in cocoapods to selectively mark some pods as frameworks and others as static library.

Once done do a 
```bash
pod install
```

**NOTE**: Cocoapods is generating an umbrella header in its PODs folder. This has been
known to cause problems when compiling or doing a 'pod lint MendeleyKitiOS.podspec'.
The error message is '...include of non-modular header in framework...'. Cocoapods has a whole message trail for this problem
which first appeared with XCode 7.1. 
The line below is a workaround, which basically comments out the #include "MendeleyKitiOS.h" line in the pod generated umbrella header. 
This seems to fix the issue.
The example below demonstrates how this can be used in a post install instruction in a Podfile 

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'MendeleyKitiOSFramework']
      config.build_settings['ARCHS'] = '$(ARCHS_STANDARD)'
    end
  end
  `sed -i '' 's,\#import \"MendeleyKitiOS.h\",\/\/#import \"MendeleyKitiOS.h\",g' 'Pods/Target Support Files/MendeleyKitiOS/MendeleyKitiOS-umbrella.h'`
end
```

### Your client Podfile for using the static library (deprecated) ###
You can use the legacy static library of MendeleyKit using the MendeleyKit.podspec
Note: the static library of MendeleyKit will not include any Swift classes - including
the new MendeleyAnalytics classes/methods.

The Podfile in your project should include the following line

```ruby
pod 'MendeleyKit', :git => 'https://github.com/Mendeley/mendeleykit.git'
```

From command line, simply do 
```ruby
pod install
```

For further information on Cocoapods see [Cocoapods](http://cocoapods.org/).

Alternatively, you may clone the public MendeleyKit from our github repository.

## Upgrading from Previous versions of MendeleyKit ##

### Upgrading the headers/import in Objective C code for Framework ###
Using the MendeleyKitiOS framework means you will need to change your headers.
All public headers in the MendeleyKit are included in the framework umbrella header MendeleyKitiOS.h.
Please, replace all explicit MendeleyKit imports in your code with this one header.

```objc
#import <MendeleyKitiOS/MendeleyKitiOS.h>
```
You may want to use the more modern syntax
```objc
@import MendeleyKitiOS;
```
### Upgrading the headers/import for use of static library ###
*Note*: If you are using the static library version of MendeleyKit you will need to use the following syntax
(as the workspace has now modules enabled in the build sittings)

```objc
#import <MendeleyKit/MendeleyKit.h>
```

### Client build settings ###
- client should have 'Enable modules' set to Yes
- MendeleyKit currently has bitcode disabled in its settings for backward compatibility reasons. You may need to do the same in the client using the MendeleyKit framework/lib.


## Getting Started ##
MendeleyKit XCode workspace includes a MendeleyKitExample project. This demonstrates
basic functionality such as authenticating with the Mendeley server, 
obtaining a list of documents, files and groups.

It is recommended to consult with the classes contained in the MendeleyKitExample project.

In addition the github repository includes a MendeleyKitHelp.zip file. This contains
a complete reference set in HTML and Docset format.

When running the MendeleyKitExample app, please ensure you have
- client ID
- client secret key
- redirect URI 

They need to be entered in the ViewController.h file.
Note: code containing client IDs, client secrets, redirect URI will not be accepted in pull requests!

[Mendeley API](http://dev.mendeley.com) has links to create your app client id, key and redirect URIs.

## Registering a Client with the Mendeley Dev Portal ##
Every client communicating with the server needs to be registered with the Mendeley developer portal [Mendeley API](http://dev.mendeley.com).

Registration is quick, painless and free. It will give you the 3 essential ingredients you will need to supply when using the MendeleyKit in your app
- client ID
- client secret key
- redirect URI

These values need to match *exactly* the ones from the dev portal.
The redirect URI should be a fully formed URL, such as - e.g. http://localhost/myredirect (rather than just 'localhost/myredirect). This avoids any pitfalls or 'Frame load interrupted' messages in the UIWebView kit.


## How to submit code ##
This is an early-bird version of the MendeleyKit. We welcome your thoughts and suggestions. If you would like to make active contributions, e.g. code changes/additions,

- code submissions should only be made to Development branch via pull requests. 
- you may create your own subbranches from Development and submit to it at will. However, if you want to merge it into Development then you would need to create a pull request
- Note: code containing client IDs, client secrets, redirect URI will not be accepted in pull requests!


## Software Releases ##
All official releases of the MendeleyKit are tagged versions on master. Mendeley reserves the rights to merge changes made to Development into master.
Each release will contain a RELEASE text file outlining changes made.

## Reporting Issues ##
Please use the Issues feature on github to report any problems you encounter with the MendeleyKit. 
For feedback/suggestions please contact: api@mendeley.com


