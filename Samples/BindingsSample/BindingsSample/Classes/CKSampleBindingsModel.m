//
//  CKSampleBindingsModel.m
//  BindingsSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleBindingsModel.h"

@implementation CKSampleBindingsModel

- (void)postInit{
    [super postInit];
    self.string = @"Default String";
    self.integer = -1;
    self.date = [NSDate date];
}

//CKObject uses runtime and an informal dynamic protocol, based on KVO notifications, to notify itself when a property has been set.
//If you implement -(void)yourPropertyNameChanged, it will be called automatically.
//This avoid to overload setters and potential errors when you change the property attributes from retain to copy or assign.

- (void)stringChanged{
    NSLog(@"Model : string property has been set to '%@'",self.string);
}

- (void)integerChanged{
    NSLog(@"Model : integer property has been set to '%d'",self.integer);
}

- (void)dateChanged{
    NSLog(@"Model : date property has been set to '%@'",self.date);
}

@end
