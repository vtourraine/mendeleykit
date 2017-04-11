//
//  MendeleyUserPostsAPI.m
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 22/02/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

#import "MendeleyUserPostsAPI.h"

@implementation MendeleyUserPostsAPI

- (void)deleteUserPostWithPostID:(NSString *)postID
                            task:(MendeleyTask *)task
                 completionBlock:(MendeleyCompletionBlock)completionBlock
{
    [self.provider invokeDELETE:self.baseURL
                            api:[NSString stringWithFormat:kMendeleyRESTAPIDeleteUserPost, postID]
              additionalHeaders:nil
                 bodyParameters:nil
         authenticationRequired:YES
                           task:task
                completionBlock:^(MendeleyResponse * _Nullable response, NSError * _Nullable error) {
                    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithCompletionBlock:completionBlock];
                    BOOL success = [self.helper isSuccessForResponse:response error:&error];
                    [blockExec executeWithBool:success error:error];
                }];
}

@end
