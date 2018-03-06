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

#import "MendeleyObjectHelper.h"
#import <objc/runtime.h>
#import "MendeleyOAuthCredentials.h"
#import "NSError+MendeleyError.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@implementation MendeleyObjectHelper

+ (NSDictionary *)jsonPropertyDictionary
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        map = @{ kMendeleyJSONID : kMendeleyObjectID,
                 kMendeleyJSONDescription : kMendeleyObjectDescription,
                 kMendeleyJSONVersion : kMendeleyObjectVersion };
    });
    return map;
}

+ (NSDictionary *)modelPropertyDictionary
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        map = @{ kMendeleyObjectID : kMendeleyJSONID,
                 kMendeleyObjectDescription : kMendeleyJSONDescription,
                 kMendeleyObjectVersion : kMendeleyJSONVersion };
    });
    return map;
}

+ (NSDictionary *)arrayToModelDictionary
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        map = @{ kMendeleyJSONAuthors : kMendeleyModelPerson,
                 kMendeleyJSONEditors : kMendeleyModelPerson,
                 kMendeleyJSONTranslators : kMendeleyModelPerson,
                 kMendeleyJSONEmployment : kMendeleyModelEmployment,
                 kMendeleyJSONEducation : kMendeleyModelEducation,
                 kMendeleyJSONWebsites : kMendeleyModelWebsites,
                 kMendeleyJSONTags : kMendeleyModelTags,
                 kMendeleyJSONKeywords : kMendeleyModelKeywords,
                 kMendeleyJSONSubdisciplines: kMendeleyModelSubdisciplines,
                 kMendeleyJSONDisciplines : kMendeleyModelDisciplines,
                 kMendeleyJSONReaderCountByAcademicStatus : kMendeleyModelReaderCountByAcademicStatus,
                 kMendeleyJSONReaderCountByCountry : kMendeleyModelReaderCountByCountry,
                 kMendeleyJSONReaderCountByDiscipline : kMendeleyModelReaderCountByDiscipline };
    });
    return map;
}

+ (NSDateFormatter *)jsonDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:kMendeleyPosixDefaultFormat];
        formatter.timeZone = [NSTimeZone timeZoneWithName:kMendeleyTimeZoneUTC];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:kMendeleyJSONDateTimeFormat];
    });
    return formatter;
}

+ (NSDateFormatter *)shortJsonDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:kMendeleyPosixDefaultFormat];
        formatter.timeZone = [NSTimeZone timeZoneWithName:kMendeleyTimeZoneUTC];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:kMendeleyShortJSONDateTimeFormat];
    });
    return formatter;
}

+ (NSDictionary *)propertiesAndAttributesForModel:(id)model
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    Class currentClass = [model class];

    do
    {
        unsigned int numberOfProperties = 0;
        objc_property_t *classProperties = class_copyPropertyList(currentClass, &numberOfProperties);
        for (int propertyIndex = 0; propertyIndex < numberOfProperties; ++propertyIndex)
        {
            objc_property_t property = classProperties[propertyIndex];
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
            [dictionary setObject:attribute forKey:name];
        }
        currentClass = [currentClass superclass];
    }
    while ([currentClass superclass]);
    return dictionary;
}

+ (NSArray *)propertyNamesForModel:(id)model
{
    NSDictionary *propDictionary = [[self class] propertiesAndAttributesForModel:model];

    return propDictionary.allKeys;
}

+ (NSString *)matchedKeyForJSONKey:(NSString *)key
{
    NSString *matchedKey = [[[self class] jsonPropertyDictionary] objectForKey:key];

    if (nil == matchedKey)
    {
        matchedKey = key;
    }
    return matchedKey;
}

+ (NSString *)matchedJSONKeyForKey:(NSString *)key
{
    NSString *matchedKey = [[[self class] modelPropertyDictionary] objectForKey:key];

    if (nil == matchedKey)
    {
        matchedKey = key;
    }
    return matchedKey;
}

+ (id)modelFromClassName:(NSString *)className error:(NSError **)error
{
    if (nil == className)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyUnrecognisedModelErrorCode];
        }
        return nil;
    }

    Class modelClass = NSClassFromString(className);

    if (nil == modelClass)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyUnrecognisedModelErrorCode];
        }
        return nil;
    }

    id model = [[modelClass alloc] init];
    if (nil == model)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
    }
    return model;
}

+ (BOOL)isCustomizableModelObject:(id)modelObject
                  forPropertyName:(NSString *)propertyName
                            error:(NSError **)error
{
    if (nil == propertyName)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return NO;
    }

    if (nil == modelObject)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return NO;
    }

    return NO;
}

+ (id)setPropertiesToObjectOfClass:(Class)klass fromRawValue:(id)rawValue
{
    if ([rawValue isKindOfClass:[NSDictionary class]])
    {
        id object = [klass new];
        NSDictionary *propertyNames = [[self class] propertiesAndAttributesForModel:object];
        [propertyNames.allKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            NSString *matchedKey = [self matchedJSONKeyForKey:key];

            if ([self isCustomizableModelObject:object forPropertyName:matchedKey error:nil])
            {
                id customObject = [self customObjectFromRawValue:rawValue[matchedKey] modelObject:object propertyName:matchedKey error:nil];
                [object setValue:customObject forKeyPath:key];
            }
            else if ([propertyNames[key] rangeOfString:@"NSDate"].location != NSNotFound)
            {
                NSString *dateString = (NSString *) rawValue[matchedKey];
                NSDate *date = [[MendeleyObjectHelper jsonDateFormatter] dateFromString:dateString];
                if (!date)
                {
                    date = [[MendeleyObjectHelper shortJsonDateFormatter    ] dateFromString:dateString];
                }
                [object setValue:date forKey:key];
            }
            else
            {
                // Note that this will not work if the property of the object we are trying to assign is a primitive type
                if (rawValue[matchedKey] != [NSNull null])
                {
                    [object setValue:rawValue[matchedKey] forKeyPath:key];
                }
            }
         }];
        return object;
    }
    return nil;
}

+ (NSArray *)objectArrayForClass:(Class)klass fromRawValue:(id)rawValue
{
    if ([rawValue isKindOfClass:[NSArray class]])
    {
        NSMutableArray *objectArray = [NSMutableArray array];
        NSArray *array = (NSArray *) rawValue;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id object = [[self class] setPropertiesToObjectOfClass:klass fromRawValue:obj];

            if (object)
            {
                [objectArray addObject:object];
            }
        }];
        return objectArray;
    }
    return nil;
}

+ (id)customObjectFromRawValue:(id)rawValue
                   modelObject:(id)modelObject
                  propertyName:(NSString *)propertyName
                         error:(NSError *__autoreleasing*)error
{
    if (nil == propertyName)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return nil;
    }

    if (nil == modelObject)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return nil;
    }

    if (nil == rawValue)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return nil;
    }
    
    return nil;
}

+ (id)rawValueFromCustomObject:(id)customObject
                   modelObject:(id)modelObject
                  propertyName:(NSString *)propertyName
                         error:(NSError *__autoreleasing*)error
{
    if (nil == propertyName)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return nil;
    }

    if (nil == modelObject)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return nil;
    }

    if (nil == customObject)
    {
        if (NULL != error)
        {
            *error = [NSError errorWithCode:kMendeleyModelOrPropertyNilErrorCode];
        }
        return nil;
    }
    
    return nil;
}

@end
