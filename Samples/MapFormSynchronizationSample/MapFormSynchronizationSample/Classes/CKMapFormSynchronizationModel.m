//
//  CKMapFormSynchronizationModel.m
//  MapFormSynchronizationSample
//
//  Created by Sebastien Morel on 13-06-10.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKMapFormSynchronizationModel.h"

@implementation CKMapFormSynchronizationModel

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.latitude,self.longitude);
}

- (NSString*)title{
    return self.name;
}

- (NSString*)subtitle{
    return self.phone;
}

@end
