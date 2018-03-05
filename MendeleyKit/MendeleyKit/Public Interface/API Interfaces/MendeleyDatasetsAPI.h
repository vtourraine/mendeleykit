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

//#import "MendeleyObjectAPI.h"
//#import "MendeleyKit-Swift.h"
//
//@class MendeleyDatasetParameters;
//
//@interface MendeleyDatasetsAPI : MendeleyObjectAPI
///**
// @name MendeleyDatasetsAPI
// This class provides access methods to the REST datasets API
// All of the methods are accessed via MendeleyKit.
// Developers should use the methods provided in MendeleyKit rather
// than the methods listed here.
// */
//
///**
//obtains a list of datasets for the first page.
//@param parameters the parameter set to be used in the request
//@param task
//@param completionBlock
//*/
//- (void)datasetListWithQueryParameters:(MendeleyDatasetParameters *)queryParameters
//                                  task:(MendeleyTask *)task
//                       completionBlock:(MendeleyArrayCompletionBlock)completionBlock;
//
///**
// This method is only used when paging through a list of datasets on the server.
// All required parameters are provided in the linkURL, which should not be modified
//
// @param linkURL the full HTTP link to the dataset listings page
// @param task
// @param completionBlock
// */
//- (void)datasetListWithLinkedURL:(NSURL *)linkURL
//                            task:(MendeleyTask *)task
//                 completionBlock:(MendeleyArrayCompletionBlock)completionBlock;
//
///**
// obtains a dataset for given ID from the library
// @param datasetID
// @param task
// @param completionBlock
// */
//- (void)datasetWithDatasetID:(NSString *)datasetID
//                        task:(MendeleyTask *)task
//             completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
//
///**
// Creates a dataset based on the mendeley object model provided in the argument.
// The server will respond with the JSON data structure for the new object
// @param mendeleyDataset The dataset model
// @param task The networking task
// @param completionBlock The completion block
// */
//- (void)createDataset:(MendeleyDataset *)mendeleyDataset
//                 task:(MendeleyTask *)task
//      completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
//
///**
// creates a dataset file by uploading a file, and configuring the file metadata object with the uploaded file ticket (you can then use these file metadata objects to create or update a dataset)
// @param fileURL The local URL of the file to upload
// @param filename The file name for the uploaded file (optional)
// @param contentType The file MIME type (optional)
// @param task The network task
// @param progressBlock The progress block
// @param completionBlock The completion block
// */
//- (void)createDatasetFile:(NSURL *)fileURL
//                 filename:(NSString *)filename
//              contentType:(NSString *)contentType
//                     task:(MendeleyTask *)task
//            progressBlock:(MendeleyResponseProgressBlock)progressBlock
//          completionBlock:(MendeleyObjectCompletionBlock)completionBlock;
//
///**
// obtains a list of licences that can be applied to datasets
// @param task
// @param completionBlock
// */
//- (void)datasetLicencesListWithTask:(MendeleyTask *)task
//                    completionBlock:(MendeleyArrayCompletionBlock)completionBlock;
//
//@end

