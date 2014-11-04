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

#import "MendeleyProfilesAPI.h"

@implementation MendeleyProfilesAPI

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONProfilesType };
}

- (void)pullMyProfileWithTask:(MendeleyTask *)task completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    [self.helper mendeleyObjectOfType:kMendeleyModelUserProfile
                           parameters:nil
                                  api:kMendeleyRESTAPIProfilesMe
                    additionalHeaders:[self defaultServiceRequestHeaders]
                      completionBlock:completionBlock];
}

- (void)pullProfile:(NSString *)profileID
               task:(MendeleyTask *)task
    completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    [NSError assertArgumentNotNil:profileID argumentName:@"profileID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIProfilesWithID, profileID];
    [self.helper mendeleyObjectOfType:kMendeleyModelProfile
                           parameters:nil
                                  api:apiEndpoint
                    additionalHeaders:[self defaultServiceRequestHeaders]
                      completionBlock:completionBlock];


}

@end
