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

@objc open class MendeleyPhotosMeAPI: MendeleyObjectAPI {
    
    @objc public func uploadPhoto(withFile fileURL: URL,
                                  contentType: String,
                                  contentLength: Int,
                                  task: MendeleyTask?,
                                  progressBlock: MendeleyResponseProgressBlock?,
                                  completionBlock: @escaping MendeleyCompletionBlock) {
        
        networkProvider.invokeUpload(forFileURL: fileURL,
                                     baseURL: baseAPIURL,
                                     api: kMendeleyRESTAPIPhotosMe,
                                     additionalHeaders: photoServiceHeaders(withContentType: contentType, length: contentLength),
                                     authenticationRequired: true,
                                     task: task,
                                     progressBlock: progressBlock) { (response, error) in
                                        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
                                        var error = error
                                        let success = self.helper.isSuccess(forResponse: response, error: &error)
                                        
                                        blockExec?.execute(with: success, error: error)
        }
    }
    
    private func photoServiceHeaders(withContentType contentType: String, length: Int) -> [String: String] {
        return [kMendeleyRESTRequestContentType: contentType,
                kMendeleyRESTRequestContentLength: String(length)]
    }
}
