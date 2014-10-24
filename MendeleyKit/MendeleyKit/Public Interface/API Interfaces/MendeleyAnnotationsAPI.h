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

#import "MendeleyObjectAPI.h"

@class MendeleyAnnotation;
@class MendeleyAnnotationParameters;

@interface MendeleyAnnotationsAPI : MendeleyObjectAPI
/**
   @name MendeleyAnnotationsAPI
   This class provides access methods to the REST annotations API
   All of the methods are accessed via MendeleyKit.
   Developers should use the methods provided in MendeleyKit rather
   than the methods listed here.
 */
/**
   @param annotationID
   @param completionBlock
 */
- (void)annotationWithAnnotationID:(NSString *)annotationID
                   completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   @param annotationID
   @param completionBlock
 */
- (void)deleteAnnotationWithID:(NSString *)annotationID
               completionBlock:(MendeleyCompletionBlock)completionBlock;

/**
   @param updatedMendeleyAnnotation
   @param completionBlock
 */
- (void)updateAnnotation:(MendeleyAnnotation *)updatedMendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
/**
   @param mendeleyAnnotation
   @param completionBlock
 */
- (void)createAnnotation:(MendeleyAnnotation *)mendeleyAnnotation
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock;

/**
   @param linkURL
   @param completionBlock
 */
- (void)annotationListWithLinkedURL:(NSURL *)linkURL
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   @param queryParameters
   @param completionBlock
 */
- (void)annotationListWithQueryParameters:(MendeleyAnnotationParameters *)queryParameters
                          completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

/**
   This method returns a list of annotations IDs that were permanently deleted. The list of deleted IDs will be kept on
   the server for a limited period of time.
   @param deletedSince the parameter set to be used in the request
   @param completionBlock
 */
- (void)deletedAnnotationsSince:(NSDate *)deletedSince
                completionBlock:(MendeleyArrayCompletionBlock)completionBlock;

@end
