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

// MARK: - Mendeley File

@objc open class MendeleyFile: MendeleyObject {
    @objc public var file_name: String?
    @objc public var mime_type: String?
    @objc public var document_id: String?
    @objc public var filehash: String?
    @objc public var catalog_id: String?
    @objc public var size: NSNumber?
    
    private enum CodingKeys: String, CodingKey {
        case file_name
        case mime_type
        case document_id
        case filehash
        case catalog_id
        case size
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
           file_name = try container.decodeIfPresent(String.self, forKey: .file_name)
           mime_type = try container.decodeIfPresent(String.self, forKey: .mime_type)
           document_id = try container.decodeIfPresent(String.self, forKey: .document_id)
           filehash = try container.decodeIfPresent(String.self, forKey: .filehash)
           catalog_id = try container.decodeIfPresent(String.self, forKey: .catalog_id)
        if let sizeInt = try container.decodeIfPresent(Int.self, forKey: .size) {
            size = NSNumber(value: sizeInt)
        }
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(file_name, forKey: .file_name)
        try container.encodeIfPresent(mime_type, forKey: .mime_type)
        try container.encodeIfPresent(document_id, forKey: .document_id)
        try container.encodeIfPresent(filehash, forKey: .filehash)
        try container.encodeIfPresent(catalog_id, forKey: .catalog_id)
        try container.encodeIfPresent(size?.intValue, forKey: .size)
    }
}

// MARK: - Mendeley Recently Read

@objc open class MendeleyRecentlyRead: MendeleyObject {
    @objc public var file_id: String?
    @objc public var page: NSNumber?
    @objc public var vertical_position: NSNumber?
    @objc public var date: Data?
    
    private enum CodingKeys: String, CodingKey {
        case file_id
        case page
        case vertical_position
        case date
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file_id = try container.decodeIfPresent(String.self, forKey: .file_id)
        if let pageInt = try container.decodeIfPresent(Int.self, forKey: .page) {
            page = NSNumber(value: pageInt)
        }
        if let vertical_positionDouble = try container.decodeIfPresent(Double.self, forKey: .vertical_position) {
            vertical_position = NSNumber(value: vertical_positionDouble)
        }
        date = try container.decodeIfPresent(Data.self, forKey: .date)
        try super.init(from: decoder)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(file_id, forKey: .file_id)
        try container.encodeIfPresent(page?.intValue, forKey: .page)
        try container.encodeIfPresent(vertical_position?.doubleValue, forKey: .vertical_position)
        try container.encodeIfPresent(date, forKey: .date)
    }
}
