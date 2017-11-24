# MendeleyKit — the Mendeley SDK for Objective-C/Swift #

Latest Release: November 2017 (3.2.1)


## About MendeleyKit 3.x ##
MendeleyKit is a standalone framework providing convenience methods
and classes for using the [Mendeley API](http://dev.mendeley.com) in iOS and
OS X applications.

Since its launch in October 2014, MendeleyKit has gone through a number of changes and improvements.
Version 3 of the SDK no longer provides static libraries. Instead we provide builds for OSX and iOS dynamic frameworks.
In addition to that, some API additions were introduced (e.g. Mendeley features API enabling remote feature enabling).

Much of the code in the SDK is still based on Objective C. However, over the coming months we will be gradually migrating
towards Swift (3 or later).

## Minimum Requirements ##

Xcode 8
iOS 8.0 or higher
OS X 10.9 or higher

## Installation (CocoaPods) ##
The easiest way to include MendeleyKit in your project is to use CocoaPods. In order to support both
dynamic frameworks for both OSX and iOS we provide two separate Podspec files
- `MendeleyKitiOS.podspec`: the iOS dynamic framework. Requires iOS 9.1 min and Xcode 8.x
- `MendeleyKitOSX.podspec`: the OS X framework.

### CocoaPods for frameworks ###

#### Your client Podfile using the iOS Framework ####
Use this in your Podfile:
```ruby
use_frameworks!
pod 'MendeleyKitiOS', :git => 'https://github.com/Mendeley/mendeleykit.git'
```

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'MendeleyKitiOSFramework']
      #add any other build settings 
    end
  end
end
```
(for CocoaPods versions earlier than 0.38, use `installer.project.targets.each` instead of `installer.pods_project.targets.each`)

*Note*: Using `use_frameworks!` means that all included dependencies will be interpreted as frameworks. At this stage, there is no provision in CocoaPods to selectively mark some pods as frameworks and others as static libraries.

Once done do a 
```bash
Once done, do a:
```
pod install
```

**Note**: CocoaPods is generating an umbrella header in its Pods folder. This has been
known to cause problems when compiling or doing a `pod lint MendeleyKitiOS.podspec`.
The error message is '...include of non-modular header in framework...'. CocoaPods has a whole message trail for this problem which first appeared with Xcode 7.1.
The line below is a workaround, which basically comments out the `#include "MendeleyKitiOS.h"` line in the pod generated umbrella header.
This seems to fix the issue.
The example below demonstrates how this can be used in a post-install instruction in a Podfile:

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


Alternatively, you may clone the public MendeleyKit from our github repository.

## Upgrading from Previous versions of MendeleyKit ##

### Upgrading the headers/import in Objective-C code for Framework ###
Using the MendeleyKitiOS framework means you will need to change your headers.
All public headers in MendeleyKit are included in the framework umbrella header `MendeleyKitiOS.h`.
Please, replace all explicit MendeleyKit imports in your code with this one header.

```objc
#import <MendeleyKitiOS/MendeleyKitiOS.h>
```
You may want to use the more modern syntax
```objc
You may want to use the more modern syntax:
```
@import MendeleyKitiOS;
```
### Upgrading the headers/import for use of static library ###
*Note*: if you are using the static library version of MendeleyKit, you will need to use the following syntax
(as the workspace has now modules enabled in the build sittings):

```objc
#import <MendeleyKit/MendeleyKit.h>
```

### Client build settings ###
- client should have `Enable modules` set to `Yes`
- MendeleyKit currently has bitcode generation disabled in its settings for backward compatibility reasons. You may need to do the same in the client using the MendeleyKit framework/library.


## Getting Started ##
The MendeleyKit Xcode workspace includes a MendeleyKitExample project. This demonstrates
basic functionality such as authenticating with the Mendeley server, 
obtaining a list of documents, files and groups.

It is recommended to consult with the classes contained in the MendeleyKitExample project.

In addition, the GitHub repository includes a `MendeleyKitHelp.zip` file. This contains
a complete reference set in HTML and Docset formats.

When running the MendeleyKitExample app, please ensure you have:
- client ID
- client secret key
- redirect URI 

They need to be entered in the `ViewController.h` file.
Note: code containing client IDs, client secrets, redirect URI will not be accepted in pull requests!

[Mendeley API](http://dev.mendeley.com) has links to create your app client ID, key and redirect URIs.

## Registering a Client with the Mendeley Dev Portal ##
Every client communicating with the server needs to be registered with the Mendeley developer portal [Mendeley API](http://dev.mendeley.com).

Registration is quick, painless and free. It will give you the 3 essential ingredients you will need to supply when using MendeleyKit in your app:
- client ID
- client secret key
- redirect URI

These values need to match *exactly* the ones from the dev portal.
The redirect URI should be a fully formed URL, such as `http://localhost/myredirect` (rather than just `localhost/myredirect`). This avoids any pitfalls or 'Frame load interrupted' messages in UIWebView.


## How to Submit Code ##
This is an early-bird version of MendeleyKit. We welcome your thoughts and suggestions. If you would like to make active contributions, e.g. code changes/additions:

- code submissions should only be made to `Development` branch via pull requests.
- you may create your own subbranches from `Development` and submit to it at will. However, if you want to merge it into `Development` then you would need to create a pull request.
- **Note**: code containing client IDs, client secrets, redirect URI will not be accepted in pull requests!


## Software Releases ##
All official releases of MendeleyKit are tagged versions on `master`. Mendeley reserves the rights to merge changes made to `Development` into `master`.
Each release will contain a `RELEASE` text file outlining changes made.

## Reporting Issues ##
Please use the Issues feature on GitHub to report any problems you encounter with MendeleyKit.
For feedback/suggestions, please contact: api@mendeley.com
