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

import UIKit

open class MendeleySwiftSecureObject: NSObject {

    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init()
        self.decode(aDecoder)
    }
    
    private func decode(_ decoder: NSCoder) {
        guard let propertyNames = MendeleyObjectHelper.propertyNames(forModel: self) as? [String]
            else { return }
        
        propertyNames.forEach { (name) in
            if let value = decoder.decodeObject(of: [type(of: self)], forKey: name) {
                setValue(value, forKey: name)
            }
        }
    }
}

extension MendeleySwiftSecureObject: NSSecureCoding {
    public func encode(with aCoder: NSCoder) {
        guard let propertyNames = MendeleyObjectHelper.propertyNames(forModel: self) as? [String]
            else { return }
        
        propertyNames.forEach { (name) in
            if let value = value(forKey: name) {
                aCoder.encode(value, forKey: name)
            }
        }
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
}
