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

- (NSDictionary *)followRequestUploadHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFollowType,
              kMendeleyRESTRequestContentType : kMendeleyRESTRequestJSONFollowRequestType };
}

- (NSDictionary *)followAcceptanceUploadHeaders
{
    return @{ kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONFollowType,
             kMendeleyRESTRequestContentType : kMendeleyRESTRequestJSONFollowAcceptancesRequestType };
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
    queryParameters.followed = profileID;

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
    queryParameters.follower = profileID;

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

- (void)followUserWithID:(NSString *)followedID
                    task:(MendeleyTask *)task
         completionBlock:(MendeleyObjectCompletionBlock)completionBlock
{
    MendeleyFollowRequest *followRequest = [MendeleyFollowRequest new];
    followRequest.followed = followedID;
    [self.helper createMendeleyObject:followRequest
                                  api:kMendeleyRESTAPIFollowers
                    additionalHeaders:[self followRequestUploadHeaders]
                         expectedType:kMendeleyModelFollow
                                 task:task
                      completionBlock:completionBlock];
}

- (void)acceptFollowRequestWithID:(NSString *)requestID
                             task:(MendeleyTask *)task
                  completionBlock:(MendeleyCompletionBlock)completionBlock
{
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIFollowersWithID, requestID];
    MendeletyFollowAcceptance *followAcceptance = [MendeletyFollowAcceptance new];
    followAcceptance.status = kMendeleyRESTAPIQueryFollowersTypeFollowing;
    [self.helper updateMendeleyObject:followAcceptance
                                  api:apiEndpoint
                    additionalHeaders:[self followAcceptanceUploadHeaders]
                                 task:task
                      completionBlock:completionBlock];
}

- (void)stopOrDenyRelationshipWithID:(NSString *)relationshipID
                          task:(MendeleyTask *)task
               completionBlock:(MendeleyCompletionBlock)completionBlock
{
    NSString *apiEndpoint = [NSString stringWithFormat:kMendeleyRESTAPIFollowersWithID, relationshipID];
    [self.helper deleteMendeleyObjectWithAPI:apiEndpoint
                                        task:task
                             completionBlock:completionBlock];
}

@end
