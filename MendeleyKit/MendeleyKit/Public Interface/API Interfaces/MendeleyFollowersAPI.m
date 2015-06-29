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

#import "MendeleyFollowersAPI.h"
#import "NSError+Exceptions.h"

@implementation MendeleyFollowersAPI

- (NSDictionary *)defaultQueryParameters
{
    return [[MendeleyFollowersParameters new] valueStringDictionary];
}

- (NSDictionary *)defaultServiceRequestHeaders
{
    return @{ kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONFollowType };
}

- (void)followersForUserWithID:(NSString *)profileID
                    parameters:(MendeleyFollowersParameters *)queryParameters
                          task:(MendeleyTask *)task
               completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertStringArgumentNotNilOrEmpty:profileID argumentName:@"profileID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    if (!queryParameters) {
        queryParameters = [MendeleyFollowersParameters new];
    }
    queryParameters.status = kMendeleyRESTAPIQueryFollowersTypeFollowing;
    queryParameters.follower = profileID;

    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelFollow
                                      api:kMendeleyRESTAPIFollowers
                               parameters:query
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)followedByUserWithID:(NSString *)profileID
                  parameters:(MendeleyFollowersParameters *)queryParameters
                        task:(MendeleyTask *)task
             completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertStringArgumentNotNilOrEmpty:profileID argumentName:@"profileID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    if (!queryParameters) {
        queryParameters = [MendeleyFollowersParameters new];
    }
    queryParameters.status = kMendeleyRESTAPIQueryFollowersTypeFollowing;
    queryParameters.followed = profileID;

    NSDictionary *query = [queryParameters valueStringDictionary];


    [self.helper mendeleyObjectListOfType:kMendeleyModelFollow
                                      api:kMendeleyRESTAPIFollowers
                               parameters:query
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)pendingFollowersForUserWithID:(NSString *)profileID
                           parameters:(MendeleyFollowersParameters *)queryParameters
                                 task:(MendeleyTask *)task
                      completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertStringArgumentNotNilOrEmpty:profileID argumentName:@"profileID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    if (!queryParameters) {
        queryParameters = [MendeleyFollowersParameters new];
    }
    queryParameters.status = kMendeleyRESTAPIQueryFollowersTypePending;
    queryParameters.follower = profileID;

    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelFollow
                                      api:kMendeleyRESTAPIFollowers
                               parameters:query
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

- (void)pendingFollowedByUserWithID:(NSString *)profileID
                         parameters:(MendeleyFollowersParameters *)queryParameters
                               task:(MendeleyTask *)task
                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock
{
    [NSError assertStringArgumentNotNilOrEmpty:profileID argumentName:@"profileID"];
    [NSError assertArgumentNotNil:completionBlock argumentName:@"completionBlock"];

    if (!queryParameters) {
        queryParameters = [MendeleyFollowersParameters new];
    }
    queryParameters.status = kMendeleyRESTAPIQueryFollowersTypePending;
    queryParameters.followed = profileID;

    NSDictionary *query = [queryParameters valueStringDictionary];

    [self.helper mendeleyObjectListOfType:kMendeleyModelFollow
                                      api:kMendeleyRESTAPIFollowers
                               parameters:query
                        additionalHeaders:[self defaultServiceRequestHeaders]
                                     task:task
                          completionBlock:completionBlock];
}

@end
