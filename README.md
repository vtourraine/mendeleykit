# MendeleyKit the Mendeley SDK for Objective C #

Version: 0.5.0 alpha

Released: October 2014

** Important notice: this is an early pre-release version and is subject to change **

## About MendeleyKit ##
MendeleyKit is a standalone Objective C library providing convenience methods
and classes for using the [Mendeley API](http://dev.mendeley.com) in Mac OSX or
iOS applications.

## Minimum Requirements ##

XCode 5.1.1
iOS 6.x, Mac OSX 10.8

## Installation/Cocoapod ##
The easiest way to include MendeleyKit in your project is to use cocoapods.
The Podfile in your project should include the following line

```
pod 'MendeleyKit', :git => 'https://github.com/Mendeley/mendeleykit.git'
```

From command line, simply do 
```
pod install
```

For further information on Cocoapods see [Cocoapods](http://cocoapods.org/).

Alternatively, you may clone the public MendeleyKit from our github repository.

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

[Mendeley API](http://dev.mendeley.com) has links to create your app client id, key and redirect URIs.



