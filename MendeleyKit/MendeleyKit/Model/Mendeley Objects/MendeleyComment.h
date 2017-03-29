//
//  MendeleyComment.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 29/03/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

#import "MendeleyObject.h"

@class MendeleySocialProfile;

@interface MendeleyComment : MendeleyObject

@property (nonatomic, strong) NSString *news_item_id;
@property (nonatomic, strong) NSString *profile_id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *creted;
@property (nonatomic, strong) NSDate *last_modified;
@property (nonatomic, strong) NSNumber *news_item_owner;

@end

@interface MendeleyExpandedComment : MendeleyComment

@property (nonatomic, strong) MendeleySocialProfile *profile;

@end

@interface MendeleyCommentUpdate : MendeleySecureObject

@property (nonatomic, strong) NSString *text;

@end


