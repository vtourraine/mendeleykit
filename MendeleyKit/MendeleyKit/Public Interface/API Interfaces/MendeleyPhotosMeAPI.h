//
//  MendeleyPhotosMeAPI.h
//  MendeleyKit
//
//  Created by Trevisi, Luigi (ELS) on 28/07/2016.
//  Copyright © 2016 Mendeley. All rights reserved.
//

#import "MendeleyObjectAPI.h"

@interface MendeleyPhotosMeAPI : MendeleyObjectAPI

- (void)uploadPhotoWithFile:(NSURL *)fileURL
                contentType:(NSString *)contentType
              contentLength:(NSInteger)contentLength
                       task:(MendeleyTask *)task
              progressBlock:(MendeleyResponseProgressBlock)progressBlock
            completionBlock:(MendeleyCompletionBlock)completionBlock;

@end
