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

@objc open class MendeleyObjectAPI: NSObject, MendeleyKitHelperDelegate {
    
    public var networkProvider: MendeleyNetworkProvider!
    public var baseAPIURL: URL!
    public var helper: MendeleyKitHelper!
    
    /**
     A general creator of MendeleyObjectAPI
     @param provider the network provider. By default the MendeleyDefaultNetworkProvider is taken. This is based on NSURLSession
     @param baseURL
     */
    @objc public required init(withNetworkProvider provider: MendeleyNetworkProvider, baseURL: URL) {
        super.init()
        self.networkProvider = provider
        self.baseAPIURL = baseURL
        self.helper = MendeleyKitHelper(withDelegate: self)
        }
    
    /**
     A convenience method that returns the link for the image of the choosen type passing a MendeleyPhoto Object
     @param the photo object
     @param iconType
     @param task
     @param error
     */
    func link(fromPhoto photo: MendeleyPhoto?, iconType: MendeleyIconType, task: MendeleyTask?) throws -> String {
        guard let photo = photo
            else {
                throw  MendeleyErrorManager.sharedInstance().error(withDomain:kMendeleyErrorDomain, code: MendeleyErrorCode.missingDataProvidedErrorCode.rawValue)!
        }
        
        var link: String? = nil
        
        switch iconType {
        case .OriginalIcon:
            link = photo.original
        case .SquareIcon:
            link = photo.square
        case .StandardIcon:
            link = photo.standard
        }
        
        guard let returnedLink = link
            else {
                throw  MendeleyErrorManager.sharedInstance().error(withDomain:kMendeleyErrorDomain, code: MendeleyErrorCode.missingDataProvidedErrorCode.rawValue)!
                
        }
        
        return returnedLink
    }
    
    /**
     A convenience method that returns the request header for a image download link
     */
    func requestHeader(forImageLink link: String) -> [String: String] {
        if link.hasSuffix(".jpg") {
            return [kMendeleyRESTRequestAccept: kMendeleyRESTRequestJPEGType]
        }
        
        if link.hasSuffix(".png") {
            return [kMendeleyRESTRequestAccept: kMendeleyRESTRequestPNGType]
        }
        
        return [kMendeleyRESTRequestAccept: kMendeleyRESTRequestBinaryType]
    }
}
