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

// MARK: - Mendeley Location

open class MendeleyLocation: MendeleySwiftSecureObject, Codable {
    public var name: String?
    public var latitude: Double?
    public var longitude: Double?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
    }
}

// MARK: - Mendeley Employment

open class MendeleyEmployment: MendeleySwiftSecureObject, Codable {
    public var classes: [String]?
    public var position: String?
    public var is_main_employment: Bool?
    public var institution: String?
    public var start_date: Date?
    public var end_date: Date?
    public var website: String?
    
    private enum CodingKeys: String, CodingKey {
        case classes
        case position
        case is_main_employment
        case institution
        case start_date
        case end_date
        case website
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        classes = try container.decodeIfPresent([String].self, forKey: .classes)
        position = try container.decodeIfPresent(String.self, forKey: .position)
        is_main_employment = try container.decodeIfPresent(Bool.self, forKey: .is_main_employment)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        start_date = try container.decodeIfPresent(Date.self, forKey: .start_date)
        end_date = try container.decodeIfPresent(Date.self, forKey: .end_date)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(classes, forKey: .classes)
        try container.encodeIfPresent(position, forKey: .position)
        try container.encodeIfPresent(is_main_employment, forKey: .is_main_employment)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(start_date, forKey: .start_date)
        try container.encodeIfPresent(end_date, forKey: .end_date)
        try container.encodeIfPresent(website, forKey: .website)
    }
}

// MARK: - Mendeley Education

open class MendeleyEducation: MendeleySwiftSecureObject, Codable {
    public var institution: String?
    public var start_date: Date?
    public var end_date: Date?
    public var website: String?
    public var degree: String?
    
    private enum CodingKeys: String, CodingKey {
        case institution
        case start_date
        case end_date
        case website
        case degree
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        start_date = try container.decodeIfPresent(Date.self, forKey: .start_date)
        end_date = try container.decodeIfPresent(Date.self, forKey: .end_date)
        website = try container.decodeIfPresent(String.self, forKey: .website)
        degree = try container.decodeIfPresent(String.self, forKey: .degree)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(start_date, forKey: .start_date)
        try container.encodeIfPresent(end_date, forKey: .end_date)
        try container.encodeIfPresent(website, forKey: .website)
        try container.encodeIfPresent(degree, forKey: .degree)
    }
}

// MARK: - Mendeley Discipline

/**
 Strictly speaking there should be a class called 'MendeleySubjectArea' to replace
 'MendeleyDiscipline' to reflect the a change in the API.
 However, the return values are exactly as before. Therefore the model class remains
 MendeleyMendeleyDiscipline
 */
open class MendeleyDiscipline: MendeleySwiftSecureObject, Codable {
    public var name: String?
    public var subdisciplines: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case subdisciplines
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        subdisciplines = try container.decodeIfPresent([String].self, forKey: .subdisciplines)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(subdisciplines, forKey: .subdisciplines)
    }
}

// MARK: - Mendeley Image

open class MendeleyImage: MendeleySwiftSecureObject, Codable {
    public var width: Double?
    public var height: Double?
    /**
     a boolean flag indicating whether this is the original image
     not to be confused with a property of the same name in
     MendeleyPhoto
     */
    public var original: Bool?
    public var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case original
        case url
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        width = try container.decodeIfPresent(Double.self, forKey: .width)
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        original = try container.decodeIfPresent(Bool.self, forKey: .original)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(original, forKey: .original)
        try container.encodeIfPresent(url, forKey: .url)
    }
}

// MARK: - Mendeley Profile

open class MendeleyProfile: MendeleySwiftObject {
    public var first_name: String?
    public var last_name: String?
    public var display_name: String?
    public var email: String?
    public var link: String?
    public var institution: String?
    public var research_interests: String?
    public var research_interests_list: [String]?
    public var academic_status: String?
    public var discipline: MendeleyDiscipline?
    public var disciplines: [MendeleyDiscipline]?
    public var photo: MendeleyPhoto?
    public var photos: [MendeleyImage]?
    public var verified: Bool?
    public var marketing: Bool?
    public var user_type: String?
    public var location: MendeleyLocation?
    public var created: Date?
    public var education: [MendeleyEducation]?
    public var employment: [MendeleyEmployment]?
    public var title: String?
    public var biography: String?
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case display_name
        case email
        case link
        case institution
        case research_interests
        case research_interests_list
        case academic_status
        case discipline
        case disciplines
        case photo
        case photos
        case verified
        case marketing
        case user_type
        case location
        case created
        case education
        case employment
        case title
        case biography
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        display_name = try container.decodeIfPresent(String.self, forKey: .display_name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        link = try container.decodeIfPresent(String.self, forKey: .link)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        research_interests = try container.decodeIfPresent(String.self, forKey: .research_interests)
        research_interests_list = try container.decodeIfPresent([String].self, forKey: .research_interests_list)
        academic_status = try container.decodeIfPresent(String.self, forKey: .academic_status)
        discipline = try container.decodeIfPresent(MendeleyDiscipline.self, forKey: .discipline)
        disciplines = try container.decodeIfPresent([MendeleyDiscipline].self, forKey: .disciplines)
        photo = try container.decodeIfPresent(MendeleyPhoto.self, forKey: .photo)
        photos = try container.decodeIfPresent([MendeleyImage].self, forKey: .photos)
        verified = try container.decodeIfPresent(Bool.self, forKey: .verified)
        marketing = try container.decodeIfPresent(Bool.self, forKey: .marketing)
        user_type = try container.decodeIfPresent(String.self, forKey: .user_type)
        location = try container.decodeIfPresent(MendeleyLocation.self, forKey: .location)
        created = try container.decodeIfPresent(Date.self, forKey: .created)
        education = try container.decodeIfPresent([MendeleyEducation].self, forKey: .education)
        employment = try container.decodeIfPresent([MendeleyEmployment].self, forKey: .employment)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        biography = try container.decodeIfPresent(String.self, forKey: .biography)
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
        try container.encodeIfPresent(display_name, forKey: .display_name)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(link, forKey: .link)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(research_interests, forKey: .research_interests)
        try container.encodeIfPresent(research_interests_list, forKey: .research_interests_list)
        try container.encodeIfPresent(academic_status, forKey: .academic_status)
        try container.encodeIfPresent(discipline, forKey: .discipline)
        try container.encodeIfPresent(disciplines, forKey: .disciplines)
        try container.encodeIfPresent(photo, forKey: .photo)
        try container.encodeIfPresent(photos, forKey: .photos)
        try container.encodeIfPresent(verified, forKey: .verified)
        try container.encodeIfPresent(marketing, forKey: .marketing)
        try container.encodeIfPresent(user_type, forKey: .user_type)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(education, forKey: .education)
        try container.encodeIfPresent(employment, forKey: .employment)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(biography, forKey: .biography)
    }
}

// MARK: - Mendeley User Profile

open class MendeleyUserProfile: MendeleyProfile {
    
}

// MARK: - Mendeley New Profile

open class MendeleyNewProfile: MendeleySwiftSecureObject, Codable {
    public var first_name: String?
    public var last_name: String?
    public var email: String?
    public var password: String?
    public var discipline: String?
    public var academic_status: String?
    public var institution: String?
    public var marketing: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case first_name
        case last_name
        case email
        case password
        case discipline
        case academic_status
        case institution
        case marketing
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        discipline = try container.decodeIfPresent(String.self, forKey: .discipline)
        academic_status = try container.decodeIfPresent(String.self, forKey: .academic_status)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        marketing = try container.decodeIfPresent(Bool.self, forKey: .marketing)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(discipline, forKey: .discipline)
        try container.encodeIfPresent(academic_status, forKey: .academic_status)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(marketing, forKey: .marketing)
    }
}
// MARK: - Mendeley Amendment Profile

open class MendeleyAmendmentProfile: MendeleySwiftSecureObject, Codable {
    public var email: String?
    public var title: String?
    public var password: String?
    public var old_password: String?
    public var first_name: String?
    public var last_name: String?
    public var academic_status: String?
    public var institution: String?
    public var biography: String?
    public var marketing: Bool?
    public var disciplines: [MendeleyDiscipline]?
    public var research_interests_list: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case email
        case title
        case password
        case old_password
        case first_name
        case last_name
        case academic_status
        case institution
        case biography
        case marketing
        case disciplines
        case research_interests_list
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        password = try container.decodeIfPresent(String.self, forKey: .password)
        old_password = try container.decodeIfPresent(String.self, forKey: .old_password)
        first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        academic_status = try container.decodeIfPresent(String.self, forKey: .academic_status)
        institution = try container.decodeIfPresent(String.self, forKey: .institution)
        biography = try container.decodeIfPresent(String.self, forKey: .biography)
        marketing = try container.decodeIfPresent(Bool.self, forKey: .marketing)
        disciplines = try container.decodeIfPresent([MendeleyDiscipline].self, forKey: .disciplines)
        research_interests_list = try container.decodeIfPresent([String].self, forKey: .research_interests_list)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(password, forKey: .password)
        try container.encodeIfPresent(old_password, forKey: .old_password)
        try container.encodeIfPresent(first_name, forKey: .first_name)
        try container.encodeIfPresent(last_name, forKey: .last_name)
        try container.encodeIfPresent(academic_status, forKey: .academic_status)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(biography, forKey: .biography)
        try container.encodeIfPresent(marketing, forKey: .marketing)
        try container.encodeIfPresent(disciplines, forKey: .disciplines)
        try container.encodeIfPresent(research_interests_list, forKey: .research_interests_list)
    }
}
