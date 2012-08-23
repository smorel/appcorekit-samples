//
//  Document.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "Document.h"

@implementation Model
@synthesize name,latitude,longitude,address,phone,imageUrl;

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latitude,self.longitude);
}

- (NSString*)title{
    return self.name;
}

@end
