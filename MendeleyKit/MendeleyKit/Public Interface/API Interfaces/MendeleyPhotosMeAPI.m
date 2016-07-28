//
//  MendeleyPhotosMeAPI.m
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS) on 28/07/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyPhotosMeAPI.h"
#import "NSError+Exceptions.h"

@implementation MendeleyPhotosMeAPI

- (NSDictionary *)photoServiceHeadersWithContentType:(NSString *)contentType length:(NSInteger)length
{
    return @{ kMendeleyRESTRequestContentType: contentType,
              kMendeleyRESTRequestContentLength : @(length) };
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
