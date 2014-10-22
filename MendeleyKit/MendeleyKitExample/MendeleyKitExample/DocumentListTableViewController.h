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

#import <UIKit/UIKit.h>

@interface DocumentListTableViewController : UITableViewController
/**
 @name DocumentListTableViewController
 This class demonstrates the access and visualisation of a list of documents.
 It also shows how paging is done using the MendeleyKit.
 Paging is enabled for the following APIs
 - /documents
 - /groups
 - /annotations
 - /folders
 - /files
 
 In all cases, the page size maybe up to 500. By default MendeleyKit uses a page size of 50.
 This value may be changed in the setting of the 'limit' property in the appropriate
 MendeleyQueryRequestParameters subclasses.
 The use of the paging algorithm is demonstrated with documents API but also applies to the
 other APIs facilitating paging (see list above).
 */

@end
