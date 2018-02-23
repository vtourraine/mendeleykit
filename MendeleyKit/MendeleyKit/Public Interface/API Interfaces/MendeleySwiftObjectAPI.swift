//
//  MendeleySwiftObjectAPI.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 22/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

@objc public class MendeleySwiftObjectAPI: NSObject, MendeleyKitSwiftHelperDelegate {
    
    public var networkProvider: MendeleyNetworkProvider!
    public var baseAPIURL: URL!
    public var helper: MendeleyKitSwiftHelper!
    
    /**
     A general creator of MendeleyObjectAPI
     @param provider the network provider. By default the MendeleyDefaultNetworkProvider is taken. This is based on NSURLSession
     @param baseURL
     */
    @objc public required init(withNetworkProvider provider: MendeleyNetworkProvider, baseURL: URL) {
        super.init()
        self.networkProvider = provider
        self.baseAPIURL = baseURL
        self.helper = MendeleyKitSwiftHelper(withDelegate: self)
        }
    
    /**
     A convenience method that returns the link for the image of the choosen type passing a MendeleyPhoto Object
     @param the photo object
     @param iconType
     @param task
     @param error
     */
    func link(fromPhoto photo: MendeleyPhoto?, iconType: MendeleyIconType, task: MendeleyTask) throws -> String {
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
