//
//  MendeleyRecommendedArticle.h
//  MendeleyKit
//
//  Created by Tunney, Aaron (ELS) on 16/08/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyObject.h"

@class MendeleyCatalogDocument;

@interface MendeleyRecommendedArticle : MendeleyObject

@property (nonatomic, strong) MendeleyCatalogDocument *catalogue_document;
@property (nonatomic, strong) NSNumber *rank;
@property (nonatomic, strong) NSString *trace;

@end
