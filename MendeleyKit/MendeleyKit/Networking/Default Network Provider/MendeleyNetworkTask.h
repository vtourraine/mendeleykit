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

@interface MendeleyNetworkTask : NSObject  <NSURLSessionTaskDelegate>

- (instancetype)initTaskWithRequest:(NSURLRequest *)request
                            session:(NSURLSession *)session
                    completionBlock:(MendeleyResponseCompletionBlock)completionBlock;
- (void)executeTask;
- (void)cancelTaskWithCompletionBlock:(MendeleyCompletionBlock)completionBlock;

@property (strong, nonatomic) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSNumber *taskID;
@property (copy, nonatomic, readonly) MendeleyResponseCompletionBlock completionBlock;

@end

@interface MendeleyNetworkUploadTask : MendeleyNetworkTask

- (instancetype)initUploadTaskWithRequest:(NSURLRequest *)request
                                  session:(NSURLSession *)session
                                  fileURL:(NSURL *)fileURL
                            progressBlock:(MendeleyResponseProgressBlock)progressBlock
                          completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

@property (copy, nonatomic, readonly) MendeleyResponseProgressBlock progressBlock;

@end

@interface MendeleyNetworkDownloadTask : MendeleyNetworkTask

- (instancetype)initDownloadTaskWithRequest:(NSURLRequest *)request
                                    session:(NSURLSession *)session
                                    fileURL:(NSURL *)fileURL
                              progressBlock:(MendeleyResponseProgressBlock)progressBlock
                            completionBlock:(MendeleyResponseCompletionBlock)completionBlock;

- (void)addRealDownloadTask:(NSURLSessionDownloadTask *)downloadTask;

@property (copy, nonatomic, readonly) NSURL *fileURL;
@property (copy, nonatomic, readonly) MendeleyResponseProgressBlock progressBlock;

@end

