//
//  CKMapFormSynchronizationDataSources.m
//  MapFormSynchronizationSample
//
//  Created by Sebastien Morel on 13-06-10.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKMapFormSynchronizationDataSources.h"

@interface Paging : NSObject

+ (NSRange)rangeWithPageOfSize:(NSInteger)pageSize usingRange:(NSRange)range;

@end

@implementation Paging

+ (NSRange)rangeWithPageOfSize:(NSInteger)pageSize usingRange:(NSRange)range{
    NSInteger numberOfPages = floorf(range.location / pageSize);
    NSInteger rounded = (numberOfPages * pageSize);
    return NSMakeRange(rounded, pageSize);
}

@end

@implementation CKMapFormSynchronizationDataSources

+ (CKFeedSource*)sourceForFoursquareVenuesNear:(NSString*)near section:(NSString*)section{
    CKWebSource* source = [CKWebSource webSource];
    source.requestBlock = ^(NSRange range){
        
        NSRange pagedRange = [Paging rangeWithPageOfSize:40 usingRange:range];
        
        NSDictionary* params = @{ @"near"          : near,
                                  @"section"       : section,
                                  @"offset"        : [NSNumber numberWithInt:pagedRange.location],
                                  @"limit"         : [NSNumber numberWithInt:pagedRange.length],
                                  @"venuePhotos"   : [NSNumber numberWithBool:YES],
                                  @"client_id"     : @"REFZ1OZ44LBWGW5JWWTLB154IMUZ5ZBWRTQ5YNWYMVMX14F0",
                                  @"client_secret" : @"FIAG2QEHGVM20SGI0LECB5JRNCB0JY0IXPKMXMKAZGRLZMAK" };
        
        return [CKWebRequest requestForObjectsWithUrl:[NSURL URLWithString:@"https://api.foursquare.com/v2/venues/explore"]
                                               params:params
                                                 body:nil
                             mappingContextIdentifier:@"$CKMapFormSynchronizationModel"
                                     transformRawData:^NSArray *(id value) {  return [[[[value objectForKey:@"response"]objectForKey:@"groups"]objectAtIndex:0]objectForKey:@"items"]; }
                                           completion:nil
                                                error:nil];
    };
    
    return source;
}

@end
