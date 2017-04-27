//
//  MendeleyIDPlusOAuthProvider.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 27/04/2017.
//  Copyright © 2017 Mendeley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MendeleyOAuthProvider.h"

@interface MendeleyIDPlusOAuthProvider : NSObject <MendeleyOAuthProvider>
/**
 returns a singleton OAuth Provider instance
 */
+ (MendeleyIDPlusOAuthProvider *)sharedInstance;
@end
