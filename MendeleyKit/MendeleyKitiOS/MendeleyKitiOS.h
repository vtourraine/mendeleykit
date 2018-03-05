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

#import <UIKit/UIKit.h>

//! Project version number for MendeleyKitiOS.
FOUNDATION_EXPORT double MendeleyKitiOSVersionNumber;

//! Project version string for MendeleyKitiOS.
FOUNDATION_EXPORT const unsigned char MendeleyKitiOSVersionString[];

#import <MendeleyKitiOS/MendeleyGlobals.h>
#import <MendeleyKitiOS/MendeleyOAuthCredentials.h>
#import <MendeleyKitiOS/MendeleyCancellableRequest.h>
#import <MendeleyKitiOS/MendeleySimpleNetworkTask.h>
#import <MendeleyKitiOS/MendeleyOAuthTokenHelper.h>
#import <MendeleyKitiOS/NSDictionary+Merge.h>
#import <MendeleyKitiOS/MendeleyQueryRequestParameters.h>
#import <MendeleyKitiOS/MendeleySimpleNetworkProvider.h>
#import <MendeleyKitiOS/MendeleyTimer.h>
#import <MendeleyKitiOS/MendeleyDataHelper.h>
#import <MendeleyKitiOS/MendeleyNetworkProvider.h>
#import <MendeleyKitiOS/MendeleyKit.h>
#import <MendeleyKitiOS/MendeleyLoginViewController.h>
#import <MendeleyKitiOS/MendeleyDownloadHelper.h>
#import <MendeleyKitiOS/MendeleyDefaultNetworkProvider.h>
#import <MendeleyKitiOS/MendeleyConnectionReachability.h>
#import <MendeleyKitiOS/MendeleyError.h>
#import <MendeleyKitiOS/MendeleyReachability.h>
#import <MendeleyKitiOS/MendeleyModeller.h>
#import <MendeleyKitiOS/MendeleyResponse.h>
#import <MendeleyKitiOS/MendeleyKitUserInfoManager.h>
#import <MendeleyKitiOS/MendeleyLog.h>
#import <MendeleyKitiOS/MendeleyPerformanceMeter.h>
#import <MendeleyKitiOS/MendeleySyncInfo.h>
#import <MendeleyKitiOS/MendeleyNetworkTask.h>
#import <MendeleyKitiOS/MendeleyTask.h>
#import <MendeleyKitiOS/MendeleyOAuthStore.h>
#import <MendeleyKitiOS/MendeleyURLBuilder.h>
#import <MendeleyKitiOS/NSMutableArray+MaximumSize.h>
#import <MendeleyKitiOS/MendeleyUploadHelper.h>
#import <MendeleyKitiOS/MendeleyKitConfiguration.h>
#import <MendeleyKitiOS/MendeleyBlockExecutor.h>
#import <MendeleyKitiOS/MendeleyRequest.h>
#import <MendeleyKitiOS/MendeleyErrorManager.h>
#import <MendeleyKitiOS/MendeleyPerformanceMeterSession.h>
#import <MendeleyKitiOS/NSError+MendeleyError.h>
#import <MendeleyKitiOS/NSError+Exceptions.h>
#import <MendeleyKitiOS/MendeleyTaskProvider.h>
#import <MendeleyKitiOS/MendeleyOAuthProvider.h>
#import <MendeleyKitiOS/MendeleyOAuthConstants.h>
#import <MendeleyKitiOS/MendeleyObjectHelper.h>
#import <MendeleyKitiOS/MendeleyDefaultOAuthProvider.h>
#import <MendeleyKitiOS/MendeleyNSURLRequestDownloadHelper.h>
#import <MendeleyKitiOS/MendeleyNSURLRequestHelper.h>
#import <MendeleyKitiOS/MendeleyNSURLRequestUploadHelper.h>
#import <MendeleyKitiOS/MendeleyNSURLConnectionProvider.h>
#import <MendeleyKitiOS/MendeleyAnalyticsRegistry.h>
#import <MendeleyKitiOS/MendeleyKit-Umbrella.h>
