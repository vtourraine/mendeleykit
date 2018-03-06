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

#import <Foundation/Foundation.h>
#import "MendeleyGlobals.h"
@class MendeleyObject;

@interface MendeleyModeller : NSObject
/**
   returns a singleton for the modeller
 */
+ (nonnull MendeleyModeller *)sharedInstance;

/**
   @param jsonData should be already deserialized JSON data, either NSArray or NSDictionary
   @param expectedType
   @param completionBlock will return either a MendeleyObject type model class or an NSArray of model objects
 */
- (void)parseJSONData:(nonnull id)jsonData
         expectedType:(nonnull NSString *)expectedType
      completionBlock:(nonnull void (^) (id __nullable parsedObject, NSError *__nullable error))completionBlock;

/**
   converts an existing Model class into a serialized JSON object (NSData)
   @param model can either be a model object or an array of model objects
   @param error
   @return a serialized NSData JSON object or nil if error
 */
- (nullable NSData *)jsonObjectFromModelOrModels:(nonnull id)model error:(NSError *__nullable *__nullable)error;

/**
   in some cases the API returns a simple array of dictionary of ID strings. E.g.
   folders/{id}/documents
 */
- (void)parseJSONArrayOfIDDictionaries:(nullable NSArray *)jsonArray
                       completionBlock:(nullable MendeleyStringArrayCompletionBlock)completionBlock;


/**
   a simple JSON converter for string IDs to JSON. This will end up like
   {
    "id" : "xxxxx-xxxx-xxxx-xxxxxxxxx"
   }
   @param objectID
   @param error
   @return JSON object as NSData or nil if error
 */
- (nullable NSData *)jsonObjectForID:(nonnull NSString *)objectID error:(NSError *__nullable *__nullable)error;

/**
 *    converts an existing Model class into a serialized dictionary object (NSDictionary)
 *
 *  @param model model is a model object
 *  @param error error
 *
 *  @return dictionary object as NSDictionary or nil if error
 */
- (nullable NSDictionary *)dictionaryFromModel:(nonnull id)model error:(NSError *__nullable *__nullable)error;

@end

