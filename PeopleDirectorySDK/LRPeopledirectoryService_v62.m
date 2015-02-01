/**
 * Copyright (c) 2000-2014 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

#import "LRPeopledirectoryService_v62.h"

/**
 * @author Bruno Farache
 */
@implementation LRPeopledirectoryService_v62

- (NSDictionary *)fetchAll:(NSError **)error {
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   }];
    
    NSDictionary *_command = @{@"/people-directory-services-portlet/peopledirectory/fetch-all": _params};
    
    return (NSDictionary *)[self.session invoke:_command error:error];
}

- (NSDictionary *)searchWithKeywords:(NSString *)keywords start:(int)start end:(int)end error:(NSError **)error {
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   @"keywords": keywords,
                                                                                   @"start": @(start),
                                                                                   @"end": @(end)
                                                                                   }];
    
    NSDictionary *_command = @{@"/people-directory-services-portlet/peopledirectory/search": _params};
    
    return (NSDictionary *)[self.session invoke:_command error:error];
}

- (NSDictionary *)usersFetchByDateWithModifiedDate:(LRJSONObjectWrapper *)modifiedDate error:(NSError **)error {
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   }];
    
    [self mangleWrapperWithParams:_params name:@"modifiedDate" className:@"java.sql.Timestamp" wrapper:modifiedDate];
    
    NSDictionary *_command = @{@"/people-directory-services-portlet/peopledirectory/users-fetch-by-date": _params};
    
    return (NSDictionary *)[self.session invoke:_command error:error];
}

- (NSDictionary *)usersFetchByDateWithModifiedEpochDate:(NSNumber *)modifiedEpochDate error:(NSError **)error {
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                   @"modifiedDate": modifiedEpochDate
                                                                                   }];
    
    //    [self mangleWrapperWithParams:_params name:@"modifiedDate" className:@"java.sql.Timestamp" wrapper:modifiedDate];
    
    NSDictionary *_command = @{@"/people-directory-services-portlet/peopledirectory/users-fetch-by-date": _params};
    
    return (NSDictionary *)[self.session invoke:_command error:error];
}


@end