/*
 ******************************************************************************
 * Copyright (C) 2014-2017 Elsevier/Mendeley.
 *
 * This file is part of the Mendeley iOS SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *****************************************************************************
 */

#import "MendeleyURLBuilder.h"
#import <UIKit/UIKit.h>
#import "NSError+MendeleyError.h"

@implementation MendeleyURLBuilder
+ (NSURL *)urlWithBaseURL:(NSURL *)baseURL parameters:(NSDictionary *)parameters query:(BOOL)query
{
    [NSError assertArgumentNotNil:baseURL argumentName:@"baseURL"];
    [NSError assertArgumentNotNil:parameters argumentName:@"parameters"];
    if (0 == parameters.allKeys.count)
    {
        return baseURL;
    }
    NSMutableString *mutableURLString = [NSMutableString stringWithString:[baseURL absoluteString]];
    NSString *parameterString = (query) ? @"?" : @"&";
    if ([mutableURLString hasSuffix:@"/"])
    {
        [mutableURLString replaceCharactersInRange:NSMakeRange(mutableURLString.length - 1, 1)
                                        withString:parameterString];
    }
    else
    {
        [mutableURLString appendString:parameterString];
    }
    NSString *keyValuePairs = [[self class] httpBodyStringFromParameters:parameters];
    if (nil != keyValuePairs && 0 < keyValuePairs.length)
    {
        NSString *urlEncoded = [keyValuePairs
                                stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [mutableURLString appendString:urlEncoded];
    }
    return [NSURL URLWithString:mutableURLString];
}

+ (NSString *)httpBodyStringFromParameters:(NSDictionary *)parameters
{
    [NSError assertArgumentNotNil:parameters argumentName:@"parameters"];
    if (0 == parameters.allKeys.count)
    {
        return @"";
    }
    __block NSMutableString *httpBodyString = [NSMutableString string];
    NSString *addString = @"&";
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
         NSString *urlEncodedValue = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         urlEncodedValue = [urlEncodedValue stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
         [httpBodyString appendFormat:@"%@=%@", key, urlEncodedValue];
         [httpBodyString appendString:addString];
     }];
    [httpBodyString deleteCharactersInRange:NSMakeRange(httpBodyString.length - 1, 1)];
    return httpBodyString;
}

+ (NSData *)httpBodyFromParameters:(NSDictionary *)parameters
{
    [NSError assertArgumentNotNil:parameters argumentName:@"parameters"];
    if (0 == parameters.allKeys.count)
    {
        return [NSData data];
    }
    NSString *bodyString = [[self class] httpBodyStringFromParameters:parameters];

    return [bodyString dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSDictionary *)defaultHeader
{
    static NSMutableDictionary *header = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      header = [NSMutableDictionary dictionary];
                      NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *) kCFBundleExecutableKey] ? : [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *) kCFBundleIdentifierKey];
                      NSString *bundleVersion = (__bridge id) CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ? : [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *) kCFBundleVersionKey];


                      if (nil == bundleName)
                      {
                          bundleName = @"MendeleyClient";
                      }

                      if (nil == bundleVersion)
                      {
                          bundleVersion = @"30000";
                      }
                      NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
                      [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                           float q = 1.0f - (idx * 0.1f);
                           [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
                           *stop = q <= 0.5f;
                       }];

                      [header setObject:[acceptLanguagesComponents componentsJoinedByString:@", "]
                                 forKey:kMendeleyOAuth2AcceptLanguageKey];

                      NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", bundleName, bundleVersion, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];

                      [header setObject:userAgent forKey:kMendeleyOAuth2UserAgentKey];

                      NSString *clientVersionString = [NSString stringWithFormat:@"%@/%@ (%@ iOS %@)",
                                                       bundleName,
                                                       bundleVersion,
                                                       [[UIDevice currentDevice] model],
                                                       [[UIDevice currentDevice] systemVersion]];
                      [header setObject:clientVersionString forKey:kMendeleyOAuth2ClientVersionKey];
                  });
    return header;
}

@end
