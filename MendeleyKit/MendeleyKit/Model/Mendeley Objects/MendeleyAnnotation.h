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

#import "MendeleyObject.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if TARGET_OS_MAC
#endif

@interface MendeleyAnnotation : MendeleyObject
@property (nonatomic, strong) NSDate *created;

#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIColor *color;
#else
@property (nonatomic, strong) id color;
#endif

@property (nonatomic, strong) NSString *document_id;
@property (nonatomic, strong) NSString *filehash;
@property (nonatomic, strong) NSDate *last_modified;
@property (nonatomic, strong) NSArray *positions;
@property (nonatomic, strong) NSString *privacy_level;
@property (nonatomic, strong) NSString *profile_id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;

+ (id)colorFromParameters:(NSDictionary *)colorParameters;
+ (NSDictionary *)jsonColorFromColor:(id)color;
@end


@interface MendeleyHighlighBox : NSObject
@property (nonatomic, assign) CGRect box;
@property (nonatomic, strong) NSNumber *page;

+ (MendeleyHighlighBox *)boxFromJSONParameters:(NSDictionary *)boxParameters;
+ (NSDictionary *)jsonBoxFromHighlightBox:(MendeleyHighlighBox *)box;
@end

