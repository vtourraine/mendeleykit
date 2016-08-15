//
//  MendeleyProfileUtils.h
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS) on 28/07/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MendeleyAmendmentProfile;
@class MendeleyProfile;

@interface MendeleyProfileUtils : NSObject

+ (MendeleyAmendmentProfile *)amendmentProfileFromProfile:(MendeleyProfile *)profile;

@end
