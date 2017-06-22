//
//  MendeleyLoginAPI.m
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS-LON) on 22/06/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

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
