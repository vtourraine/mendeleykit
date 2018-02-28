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

/**
 Strictly speaking there should be a class called 'MendeleyUserRoles' to replace
 'MendeleyAcademicStatuses' to reflect the a change in the API.
 Don't confuse UserRoles with UserRole, though!! The latter describes access rights for users (e.g. admin).
 Whereas userRoles describes academic roles such
 However, the return values are exactly as before. Therefore the model class remains
 MendeleyAcademicStatus
 */

open class MendeleyAcademicStatus : MendeleySecureObject, Codable {
    public var objectDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case objectDescription
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        objectDescription = try container.decodeIfPresent(String.self, forKey: .objectDescription)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(objectDescription, forKey: .objectDescription)
    }
}
