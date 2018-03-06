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

@objc open class MendeleyLocation: MendeleySecureObject, Codable {
    @objc public var name: String?
    @objc public var latitude: NSNumber?
    @objc public var longitude: NSNumber?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        if let latitudeDouble = try container.decodeIfPresent(Double.self, forKey: .latitude) {
            latitude = NSNumber(value: latitudeDouble)
        }
        if let longitudeDouble = try container.decodeIfPresent(Double.self, forKey: .longitude) {
            longitude = NSNumber(value: longitudeDouble)
        }
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(latitude?.doubleValue, forKey: .latitude)
        try container.encodeIfPresent(longitude?.doubleValue, forKey: .longitude)
    }
}

// MARK: - Mendeley Employment

@objc open class MendeleyEmployment: MendeleySecureObject, Codable {
    @objc public var classes: [String]?
    @objc public var position: String?
    @objc public var is_main_employment: NSNumber?
    @objc public var institution: String?
    @objc public var start_date: Date?
    @objc public var end_date: Date?
    @objc public var website: String?
    
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
        if let is_main_employmentBool = try container.decodeIfPresent(Bool.self, forKey: .is_main_employment) {
            is_main_employment = NSNumber(value: is_main_employmentBool)
        }
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
        try container.encodeIfPresent(is_main_employment?.boolValue, forKey: .is_main_employment)
        try container.encodeIfPresent(institution, forKey: .institution)
        try container.encodeIfPresent(start_date, forKey: .start_date)
        try container.encodeIfPresent(end_date, forKey: .end_date)
        try container.encodeIfPresent(website, forKey: .website)
    }
}

// MARK: - Mendeley Education

@objc open class MendeleyEducation: MendeleySecureObject, Codable {
    @objc public var institution: String?
    @objc public var start_date: Date?
    @objc public var end_date: Date?
    @objc public var website: String?
    @objc public var degree: String?
    
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
@objc open class MendeleyDiscipline: MendeleySecureObject, Codable {
    @objc public var name: String?
    @objc public var subdisciplines: [String]?
    
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

@objc open class MendeleyImage: MendeleySecureObject, Codable {
    @objc public var width: NSNumber?
    @objc public var height: NSNumber?
    /**
     a boolean flag indicating whether this is the original image
     not to be confused with a property of the same name in
     MendeleyPhoto
     */
    @objc public var original: NSNumber?
    @objc public var url: String?
    
    private enum CodingKeys: String, CodingKey {
        case width
        case height
        case original
        case url
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let widthDouble = try container.decodeIfPresent(Double.self, forKey: .width) {
            width = NSNumber(value: widthDouble)
        }
        if let heightDouble = try container.decodeIfPresent(Double.self, forKey: .height) {
            height = NSNumber(value: heightDouble)
        }
        if let originalBool = try container.decodeIfPresent(Bool.self, forKey: .original) {
            original = NSNumber(value: originalBool)
        }
        url = try container.decodeIfPresent(String.self, forKey: .url)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(width?.doubleValue, forKey: .width)
        try container.encodeIfPresent(height?.doubleValue, forKey: .height)
        try container.encodeIfPresent(original?.boolValue, forKey: .original)
        try container.encodeIfPresent(url, forKey: .url)
    }
}

// MARK: - Mendeley Profile

@objc open class MendeleyProfile: MendeleyObject {
    @objc public var first_name: String?
    @objc public var last_name: String?
    @objc public var display_name: String?
    @objc public var email: String?
    @objc public var link: String?
    @objc public var institution: String?
    @objc public var research_interests: String?
    @objc public var research_interests_list: [String]?
    @objc public var academic_status: String?
    @objc public var discipline: MendeleyDiscipline?
    @objc public var disciplines: [MendeleyDiscipline]?
    @objc public var photo: MendeleyPhoto?
    @objc public var photos: [MendeleyImage]?
    @objc public var verified: NSNumber?
    @objc public var marketing: NSNumber?
    @objc public var user_type: String?
    @objc public var location: MendeleyLocation?
    @objc public var created: Date?
    @objc public var education: [MendeleyEducation]?
    @objc public var employment: [MendeleyEmployment]?
    @objc public var title: String?
    @objc public var biography: String?
    
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
        if let verifiedBool = try container.decodeIfPresent(Bool.self, forKey: .verified) {
            verified = NSNumber(value: verifiedBool)
        }
        if let marketingBool = try container.decodeIfPresent(Bool.self, forKey: .marketing) {
            marketing = NSNumber(value: marketingBool)
        }
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
        try container.encodeIfPresent(verified?.boolValue, forKey: .verified)
        try container.encodeIfPresent(marketing?.boolValue, forKey: .marketing)
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

@objc open class MendeleyUserProfile: MendeleyProfile {}

// MARK: - Mendeley New Profile

@objc open class MendeleyNewProfile: MendeleySecureObject, Codable {
    @objc public var first_name: String?
    @objc public var last_name: String?
    @objc public var email: String?
    @objc public var password: String?
    @objc public var discipline: String?
    @objc public var academic_status: String?
    @objc public var institution: String?
    @objc public var marketing: NSNumber?
    
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
        if let marketingBool = try container.decodeIfPresent(Bool.self, forKey: .marketing) {
            marketing = NSNumber(value: marketingBool)
        }
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
        try container.encodeIfPresent(marketing?.boolValue, forKey: .marketing)
    }
}
// MARK: - Mendeley Amendment Profile

@objc open class MendeleyAmendmentProfile: MendeleySecureObject, Codable {
    @objc public var email: String?
    @objc public var title: String?
    @objc public var password: String?
    @objc public var old_password: String?
    @objc public var first_name: String?
    @objc public var last_name: String?
    @objc public var academic_status: String?
    @objc public var institution: String?
    @objc public var biography: String?
    @objc public var marketing: NSNumber?
    @objc public var disciplines: [MendeleyDiscipline]?
    @objc public var research_interests_list: [String]?
    
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
        if let marketingBool = try container.decodeIfPresent(Bool.self, forKey: .marketing) {
            marketing = NSNumber(value: marketingBool)
        }
        disciplines = try container.decodeIfPresent([MendeleyDiscipline].self, forKey: .disciplines)
        research_interests_list = try container.decodeIfPresent([String].self, forKey: .research_interests_list)
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
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
        try container.encodeIfPresent(marketing?.boolValue, forKey: .marketing)
        try container.encodeIfPresent(disciplines, forKey: .disciplines)
        try container.encodeIfPresent(research_interests_list, forKey: .research_interests_list)
    }
}
