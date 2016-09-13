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

#import "MendeleyProfileUtils.h"
#import "MendeleyProfile.h"

@implementation MendeleyProfileUtils

+ (MendeleyAmendmentProfile *)amendmentProfileFromProfile:(MendeleyProfile *)profile
{
    MendeleyAmendmentProfile *amendmentProfile = [MendeleyAmendmentProfile new];
    
    amendmentProfile.email = profile.email;
    amendmentProfile.title = profile.title;
    amendmentProfile.password = nil;
    amendmentProfile.old_password = nil;
    amendmentProfile.first_name = profile.first_name;
    amendmentProfile.last_name = profile.last_name;
    amendmentProfile.academic_status = profile.academic_status;
    amendmentProfile.institution = profile.institution;
    amendmentProfile.biography = profile.biography;
    amendmentProfile.marketing = profile.marketing;
    amendmentProfile.disciplines = profile.disciplines;
    amendmentProfile.research_interests_list = profile.research_interests_list;
    
    return amendmentProfile;
}

@end
