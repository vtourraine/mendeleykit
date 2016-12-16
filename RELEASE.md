RELEASE NOTES
Date: December (3.0.0)
- removed MendeleyKit static library target and scheme
- converted code to Swift 3
- added new methods to support better cloning of documents from one group to another

Date: September (2.2.1)
- correct import of authors and editors from a JSON catalog document

Date: August (2.2.0)
- added datasets model and API methods and classes to support research data handling in the SDK
- added /photos/me to enable upload of profile pictures
- OSX dynamic framework improvements
- general cleanup of code (including Swift 2.2) and unit tests


Date: May 2016 (2.1.3)
- getting ready for Carthage dependency (updated .gitignore) and some changes to make things easier for OSX (modulemap and login controller)

Date: April 2016 (2.1.2)
- made one of the converter helper methods in MendeleyModeller public (dictionaryFromModel:

Date: February 2016 (2.1.1)
- request header accept type for /user_roles and /subject_areas endpoints changed in Mendeley API. Changes made to the relevant methods in the MendeleyKit

Date: February 2016 (2.1.0)
- added custom colour handling for annotations
- academicStatusWithCompletionBlock and disciplinesWithCompletionBlock API methods are deprecated. 
Users should use API methods userRolesWithCompletionBlock and subjectAreasWithCompletionBlock instead

Date: December 2015 (2.0.0)
- introduced 2 more podspec files for the generation of dynamic frameworks
- various bug fixes 
- analytics is now part of the framework 

Date: July 2015 (1.1.1)
- follower API methods should return a MendeleyTask object rather than void

Date: July 2015 (1.1.0)
- support for the /followers API has been added to the SDK
- bug fix for login window which prevented users from clicking on the 'forgot' password link
- other minor bug fixes

Date: June 2015 (1.0.12)
- the checking of refresh token validity needs to save the retrieved refresh token as it is not guaranteed to remain the same.

Date: May 2015 (1.0.11)
- more consistent use of MendeleySecureObject and MendeleyObject in API handling
- updated time format to include the correct time zone
- improve error handling for file downloads. Downloaded data (including JSON error messages) are streamed directly to file location. We read the error message and ensure that the failed file download is removed.


Date: April 2015 (v1.0.7)
- Added followers/recently_read APIs
- added a method to get a list of 'authored' documents
- update JSON to reflect recent API changes (recently_read_id becomes id)
- JSON modeller needs to check for MendeleyObject and MendeleySecureObject consistently

Date: April 2015 (v1.0.6):
- the MendeleyDefaultOAuthProvider cannot assume the MendeleyResponse object to be nil if/when an error occurs. Proper parsing is required to ensure that error handling is appropriate.

Date: April 2015:
- checkAuthorisationStatusWithCompletionBlock now returns a cancellable MendeleyTask object
- minor bug fix in addRecentlyRead to ensure the right completion handler is being executed

Date: March 2015
- a small change in the oauth handling to ensure that execution of completion handlers is done on main thread.

Date: March 2015
- added checkAuthorisationStatusWithCompletionBlock to check if authentication is still valid (e.g. after user changed password elsewhere)
- added recentlyReadWithParameters:completionBlock to get a list of recently read PDF files from the server. This is a new API service
- added addRecentlyRead:completionBlock to allow users to mark PDFs they opened to a 'recently read' list. This is a new API service

Date: March 2015
It's time to make this release the official 1.0.0 version of MendeleyKit.
This version has a minor upgrade from 0.9.20
- fixing an issue with rotating login screen and resizing

Date: March 2015
- we added 4 new methods to the MendeleyKit
- academicStatusesWithCompletionBlock to obtain a list of Mendeley academic status types
- disciplinesWithCompletionBlock to obtain a list of Mendeley discipline types
- createProfile:completionBlock creating a new profile
- updateMyProfile:completionBlock updating an existing profile
Additional Notes:
- createProfile and updateMyProfile use 'special' profile classes. (MendeleyNewProfile and MendeleyAmendmentProfile). This is due to the fact that the expected JSON body in both cases differ in subtle ways from the default profiles JSON body.
- an additional method was added to the MendeleyOAuthProvider (and its MendeleyDefaultOAuthProvider implementation) to authenticate with username and password. This will allow clients to create profiles using the new MendeleyKit methods. 
- clients can ONLY create profiles and/or authenticate with username/password if the client has been approved for this service by the Mendeley team. To apply for your client to be approved visit http://dev.mendeley.com. 

Date: February 2015
- aligned MendeleyProfile model with latest version of /profiles API

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


