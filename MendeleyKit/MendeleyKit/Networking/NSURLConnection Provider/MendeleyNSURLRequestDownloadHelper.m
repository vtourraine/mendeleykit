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

#import "MendeleyNSURLRequestDownloadHelper.h"

#define NSURLResponseUnknownLength ((long long)-1)


@interface MendeleyNSURLRequestDownloadHelper ()
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy) MendeleyResponseProgressBlock progressBlock;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) unsigned long long bytesExpected;
@property (nonatomic, assign) unsigned long long bytesDownloaded;
@end


@implementation MendeleyNSURLRequestDownloadHelper
- (id)initWithMendeleyRequest:(MendeleyRequest *)mendeleyRequest
                    toFileURL:(NSURL *)toFileURL
                progressBlock:(MendeleyResponseProgressBlock)progressBlock
              completionBlock:(MendeleyResponseCompletionBlock)completionBlock
{
    self = [super initWithMendeleyRequest:mendeleyRequest completionBlock:completionBlock];
    if (nil != self)
    {
        _progressBlock = progressBlock;
        _fileURL = toFileURL;
        _bytesDownloaded = 0;
        _bytesExpected = 0;
    }
    return self;
}

- (BOOL)startRequest
{
    if (nil == self.fileURL)
    {
        return NO;
    }
    NSString *filePath = [self.fileURL path];
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    return [super startRequest];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response
{
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        statusCode = httpResponse.statusCode;
    }

    NSURLRequest *updatedRequest = [request copy];
    
    if (303 == statusCode)
    {
        updatedRequest = [NSURLRequest requestWithURL:request.URL];
    }
    
    return updatedRequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [super connection:connection didReceiveResponse:response];
    if (self.bytesExpected == 0 && response.expectedContentLength != NSURLResponseUnknownLength)
    {
        self.bytesExpected = response.expectedContentLength;
    }
    self.bytesDownloaded = 0;
    if (nil != self.outputStream)
    {
        BOOL isStreamReady = self.outputStream.streamStatus == NSStreamStatusOpen;
        if (!isStreamReady)
        {
            [self.outputStream open];
            isStreamReady = self.outputStream.streamStatus == NSStreamStatusOpen;
        }
        
        if (!isStreamReady)
        {
                //            [connection cancel];
            
            if (self.completionBlock)
            {
            }
        }
    }
}

@end
