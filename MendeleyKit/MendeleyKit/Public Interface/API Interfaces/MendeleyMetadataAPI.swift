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

@objc open class MendeleyMetadataAPI: MendeleySwiftObjectAPI {
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJSONMetadataLookupType]
    
    /**
     @name MendeleyMetadataAPI
     This class provides access methods to the REST metadata API
     All of the methods are accessed via MendeleyKit.
     Developers should use the methods provided in MendeleyKit rather
     than the methods listed here.
     */
    
    /**
     @param queryParameters
     @param task
     @param completionBlock
     */
    @objc public func metadataLookup(withQueryParameters: MendeleyMetadataParameters,
                                     task: MendeleyTask?,
                                     completionBlock: @escaping MendeleyObjectCompletionBlock) {
        let query = withQueryParameters.valueStringDictionaryWithNoLimit()
        
        helper.mendeleyObject(ofType: MendeleyMetadataLookup.self,
                              queryParameters: query,
                              api: kMendeleyRESTAPIMetadata,
                              additionalHeaders: defaultServiceRequestHeaders,
                              task: task,
                              completionBlock: completionBlock)
    }
}
