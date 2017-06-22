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

#import "MendeleyLoginAPI.h"
#import "NSError+Exceptions.h"

@implementation MendeleyLoginAPI

- (NSDictionary *)checkIDPlusProfileRequestHeader
{
    return @{kMendeleyRESTRequestContentType:kMendeleyRESTRequestJSONIDPlusProfileType,
             kMendeleyRESTRequestAccept:kMendeleyRESTRequestJSONIDPlusProfileAcceptType};
}

- (void)checkIDPlusProfileWithIdPlusToken:(NSString *)idToken
                                     task:(MendeleyTask *)task
                          completionBlock:(MendeleyObjectAndStateCompletionBlock)completionBlock
{
    [NSError assertStringArgumentNotNilOrEmpty:idToken argumentName:@"idToken"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    
    NSDictionary *requestHeader = [self checkIDPlusProfileRequestHeader];
    
    MendeleyBlockExecutor *blockExec = [[MendeleyBlockExecutor alloc] initWithObjectAndStateCompletionBlock:completionBlock];
    MendeleyModeller *modeller = [MendeleyModeller sharedInstance];
    
    NSError *serialiseError = nil;
    NSData *data = [idToken dataUsingEncoding:NSUTF8StringEncoding];
    if (nil == data)
    {
        [blockExec executeWithMendeleyObject:nil
                                       state:0
                                       error:serialiseError];
        return;
    }
    id <MendeleyNetworkProvider> networkProvider = [self provider];
    [networkProvider invokePOST:self.baseURL
                            api:kMendeleyRESTAPICheckProfiles
              additionalHeaders:requestHeader
                       jsonData:data
         authenticationRequired:YES
                           task:task
                completionBlock: ^(MendeleyResponse *response, NSError *error) {
                    if (![self.helper isSuccessForResponse:response error:&error])
                    {
                        [blockExec executeWithMendeleyObject:nil
                                                       state:response.statusCode
                                                       error:error];
                    }
                    else
                    {
                        [modeller parseJSONData:response.responseBody expectedType:kMendeleyModelProfileVerificationStatus completionBlock: ^(MendeleyObject *object, NSError *parseError) {
                            [blockExec executeWithMendeleyObject:object
                                                           state:response.statusCode
                                                           error:parseError];
                        }];
                    }
                }];
}

@end
