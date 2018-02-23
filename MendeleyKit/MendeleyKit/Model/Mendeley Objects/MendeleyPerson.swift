//
//  MendeleyPerson.swift
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 23/02/2018.
//  Copyright © 2018 Mendeley. All rights reserved.
//

import UIKit

open class MendeleyPerson: MendeleySwiftObject {
    public var first_name: String?
    public var last_name: String?
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
           last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
    }
}
