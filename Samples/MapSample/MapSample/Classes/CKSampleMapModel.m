//
//  CKSampleMapModel.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "CKSampleMapModel.h"

@implementation CKSampleMapModel

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latitude,self.longitude);
}

- (NSString*)title{
    return self.name;
}

@end
