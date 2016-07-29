//
//  MendeleyProfileUtils.m
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS) on 28/07/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

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
