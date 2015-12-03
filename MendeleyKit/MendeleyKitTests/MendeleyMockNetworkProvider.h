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

@import Foundation;
#import "MendeleyKitTestsBaseInclude.h"


#ifndef MendeleyKitiOSFramework
#import "MendeleyNetworkProvider.h"
#import "MendeleyResponse.h"
#endif

@interface MendeleyMockNetworkProvider : NSObject <MendeleyNetworkProvider>
@property (nonatomic, assign) BOOL expectedSuccess;
@property (nonatomic, strong) NSError *expectedError;
@property (nonatomic, assign) NSInteger expectedStatusCode;
@property (nonatomic, strong) id expectedResponseBody;
@property (nonatomic, assign) BOOL checkAdditionalHeaders;
@property (nonatomic, assign) BOOL checkBodyParameters;
@property (nonatomic, assign) BOOL checkValidBaseURLAndAPI;
@property (nonatomic, assign) BOOL checkValidJSONInputData;
@end


