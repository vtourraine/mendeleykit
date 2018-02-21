//
//  MendeleyRecommendationsAPI.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 20/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

@objc public class MendeleyRecommendationsAPI: MendeleyObjectAPI {
    @objc public func recommendationsBasedOnLibraryArticles(withParameters parameters: MendeleyRecommendationsParameters?, task: MendeleyTask?, completionBlock:  MendeleyArrayCompletionBlock?) {
      
        provider.invokeGET(baseURL,
                           api: kMendeleyRESTAPIRecommendationsBasedOnLibrary,
                           additionalHeaders: defaultServiceRequestHeaders,
                           queryParameters: parameters?.valueStringDictionary(),
                           authenticationRequired: true,
                           task: task) { (response, error) in
                            let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                            
                            if (try? self.helper.isSuccess(for: response)) == nil {
                                blockExec?.execute(with: nil, syncInfo: nil, error: error)
                            } else {
                                if let responseBody = response?.responseBody as? [String: Any] {
                                    if let json = responseBody[kMendeleyJSONData] {
                                        do {
                                            let data = try JSONSerialization.data(withJSONObject: json, options: [])
                                            let decoder = JSONDecoder()
                                            let recommendedArticles = try decoder.decode([MendeleyRecommendedArticle].self, from: data)
                                            blockExec?.execute(with: recommendedArticles, syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            print(error)
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
                                }
                            }
        }
    }
    
    @objc public func feedbackOnRecommendation(_ trace: String, position: Int, userAction: String, carousel: Int, task: MendeleyTask?, completionBlock: MendeleyCompletionBlock?) {
        
        let bodyParameters = feedbackBodyParamaters(withTrace: trace, position: position, userAction: userAction, carousel: carousel)
        
        provider.invokePOST( baseURL,
                            api: kMendeleyRESTAPIRecommendationFeedback,
                            additionalHeaders: feedbackServiceRequestHeaders,
                            bodyParameters: bodyParameters,
                            isJSON: true,
                            authenticationRequired: true,
                            task: task) { (response, error) in
                                let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)

                                if (try? self.helper.isSuccess(for: response)) == nil {
                                    blockExec?.execute(with: false, error: error)
                                } else {
                                    blockExec?.execute(with: true, error: nil)
                                }
        }
    }
    
    // Mark: Headers and Query Parameters
    
    private let defaultServiceRequestHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONRecommendationsType]
    private let feedbackServiceRequestHeaders = [kMendeleyRESTRequestContentType: kMendeleyRESTRequestJSONRecommendationFeedbackType]
    
    func feedbackBodyParamaters(withTrace trace: String, position: Int, userAction: String, carousel: Int) -> [String: Any] {
        return [kMendeleyJSONTrace: trace,
                kMendeleyJSONPosition: position,
                kMendeleyJSONUserAction: userAction,
                kMendeleyJSONCarousel: carousel]
    }
}
