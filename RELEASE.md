Release Notes MendeleyKit v0.9.19
Date: February 2015
- aligned MendeleyProfile model with latest version of /profiles API

Previous Releases
Date: February 2015
- we need to have a way of capturing cancelled network ops. We amended the MendeleyKit:isSuccessForResponse to return false if the network operation is cancelled.

Date: February 2015
- ensure that completion handling block is called when cancelling file downloads

Release Notes MendeleyKit v0.9.16
Date: January 2015
- added 2 methods in MendeleyKit to allow getting user's profile photos/icons. 

Date: January 2015
- ensure that CGRect in MendeleyAnnotation is encoded/decoded using the appropriate methods to iOS and OSX respectively.

Release Notes MendeleyKit v0.9.13
Date: January 2015
- updated error log for 404 server errors (not found) to include failing API

Release Notes MendeleyKit v0.9.11
Date: January 2015
- fix an issue with server responses containing new (i.e. new to the MendeleyKit) JSON properties

Release Notes MendeleyKit v0.9.9

Date: December 2014
- added an OSX example target to MendeleyKit workspace
- renamed Reachability to MendeleyReachability upon user request

Date: November 2014

The latest version of Mendeley Kit includes
- Mac OSX target and definition in podspec
- added methods for checking deleted_since for documents, files and annotations in groups as well as library


NOTES:
- Please read the LICENCE file and README.md

## MendeleyKit ##
This is the first public alpha release of MendeleyKit, the Objective-C SDK. Its purpose is to provide clients convenience methods and classes to interface with the Mendeley API.

## Min Requirements ##
- iOS 7.0 or higher
- for development XCode 5 or higher

(support for Mac OSX will be added in a later stage)

## Supported API calls ##

The following APIs are supported in 0.8.1
- /documents
- /folders
- /profiles
- /groups
- /trash
- /profiles
- /annotations
- /catalog: Only GET /catalog (with search params) and GET /catalog/{catalog_id}
- /identifier_types
- /document_types

All supported API calls are defined in MendeleyKit.h

## Not supported API calls ##
The following APIs are not supported in 0.8.1
- /search/catalog
- /enrichments/entities/{file hash}/systems
- create document from file (POST /documents with file/content-type)
- /enrichments/toc/{file hash}
- /disciplines
- /academic_statuses


## Getting started ##
We strongly recommend using cocoapods to include MendeleyKit into your project.
MendeleyKit comes with a MendeleyKit.podspec file.

Your project needs to create a Podfile with the following line in it
```
pod 'MendeleyKit', :git => 'https://github.com/Mendeley/mendeleykit.git'
```

From command line, simply do 
```
pod install
```
For further information on Cocoapods see [Cocoapods](http://cocoapods.org/).

## Registering your app to use with MendeleyKit ##
In order to use MendeleyKit in your client you will need to register your app at the 
[Mendeley API developer portal](http://dev.mendeley.com).

Registering an app will give you
- a client ID
- a client secret
- a redirect URI (this is used during OAuth authentication process)

In your client app, your first call should be to
[[MendeleyKitConfiguration sharedInstance] configureOAuthWithParameters:parameters];

where parameters is a dictionary containing the following key/value pairs
- kMendeleyOAuth2ClientIDKey : <your client ID>
- kMendeleyOAuth2ClientSecretKey : <your client secret>
- kMendeleyOAuth2RedirectURLKey : <your redirect URI>

## Using MendeleyKit ##
the Kit comes with example code to help you on your way

- Login process: MendeleyKit provides a MendeleyLoginController (UIViewController). This helper class provides users with the necessary web-access to authenticate on Mendeley. An example for this is provided in the ViewController.class in the MendeleyKitExample project

- MendeleyKit defines all supported API calls. All client calls should be made through methods defined in MendeleyKit

- as is usual these days, most methods in MendeleyKit make use of block based structure.

Examples obtaining a list of documents with specified query parameters
```
- (void)documentListWithQueryParameters:(MendeleyDocumentParameters *)queryParameters
                        completionBlock:(MendeleyArrayCompletionBlock)completionBlock;
```


