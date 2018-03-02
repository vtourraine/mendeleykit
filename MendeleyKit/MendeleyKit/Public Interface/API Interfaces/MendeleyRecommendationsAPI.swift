//
//  MendeleyRecommendationsAPI.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 20/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

@objc open class MendeleyRecommendationsAPI: MendeleySwiftObjectAPI {
    @objc public func recommendationsBasedOnLibraryArticles(withParameters parameters: MendeleyRecommendationsParameters?, task: MendeleyTask?, completionBlock:  MendeleyArrayCompletionBlock?) {
        
        networkProvider.invokeGET(baseAPIURL,
                                  api: kMendeleyRESTAPIRecommendationsBasedOnLibrary,
                                  additionalHeaders: defaultServiceRequestHeaders,
                                  queryParameters: parameters?.valueStringDictionary(),
                                  authenticationRequired: true,
                                  task: task) { (response, error) in
                                    let blockExec = MendeleyBlockExecutor(arrayCompletionBlock: completionBlock)
                                    
                                    var error = error
                                    if self.helper.isSuccess(forResponse: response, error: &error) == false || response?.rawResponseBody == nil {
                                        blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                    } else {
                                        let decoder = JSONDecoder()
                                        do {
                                            let recommendedArticlesDict = try decoder.decode([String: [MendeleyRecommendedArticle]].self, from: response!.rawResponseBody)
                                            blockExec?.execute(with: recommendedArticlesDict[kMendeleyJSONData], syncInfo: response?.syncHeader, error: nil)
                                        } catch {
                                            blockExec?.execute(with: nil, syncInfo: nil, error: error)
                                        }
                                    }
        }
    }
    
    @objc public func feedbackOnRecommendation(_ trace: String, position: Int, userAction: String, carousel: Int, task: MendeleyTask?, completionBlock: MendeleyCompletionBlock?) {
        
        let bodyParameters = feedbackBodyParamaters(withTrace: trace, position: position, userAction: userAction, carousel: carousel)
        
        networkProvider.invokePOST( baseAPIURL,
                                    api: kMendeleyRESTAPIRecommendationFeedback,
                                    additionalHeaders: feedbackServiceRequestHeaders,
                                    bodyParameters: bodyParameters,
                                    isJSON: true,
                                    authenticationRequired: true,
                                    task: task) { (response, error) in
                                        let blockExec = MendeleyBlockExecutor(completionBlock: completionBlock)
                                        var error = error
                                        if self.helper.isSuccess(forResponse: response, error: &error) == false {
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
