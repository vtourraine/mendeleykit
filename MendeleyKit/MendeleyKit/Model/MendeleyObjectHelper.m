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
#import "MendeleyNewsFeed.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface MendeleyObjectHelper (Feeds)

+ (NSArray *)feedItemContentTypes;
+ (NSArray *)feedItemContentClasses;

@end

@implementation MendeleyObjectHelper (Feeds)

+ (NSArray *)feedItemContentTypes
{
    return @[kMendeleyFeedItemRSS,
             kMendeleyFeedItemNewStatus,
             kMendeleyFeedItemGroupStatus,
             kMendeleyFeedItemEmploymentUpdate,
             kMendeleyFeedItemEducationUpdate,
             kMendeleyFeedItemNewFollower,
             kMendeleyFeedItemNewPublication,
             kMendeleyFeedItemDocumentRecommendation,
             kMendeleyFeedItemPostedCataloguePublication,
             kMendeleyFeedItemPostedPublication,
             kMendeleyFeedItemGroupDocumentAdded];
}

+ (NSArray *)feedItemContentClasses
{
    return @[NSStringFromClass(MendeleyRSSJsonNode.class),
             NSStringFromClass(MendeleyNewStatusJsonNode.class),
             NSStringFromClass(MendeleyGroupStatusJsonNode.class),
             NSStringFromClass(MendeleyEmploymentUpdateJsonNode.class),
             NSStringFromClass(MendeleyEducationUpdateJsonNode.class),
             NSStringFromClass(MendeleyNewFollowerJsonNode.class),
             NSStringFromClass(MendeleyNewPublicationJsonNode.class),
             NSStringFromClass(MendeleyDocumentRecommendationJsonNode.class),
             NSStringFromClass(MendeleyPostedCataloguePublicationJsonNode.class),
             NSStringFromClass(MendeleyPostedPublicationJsonNode.class),
             NSStringFromClass(MendeleyGroupDocAddedJsonNode.class)];
}

+ (NSArray *)feedItemsourceTypes
{
    return @[kMendeleyFeedSourceTypeProfile,
             kMendeleyFeedSourceTypeRSS];
}

+ (NSArray *)feedItemSourceClasses
{
    return @[NSStringFromClass(MendeleyNewsFeedProfileSource.class),
             NSStringFromClass(MendeleyNewsFeedRSSSource.class)];
}

@end

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
        if ([propertyName isEqualToString:kMendeleyJSONPhoto] ||
            [propertyName isEqualToString:kMendeleyJSONPhotos] ||
            [propertyName isEqualToString:kMendeleyJSONLocation] ||
            [propertyName isEqualToString:kMendeleyJSONDiscipline] ||
            [propertyName isEqualToString:kMendeleyJSONDisciplines] ||
            [propertyName isEqualToString:kMendeleyJSONEmployment] ||
            [propertyName isEqualToString:kMendeleyJSONEducation])
        {
            return YES;
        }
    }

    NSString *annotationName = NSStringFromClass([MendeleyAnnotation class]);
    if ([modelName isEqualToString:annotationName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONColor] ||
            [propertyName isEqualToString:kMendeleyJSONPositions])
        {
            return YES;
        }
    }

    NSString *datasetName = NSStringFromClass([MendeleyDataset class]);
    if ([modelName isEqualToString:datasetName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDOI] ||
            [propertyName isEqualToString:kMendeleyJSONDataLicence] ||
            [propertyName isEqualToString:kMendeleyJSONVersions] ||
            [propertyName isEqualToString:kMendeleyJSONFiles] ||
            [propertyName isEqualToString:kMendeleyJSONMetrics] ||
            [propertyName isEqualToString:kMendeleyJSONContributors] ||
            [propertyName isEqualToString:kMendeleyJSONArticles] ||
            [propertyName isEqualToString:kMendeleyJSONCategories] ||
            [propertyName isEqualToString:kMendeleyJSONInstitutions] ||
            [propertyName isEqualToString:kMendeleyJSONRelatedLinks])
        {
            return YES;
        }
    }

    NSString *fileMetadataName = NSStringFromClass([MendeleyFileMetadata class]);
    if ([modelName isEqualToString:fileMetadataName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONContentDetails] ||
            [propertyName isEqualToString:kMendeleyJSONMetrics])
        {
            return YES;
        }
    }
    
    NSString *recommendedArticleName = NSStringFromClass([MendeleyRecommendedArticle class]);
    if ([modelName isEqualToString:recommendedArticleName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONCatalogDocument])
        {
            return YES;
        }
    }
    
    NSString *catalogDocumenteName = NSStringFromClass([MendeleyCatalogDocument class]);
    if ([modelName isEqualToString:catalogDocumenteName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors] ||
            [propertyName isEqualToString:kMendeleyJSONEditors] /*||
            [propertyName isEqualToString:kMendeleyJSONTags]*/)
        {
            return YES;
        }
    }
    
    NSString *newsFeedName = NSStringFromClass([MendeleyNewsFeed class]);
    if ([modelName isEqualToString:newsFeedName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONContent] ||
            [propertyName isEqualToString:kMendeleyJSONSource] ||
            [propertyName isEqualToString:kMendeleyJSONComments] ||
            [propertyName isEqualToString:kMendeleyJSONShare] ||
            [propertyName isEqualToString:kMendeleyJSONLike])
        {
            return YES;
        }
    }
    
    NSString *expandedCommentsName = NSStringFromClass([MendeleyExpandedComments class]);
    if ([modelName isEqualToString:expandedCommentsName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONLatest])
        {
            return YES;
        }
    }
    
    NSString *feedRSSSourceName = NSStringFromClass([MendeleyNewsFeedRSSSource class]);
    if ([modelName isEqualToString:feedRSSSourceName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONRSSFeed])
        {
            return YES;
        }
    }
    
    NSString *feedProfileSourceName = NSStringFromClass([MendeleyNewsFeedProfileSource class]);
    if ([modelName isEqualToString:feedProfileSourceName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONProfile])
        {
            return YES;
        }
    }
    
    NSString *socialProfileName = NSStringFromClass([MendeleySocialProfile class]);
    if ([modelName isEqualToString:socialProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return YES;
        }
    }
    
    NSString *followerProfileName = NSStringFromClass([MendeleyFollowerProfile class]);
    if ([modelName isEqualToString:followerProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return YES;
        }
    }
    
    NSString *newFollowerName = NSStringFromClass([MendeleyNewFollowerJsonNode class]);
    if ([modelName isEqualToString:newFollowerName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONFollowings])
        {
            return YES;
        }
    }
    
    NSString *newPublicationName = NSStringFromClass([MendeleyNewPublicationJsonNode class]);
    if ([modelName isEqualToString:newPublicationName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return YES;
        }
    }
    
    NSString *recommendedPublicationName = NSStringFromClass([MendeleyDocumentRecommendationJsonNode class]);
    if ([modelName isEqualToString:recommendedPublicationName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONRecommendations] ||
            [propertyName isEqualToString:kMendeleyJSONUserDocument])
        {
            return YES;
        }
    }
   
    NSString *addedDocumentName = NSStringFromClass([MendeleyGroupDocAddedJsonNode class]);
    if ([modelName isEqualToString:addedDocumentName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments] ||
            [propertyName isEqualToString:kMendeleyJSONGroup])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPublishedDocument class])] ||
        [modelName isEqualToString:NSStringFromClass([MendeleyAddedDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyUserDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyRecommendedDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyCataloguePubDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPostedCataloguePublicationJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPostedPublicationJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyNewStatusJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPost])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyGroupStatusJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPost] ||
            [propertyName isEqualToString:kMendeleyJSONGroup])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyComment class])] ||
        [modelName isEqualToString:NSStringFromClass([MendeleyExpandedComment class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONTaggedUsers])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyExpandedComment class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONProfile])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyNewUserPost class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONTaggedUsers] ||
            [propertyName isEqualToString:kMendeleyJSONDocument] ||
            [propertyName isEqualToString:kMendeleyJSONDocuments] ||
            [propertyName isEqualToString:kMendeleyJSONImages])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyProfileLink class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleySocialDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors] ||
            [propertyName isEqualToString:kMendeleyJSONFilesSummary])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyFilesSummary class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONFirstFiles])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyUserPostImage class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONOriginal] ||
            [propertyName isEqualToString:kMendeleyJSONThumbnail])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPost class])]
        || [modelName isEqualToString:NSStringFromClass([MendeleyGroupPost class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocument] ||
            [propertyName isEqualToString:kMendeleyJSONDocuments] ||
            [propertyName isEqualToString:kMendeleyJSONTaggedUsers])
        {
            return YES;
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyFeedDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return YES;
        }
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
    NSString *modelName = NSStringFromClass([modelObject class]);
    NSString *groupName = NSStringFromClass([MendeleyGroup class]);
    NSString *profileName = NSStringFromClass([MendeleyProfile class]);
    NSString *userProfileName = NSStringFromClass([MendeleyUserProfile class]);

    if ([modelName isEqualToString:groupName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyPhoto class] fromRawValue:rawValue];
        }
    }
    if ([modelName isEqualToString:profileName] || [modelName isEqualToString:userProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhoto])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyPhoto class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONLocation])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyLocation class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDiscipline])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyDiscipline class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONEmployment])
        {
            return [[self class] objectArrayForClass:[MendeleyEmployment class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONEducation])
        {
            return [[self class] objectArrayForClass:[MendeleyEducation class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return [[self class] objectArrayForClass:[MendeleyImage class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDisciplines])
        {
            return [[self class] objectArrayForClass:[MendeleyDiscipline class] fromRawValue:rawValue];
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

    NSString *datasetName = NSStringFromClass([MendeleyDataset class]);
    if ([modelName isEqualToString:datasetName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDOI])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyDOI class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDataLicence])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyLicenceInfo class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONVersions])
        {
            return [[self class] objectArrayForClass:[MendeleyVersionMetadata class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONFiles])
        {
            return [[self class] objectArrayForClass:[MendeleyFileMetadata class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONMetrics])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyDatasetMetrics class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONContributors])
        {
            return [[self class] objectArrayForClass:[MendeleyPublicContributorDetails class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONArticles])
        {
            return [[self class] objectArrayForClass:[MendeleyEmbeddedArticleView class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONCategories])
        {
            return [[self class] objectArrayForClass:[MendeleyCategory class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONInstitutions])
        {
            return [[self class] objectArrayForClass:[MendeleyInstitution class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONRelatedLinks])
        {
            return [[self class] objectArrayForClass:[MendeleyRelatedLink class] fromRawValue:rawValue];
        }
    }

    NSString *fileMetadataName = NSStringFromClass([MendeleyFileMetadata class]);
    if ([modelName isEqualToString:fileMetadataName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONContentDetails])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyFileData class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONMetrics])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyFileMetrics class] fromRawValue:rawValue];
        }
    }
    
    NSString *recommendedArticleName = NSStringFromClass([MendeleyRecommendedArticle class]);
    if ([modelName isEqualToString:recommendedArticleName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONCatalogDocument])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyCatalogDocument class] fromRawValue:rawValue];
        }
    }
    
    NSString *catalogDocumentName = NSStringFromClass([MendeleyCatalogDocument class]);
    if ([modelName isEqualToString:catalogDocumentName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors] || [propertyName isEqualToString:kMendeleyJSONEditors])
        {
            return [[self class] objectArrayForClass:[MendeleyPerson class] fromRawValue:rawValue];
        }
    }
    
    NSString *newsFeedName = NSStringFromClass([MendeleyNewsFeed class]);
    if ([modelName isEqualToString:newsFeedName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONContent])
        {
            NSString *contentType = rawValue[kMendeleyJSONType];
            NSUInteger index = [[[self class] feedItemContentTypes] indexOfObject:contentType];
            if (index != NSNotFound)
            {
                Class klass = NSClassFromString([[self class] feedItemContentClasses][index]);
                return [[self class] setPropertiesToObjectOfClass:klass fromRawValue:rawValue];
            }
            else
            {
                if (error != NULL)
                {
                    *error = [NSError errorWithCode:kMendeleyJSONTypeNotMappedToModelErrorCode];
                }
                return nil;
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONSource])
        {
            NSString *sourceType = rawValue[kMendeleyJSONType];
            NSUInteger index = [[[self class] feedItemsourceTypes] indexOfObject:sourceType];
            if (index != NSNotFound)
            {
                Class klass = NSClassFromString([[self class] feedItemSourceClasses][index]);
                return [[self class] setPropertiesToObjectOfClass:klass fromRawValue:rawValue];
            }
            else
            {
                if (error != NULL)
                {
                    *error = [NSError errorWithCode:kMendeleyJSONTypeNotMappedToModelErrorCode];
                }
                return nil;
            }
        }
        else if ([propertyName isEqualToString:kMendeleyJSONComments])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyExpandedComments class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONShare])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyShare class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONLike])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyLike class] fromRawValue:rawValue];
        }
    }
    
    NSString *expandedCommentsName = NSStringFromClass([MendeleyExpandedComments class]);
    if ([modelName isEqualToString:expandedCommentsName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONLatest])
        {
            return [[self class] objectArrayForClass:[MendeleyExpandedComment class] fromRawValue:rawValue];
        }
    }
    
    NSString *feedRSSSourceName = NSStringFromClass([MendeleyNewsFeedRSSSource class]);
    if ([modelName isEqualToString:feedRSSSourceName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONRSSFeed])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyFeedRSSFeed class] fromRawValue:rawValue];
        }
    }
    
    NSString *feedProfileSourneName = NSStringFromClass([MendeleyNewsFeedProfileSource class]);
    if ([modelName isEqualToString:feedProfileSourneName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONProfile])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleySocialProfile class] fromRawValue:rawValue];
        }
    }
    
    NSString *feedSocialProfileName = NSStringFromClass([MendeleySocialProfile class]);
    if ([modelName isEqualToString:feedSocialProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return [[self class] objectArrayForClass:[MendeleySocialProfilePhoto class] fromRawValue:rawValue];
        }
    }
    
    NSString *followerProfileName = NSStringFromClass([MendeleyFollowerProfile class]);
    if ([modelName isEqualToString:followerProfileName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return [[self class] objectArrayForClass:[MendeleySocialProfilePhoto class] fromRawValue:rawValue];
        }
    }
    
    NSString *newFollowerName = NSStringFromClass([MendeleyNewFollowerJsonNode class]);
    if ([modelName isEqualToString:newFollowerName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONFollowings])
        {
            return [[self class] objectArrayForClass:[MendeleyFollowerProfile class] fromRawValue:rawValue];
        }
    }
    
    NSString *newPublicationName = NSStringFromClass([MendeleyNewPublicationJsonNode class]);
    if ([modelName isEqualToString:newPublicationName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return [[self class] objectArrayForClass:[MendeleyPublishedDocument class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPublishedDocument class])] ||
        [modelName isEqualToString:NSStringFromClass([MendeleyAddedDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return [[self class] objectArrayForClass:[MendeleySimpleAuthor class] fromRawValue:rawValue];
        }
    }
    
    NSString *recommendedPublicationName = NSStringFromClass([MendeleyDocumentRecommendationJsonNode class]);
    if ([modelName isEqualToString:recommendedPublicationName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONRecommendations])
        {
            return [[self class] objectArrayForClass:[MendeleyRecommendedDocument class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONUserDocument])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyUserDocument class] fromRawValue:rawValue];
        }
    }
    
    NSString *addedDocumentName = NSStringFromClass([MendeleyGroupDocAddedJsonNode class]);
    if ([modelName isEqualToString:addedDocumentName])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return [[self class] objectArrayForClass:[MendeleyAddedDocument class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONGroup])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyFeedGroup class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyUserDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return  [[self class] objectArrayForClass:[MendeleySimpleAuthor class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyRecommendedDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return  [[self class] objectArrayForClass:[MendeleySimpleAuthor class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyCataloguePubDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return  [[self class] objectArrayForClass:[MendeleySimpleAuthor class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPostedCataloguePublicationJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return [[self class] objectArrayForClass:[MendeleyCataloguePubDocument class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPostedPublicationJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return [[self class] objectArrayForClass:[MendeleyCataloguePubDocument class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyNewStatusJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPost])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyPost class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyGroupStatusJsonNode class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPost])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyGroupPost class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONGroup])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyGroup class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyComment class])] ||
        [modelName isEqualToString:NSStringFromClass([MendeleyExpandedComment class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONTaggedUsers])
        {
            return [[self class] objectArrayForClass:[MendeleySocialProfile class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyExpandedComment class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONProfile])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleySocialProfile class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyNewUserPost class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONTaggedUsers])
        {
            return [[self class] objectArrayForClass:[MendeleyProfileLink class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDocument])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleySocialDocument class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return [[self class] objectArrayForClass:[MendeleySocialDocument class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONImages])
        {
            return [[self class] objectArrayForClass:[MendeleyUserPostImage class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyProfileLink class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            return [[self class] objectArrayForClass:[MendeleyImage class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleySocialDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return [[self class] objectArrayForClass:[MendeleySocialAuthor class] fromRawValue:rawValue];
        }
        else if ([propertyName isEqualToString:kMendeleyJSONFilesSummary])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyFilesSummary class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyFilesSummary class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONFirstFiles])
        {
            return [[self class] objectArrayForClass:[MendeleyFileSummary class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyUserPostImage class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONOriginal] ||
            [propertyName isEqualToString:kMendeleyJSONThumbnail])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyImage class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyPost class])]
        || [modelName isEqualToString:NSStringFromClass([MendeleyGroupPost class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONDocument])
        {
            return [[self class] setPropertiesToObjectOfClass:[MendeleyFeedDocument class] fromRawValue:rawValue];
        }
        if ([propertyName isEqualToString:kMendeleyJSONDocuments])
        {
            return [[self class] objectArrayForClass:[MendeleyFeedDocument class] fromRawValue:rawValue];
        }
        if ([propertyName isEqualToString:kMendeleyJSONTaggedUsers])
        {
            return [[self class] objectArrayForClass:[MendeleySocialProfile class] fromRawValue:rawValue];
        }
    }
    
    if ([modelName isEqualToString:NSStringFromClass([MendeleyFeedDocument class])])
    {
        if ([propertyName isEqualToString:kMendeleyJSONAuthors])
        {
            return [[self class] objectArrayForClass:[MendeleyPerson class] fromRawValue:rawValue];
        }
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
                                return dictionary;
//                return [customObject valueForKey:kMendeleyJSONName];
            }
        }
        ///TODO: these properties will be implemented properly in a future release
        else if ([propertyName isEqualToString:kMendeleyJSONPhotos])
        {
            if ([customName isEqualToString:NSStringFromClass([MendeleyImage class])])
            {
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

    NSString *fileMetadata = NSStringFromClass([MendeleyFileMetadata class]);
    if ([modelName isEqualToString:fileMetadata])
    {
        if ([propertyName isEqualToString:kMendeleyJSONContentDetails] && ((MendeleyFileData *)customObject).object_ID)
        {
            return @{kMendeleyJSONID: ((MendeleyFileData *)customObject).object_ID};
        }
    }

    NSString *dataset = NSStringFromClass([MendeleyDataset class]);
    if ([modelName isEqualToString:dataset])
    {
        if ([propertyName isEqualToString:kMendeleyJSONFiles] && [customObject isKindOfClass:[NSArray class]])
        {
            NSArray *filesMetadata = (NSArray *)customObject;
            NSMutableArray *filesDicts = [NSMutableArray arrayWithCapacity:filesMetadata.count];
            for (MendeleyFileMetadata *metadata in filesMetadata)
            {
                NSMutableDictionary *fileDict = [NSMutableDictionary dictionary];
                if (metadata.filename)
                {
                    fileDict[NSStringFromSelector(@selector(filename))] = metadata.filename;
                }
                if (metadata.content_details)
                {
                    fileDict[kMendeleyJSONContentDetails] = [self rawValueFromCustomObject:metadata.content_details modelObject:metadata propertyName:kMendeleyJSONContentDetails error:nil];
                }
                [filesDicts addObject:fileDict];
            }

            return filesDicts;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONCategories] && [customObject isKindOfClass:[NSArray class]])
        {
            NSArray *categories = (NSArray *)customObject;
            NSMutableArray *categoriesDicts = [NSMutableArray arrayWithCapacity:categories.count];
            for (MendeleyCategory *category in categories)
            {
                if (category.object_ID)
                {
                    [categoriesDicts addObject:@{kMendeleyJSONID: category.object_ID}];
                }
            }

            return categoriesDicts;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONRelatedLinks] && [customObject isKindOfClass:[NSArray class]])
        {
            NSArray *relatedLinks = (NSArray *)customObject;
            NSMutableArray *relatedLinksDicts = [NSMutableArray arrayWithCapacity:relatedLinks.count];
            for (MendeleyRelatedLink *relatedLink in relatedLinks)
            {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                if (relatedLink.rel != nil)
                {
                    dictionary[kMendeleyJSONRelatedLinksRel] = relatedLink.rel;
                }
                if (relatedLink.type != nil)
                {
                    dictionary[kMendeleyJSONRelatedLinksType] = relatedLink.type;
                }
                if (relatedLink.href != nil)
                {
                    dictionary[kMendeleyJSONRelatedLinksHref] = relatedLink.href;
                }
                [relatedLinksDicts addObject:dictionary];
            }

            return relatedLinksDicts;
        }
        else if ([propertyName isEqualToString:kMendeleyJSONDataLicence] && [customObject isKindOfClass:[MendeleyLicenceInfo class]] && ((MendeleyLicenceInfo *)customObject).object_ID)
        {
            return @{kMendeleyJSONID: ((MendeleyLicenceInfo *)customObject).object_ID};
        }
    }

    return nil;
}

@end
