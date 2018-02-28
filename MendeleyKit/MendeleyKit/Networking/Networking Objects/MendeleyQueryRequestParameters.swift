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

// MARK: - Base class

@objc open class MendeleySwiftQueryRequestParameters: NSObject {
    @objc public var limit: Int = Int(kMendeleyRESTAPIDefaultPageSize) {
        didSet {
            if limit <= 0 {
                limit = Int(kMendeleyRESTAPIDefaultPageSize)
            } else if limit > kMendeleyRESTAPIMaxPageSize {
                limit = Int(kMendeleyRESTAPIMaxPageSize)
            }
        }
    }
    @objc public var deleted_since: Date?
    @objc public var include_trashed: Bool = false
    @objc public var group_id: String?
    
    /**
     This method convers parameters defined in the request parameter objects into a
     string-key/value based map - for use as query parameters in API calls.
     
     NOTE: this method will return limit as a parameter.
     */
    @objc public func valueStringDictionary() -> [String: String] {
        var values = [String: String]()
        
        guard let dictionary = MendeleyObjectHelper.propertiesAndAttributes(forModel: self) as? [String: Any]
            else { return values }
        
        dictionary.forEach { (propertyName, attribute) in
            let newValue = value(forKey: propertyName)
            if let valueString = valueString(forProperty: propertyName, value: newValue) {
                values[propertyName] = valueString
            }
        }
        
        return values
    }
    
    /**
     checks if a property with the provided name exists in the MendeleyQueryRequestParameters object
     and the subclass calling it
     @param propertyName
     */
    @objc public func valueStringDictionaryWithNoLimit() -> [String: String] {
        var values = [String: String]()
        
        guard let dictionary = MendeleyObjectHelper.propertiesAndAttributes(forModel: self) as? [String: Any]
            else { return values }
        
        dictionary.forEach { (propertyName, attribute) in
            if propertyName == kMendeleyRESTAPIQueryLimit {
                return
            }
            
            let newValue = value(forKey: propertyName)
            if let valueString = valueString(forProperty: propertyName, value: newValue) {
                values[propertyName] = valueString
            }
        }
        
        return values
    }
    
    @objc public func hasQueryParameter(withName queryParameterName: String) -> Bool {
        guard let propertyNames = MendeleyObjectHelper.propertyNames(forModel: self) as? [String]
            else { return false }
        
        if propertyNames.count == 0 {
            return false
        }
  
        return propertyNames.contains { $0 == queryParameterName }
    }
    
    private func valueString(forProperty property: String?, value: Any?) -> String? {
        guard let property = property, let value = value
            else { return nil }
        
        var valueString: String? = nil
        
        if let dateValue = value as? Date {
            valueString = dateValueString(forPropertyWithName: property, date: dateValue)
        } else if let intValue = value as? Int {
            valueString = String(intValue)
        } else if let boolValue = value as? Bool {
            valueString = boolValue ? "true" : "false"
        } else if let stringValue = value as? String {
            valueString = stringValue
        }
        
        if valueString != nil && valueString?.count == 0 {
            valueString = nil
        }
        
        return valueString
    }
    
    private func add(value: String?, forKey key: String?, toDictionary dictionary: inout [String: Any]) {
        guard let value = value, let key = key
            else { return }
        
        dictionary[key] = value
    }
    
    private func dateValueString(forPropertyWithName propertyName: String?, date: Date?) -> String? {
        guard let _ = propertyName, let date = date, let isoFormatter = MendeleyObjectHelper.jsonDateFormatter()
            else { return nil }
        
        return isoFormatter.string(from: date)
    }
}

// MARK: - Shares

@objc open class MendeleySharesParameters: MendeleySwiftQueryRequestParameters {
    @objc public var news_id: String?
}

// MARK: - Metadata

@objc open class MendeleyMetadataParameters: MendeleySwiftQueryRequestParameters {
    @objc public var arxiv: String?
    @objc public var doi: String?
    @objc public var pmid: String?
    @objc public var title: String?
    @objc public var filehash: String?
    @objc public var authors: String?
    @objc public var year: String?
    @objc public var source: String?
}

// MARK: - Groups

@objc open class MendeleyGroupParameters: MendeleySwiftQueryRequestParameters {
}

// MARK - Followers

@objc open class MendeleyFollowersParameters: MendeleySwiftQueryRequestParameters {
    @objc public var status: String?
    @objc public var follower: String?
    @objc public var pmfollowedid: String?
}

// MARK: - Recommendations

@objc open class MendeleyRecommendationsParameters: MendeleySwiftQueryRequestParameters {
    @objc public var page_load_id: String?
    @objc public var ref: String?
}

// MARK: - Feed

@objc open class MendeleyFeedsParameters: MendeleySwiftQueryRequestParameters {
    @objc public var profile_id: String?
    @objc public var cut_off: String?
}

// MARK: - Comments

@objc open class MendeleyExpandedCommentsParameters: MendeleySwiftQueryRequestParameters {
    @objc public var news_item_id: String?
    @objc public var skip_news_item_check: Bool = false
    @objc public var start_from: String?
}
