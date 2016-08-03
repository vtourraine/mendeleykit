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

import Foundation

@objc
public protocol MendeleyAnalytics
{
    
    func configureMendeleyAnalytics(_ profileID: String, clientVersionString: String, clientIdentityString: String)

    func configureMendeleyAnalytics(_ profileID: String, clientVersionString: String, clientIdentityString: String, batchSize: Int)
    
    
    func logMendeleyAnalyticsEvent(_ name: String)

    
    func logMendeleyAnalyticsEvents(_ events:[MendeleyAnalyticsEvent])
    
    
    func dispatchMendeleyAnalyticsEvents(_ completionHandler: MendeleyCompletionBlock?)
    
}
