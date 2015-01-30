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
#import "MendeleyModels.h"
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
                               kMendeleyJSONDescription : kMendeleyObjectDescription };
                  });
    return map;
}

+ (NSDictionary *)modelPropertyDictionary
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
                      map = @{ kMendeleyObjectID : kMendeleyJSONID,
                               kMendeleyObjectDescription : kMendeleyJSONDescription };
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
                      NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                      [formatter setLocale:enUSPOSIXLocale];
                      [formatter setDateFormat:kMendeleyJSONDateTimeFormat];
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

    NSString *modelName = NSStringFromClass([modelObject class]);
    NSString *groupName = NSStringFromClass([MendeleyGroup class]);

    if ([modelName isEqualToString:groupName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            return YES;
        }
    }

    NSString *profileName = NSStringFromClass([MendeleyProfile class]);
    NSString *userProfileName = NSStringFromClass([MendeleyUserProfile class]);

    if ([modelName isEqualToString:profileName] || [modelName isEqualToString:userProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            return YES;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONLocation])
        {
            return YES;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDiscipline])
        {
            return YES;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONEmployment])
        {
            return YES;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONEducation])
        {
            return YES;
        }
    }

    NSString *annotationName = NSStringFromClass([MendeleyAnnotation class]);
    if ([modelName isEqualToString:annotationName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONColor])
        {
            return YES;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONPositions])
        {
            return YES;
        }
    }
    return NO;
}

+ (id)customObjectFromRawValue:(id)rawValue modelObject:(id)modelObject propertyName:(NSString *)propertyName error:(NSError **)error
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
    NSString *modelName = NSStringFromClass([modelObject class]);
    NSString *groupName = NSStringFromClass([MendeleyGroup class]);
    if ([modelName isEqualToString:groupName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            if ([rawValue isKindOfClass:[NSDictionary class]])
            {
                MendeleyPhoto *photo = [MendeleyPhoto new];
                NSDictionary *dictionary = (NSDictionary *) rawValue;
                [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                     [photo setValue:obj forKeyPath:key];
                 }];
                return photo;
            }
        }
    }

    NSString *profileName = NSStringFromClass([MendeleyProfile class]);
    NSString *userProfileName = NSStringFromClass([MendeleyUserProfile class]);

    if ([modelName isEqualToString:profileName] || [modelName isEqualToString:userProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            if ([rawValue isKindOfClass:[NSDictionary class]])
            {
                MendeleyPhoto *photo = [MendeleyPhoto new];
                NSDictionary *dictionary = (NSDictionary *) rawValue;
                [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                     [photo setValue:obj forKeyPath:key];
                 }];
                return photo;
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONLocation])
        {
            if ([rawValue isKindOfClass:[NSDictionary class]])
            {
                MendeleyLocation *location = [MendeleyLocation new];
                NSDictionary *dictionary = (NSDictionary *) rawValue;
                [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                     [location setValue:obj forKeyPath:key];
                 }];
                return location;
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDiscipline])
        {
            if ([rawValue isKindOfClass:[NSDictionary class]])
            {
                MendeleyDiscipline *discipline = [MendeleyDiscipline new];
                NSDictionary *dictionary = (NSDictionary *) rawValue;
                [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                     [discipline setValue:obj forKeyPath:key];
                 }];
                return discipline;
            }

        }
        else if ([propertyName isEqualToString:kMendeleyJSONEmployment])
        {
            if ([rawValue isKindOfClass:[NSArray class]])
            {
                NSMutableArray *employmentArray = [NSMutableArray array];
                NSArray *array = (NSArray *) rawValue;
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     if ([obj isKindOfClass:[NSDictionary class]])
                     {
                         MendeleyEmployment *employment = [MendeleyEmployment new];
                         NSDictionary *dictionary = (NSDictionary *) obj;
                         [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                              [employment setValue:obj forKey:key];
                          }];
                         [employmentArray addObject:employment];
                     }
                 }];
                return employmentArray;
            }

        }
        else if ([propertyName isEqualToString:kMendeleyJSONEducation])
        {
            if ([rawValue isKindOfClass:[NSArray class]])
            {
                NSMutableArray *educationArray = [NSMutableArray array];
                NSArray *array = (NSArray *) rawValue;
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     if ([obj isKindOfClass:[NSDictionary class]])
                     {
                         MendeleyEducation *education = [MendeleyEducation new];
                         NSDictionary *dictionary = (NSDictionary *) obj;
                         [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                              [education setValue:obj forKey:key];
                          }];
                         [educationArray addObject:education];
                     }
                 }];
                return educationArray;
            }

        }
    }

    NSString *annotation = NSStringFromClass([MendeleyAnnotation class]);
    if ([modelName isEqualToString:annotation])
    {
        if ([propertyName isEqualToString:kMendeleyJSONColor])
        {
            if ([rawValue isKindOfClass:[NSDictionary class]])
            {
                id color = [MendeleyAnnotation
                            colorFromParameters:(NSDictionary *) rawValue error:error];
                return color;
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONPositions])
        {
            if ([rawValue isKindOfClass:[NSArray class]])
            {
                NSArray *data = (NSArray *) rawValue;
                NSMutableArray *parsedData = [NSMutableArray array];
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     NSDictionary *dict = (NSDictionary *) obj;
                     MendeleyHighlightBox *box = [MendeleyHighlightBox boxFromJSONParameters:dict error:error];
                     if (nil != box)
                     {
                         [parsedData addObject:box];
                     }
                     else
                     {
                         *stop = YES;
                     }
                 }];
                return parsedData;
            }
        }
    }
    return nil;
}

+ (id)rawValueFromCustomObject:(id)customObject modelObject:(id)modelObject propertyName:(NSString *)propertyName error:(NSError **)error
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

    NSString *modelName = NSStringFromClass([modelObject class]);
    NSString *customName = NSStringFromClass([customObject class]);
    NSString *groupName = NSStringFromClass([MendeleyGroup class]);
    NSString *photoName = NSStringFromClass([MendeleyPhoto class]);
    if ([modelName isEqualToString:groupName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            if ([customName isEqualToString:photoName])
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                NSDictionary *modelAttributes = [MendeleyObjectHelper propertiesAndAttributesForModel:customObject];
                [modelAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *attribute, BOOL *stop) {
                     if ([attribute rangeOfString:@"NSString"].location != NSNotFound)
                     {
                         id value = [customObject valueForKey:key];
                         [dictionary setObject:value forKey:key];
                     }
                 }];


                return dictionary;
            }
        }
    }

    NSString *profileName = NSStringFromClass([MendeleyProfile class]);
    NSString *userProfileName = NSStringFromClass([MendeleyUserProfile class]);

    if ([modelName isEqualToString:profileName] || [modelName isEqualToString:userProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            if ([customName isEqualToString:photoName])
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                NSDictionary *modelAttributes = [MendeleyObjectHelper propertiesAndAttributesForModel:customObject];
                [modelAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *attribute, BOOL *stop) {
                     if ([attribute rangeOfString:@"NSString"].location != NSNotFound)
                     {
                         id value = [customObject valueForKey:key];
                         if (nil != value)
                         {
                             [dictionary setObject:value forKey:key];
                         }
                     }
                 }];


                return dictionary;
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONLocation])
        {
            if ([customName isEqualToString:NSStringFromClass([MendeleyLocation class])])
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                NSDictionary *modelAttributes = [MendeleyObjectHelper propertiesAndAttributesForModel:customObject];
                [modelAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *attribute, BOOL *stop) {
                     if ([attribute rangeOfString:@"NSString"].location != NSNotFound ||
                         [attribute rangeOfString:@"NSNumber"].location != NSNotFound)
                     {
                         id value = [customObject valueForKey:key];
                         if (nil != value)
                         {
                             [dictionary setObject:value forKey:key];
                         }
                     }
                 }];


                return dictionary;
            }

        }
        else if ([propertyName isEqualToString:kMendeleyJSONDiscipline])
        {
            if ([customName isEqualToString:NSStringFromClass([MendeleyDiscipline class])])
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                id subdisciplines = [customObject valueForKey:kMendeleyJSONSubdisciplines];
                if (nil != subdisciplines && [subdisciplines isKindOfClass:[NSArray class]])
                {
                    [dictionary setObject:subdisciplines forKey:kMendeleyJSONSubdisciplines];
                }
                id name = [customObject valueForKey:kMendeleyJSONName];
                if (nil != name && [name isKindOfClass:[NSString class]])
                {
                    [dictionary setObject:name forKey:kMendeleyJSONName];
                }
            }

        }
        else if ([propertyName isEqualToString:kMendeleyJSONEducation])
        {
            if ([customName isEqualToString:NSStringFromClass([MendeleyEducation class])])
            {
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONEmployment])
        {
            if ([customName isEqualToString:NSStringFromClass([MendeleyEmployment class])])
            {
            }
        }
    }

    NSString *annotation = NSStringFromClass([MendeleyAnnotation class]);
    if ([modelName isEqualToString:annotation])
    {
        if ([propertyName isEqualToString:kMendeleyJSONColor])
        {
            NSDictionary *dictionary = [MendeleyAnnotation jsonColorFromColor:customObject error:error];
            return dictionary;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONPositions])
        {
            if ([customObject isKindOfClass:[NSArray class]])
            {
                NSMutableArray *positionDicts = [NSMutableArray array];
                NSArray *boxes = (NSArray *) customObject;
                [boxes enumerateObjectsUsingBlock:^(MendeleyHighlightBox *box, NSUInteger idx, BOOL *stop) {
                     NSDictionary *boxDict = [MendeleyHighlightBox jsonBoxFromHighlightBox:box error:error];
                     if (nil != boxDict)
                     {
                         [positionDicts addObject:boxDict];
                     }
                     else
                     {
                         *stop = YES;
                     }

                 }];
                return positionDicts;
            }
        }
    }

    return nil;
}

@end
