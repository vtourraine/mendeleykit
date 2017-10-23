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

#ifndef MendeleyAnalyticsRegistry_h
#define MendeleyAnalyticsRegistry_h

#define kMendeleyAnalyticsEventCacheKey         @"MendeleyAnalyticsEventsCache"

/***********************************************
 @name Mendeley Server Events URL endpoints as strings
 ***********************************************/
#define kMendeleyAnalyticsJSONOrigin            @"origin"
#define kMendeleyAnalyticsJSONOriginType        @"type"
#define kMendeleyAnalyticsJSONOriginOS          @"os"
#define kMendeleyAnalyticsJSONOriginVersion     @"version"
#define kMendeleyAnalyticsJSONOriginIdentity    @"identity"

#define kMendeleyAnalyticsAPIEvents             @"events"
#define kMendeleyAnalyticsAPIEventsBatch        @"events/_batch"

/***********************************************
 @name predefined strings for JSON event
 ***********************************************/

#define kOriginType                             @"IOS"
#define kOriginOS                               @"iOS"
#define kMendeleyAnalyticsJSONDuration          @"duration_milliseconds"
#define kMendeleyAnalyticsJSONConnectionType    @"connection_type"
#define kMendeleyAnalyticsJSONFinishCondition   @"finish_condition"

/***********************************************
 @name registered events
 ***********************************************/
#define kClosePDFInternalViewer              @"ClosePdfInternalViewer"
#define kOpenPDFInInternalViewer             @"OpenPdfInInternalViewer"

#endif /* MendeleyAnalyticsRegistry_h */
