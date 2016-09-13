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

#import "MendeleyPhotosMeAPI.h"
#import "NSError+Exceptions.h"

@implementation MendeleyPhotosMeAPI

- (NSDictionary *)photoServiceHeadersWithContentType:(NSString *)contentType length:(NSInteger)length
{
    return @{ kMendeleyRESTRequestContentType: contentType,
              kMendeleyRESTRequestContentLength : @(length).stringValue };
}

- (void)uploadPhotoWithFile:(NSURL *)fileURL
                contentType:(NSString *)contentType
              contentLength:(NSInteger)contentLength
                       task:(MendeleyTask *)task
              progressBlock:(MendeleyResponseProgressBlock)progressBlock
            completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [NSError assertURLArgumentNotNilOrMissing:fileURL argumentName:@"fileURL"];
    [NSError assertStringArgumentNotNilOrEmpty:contentType argumentName:@"contentType"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    NSDictionary *uploadHeader = [self photoServiceHeadersWithContentType:contentType length:contentLength];
    
    [self.provider invokeUploadForFileURL:fileURL
                                  baseURL:self.baseURL
                                      api:kMendeleyRESTAPIPhotosMe
                        additionalHeaders:uploadHeader
                   authenticationRequired:YES
                                     task:task
                            progressBlock:progressBlock
                          completionBlock: ^(MendeleyResponse *response, NSError *error) {
                              MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
                              BOOL success = [self.helper isSuccessForResponse:response error:&error];
                              [blockExec executeWithBool:success error:error];
                          }];
}


@end
