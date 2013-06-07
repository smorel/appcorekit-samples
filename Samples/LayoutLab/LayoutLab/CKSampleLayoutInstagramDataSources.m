//
//  CKSampleLayoutInstagramDataSources.m
//  LayoutSample
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleLayoutInstagramDataSources.h"

@implementation CKSampleLayoutInstagramDataSources

+ (dispatch_queue_t)dispatchQueue{
    static dispatch_queue_t kDispatchQueue = nil;
    if(kDispatchQueue == nil){
        kDispatchQueue = dispatch_queue_create("com.wherecloud.sample", 0);
    }
    return kDispatchQueue;
}

+ (void)fetchRandomUserInModel:(CKSampleLayoutInstagramModel*)model completion:(void(^)())completion{
    static NSInteger lastIndex = -1;
    dispatch_async([self dispatchQueue], ^{
        //Loads the payload from the LocalApiResults.json file
        NSString* filePath = [[[NSBundle mainBundle]URLForResource:@"CKSampleLayoutInstagramData" withExtension:@"json"]path];
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        
        //Parse the json payload to get a dictionary
        NSDictionary* dico = [NSObject objectFromJSONData:data];
        CKAssert([[dico objectForKey:@"users"]count] > 0,@"Invalid data format!");
        
        //Gets the requested range objects from the dictionary
        NSArray* users = [dico objectForKey:@"users"];
        
        //Ensure we do not have twice the same index
        NSInteger index = floorf(((CGFloat)rand() / (CGFloat)RAND_MAX) * (users.count));
        if(lastIndex == -1){
            index = 0;
        }else{
            while(index == lastIndex){
                index = floorf(((CGFloat)rand() / (CGFloat)RAND_MAX) * (users.count));
            }
        }
        lastIndex = index;
        
        //Here we can transform the dico directly to the object without mappings as
        //the dictionary content contains the exact same property names than our model.
        NSDictionary* userDictionary = [users objectAtIndex:index];
        [NSValueTransformer transform:userDictionary toObject:model];
        
        if(completion){
            completion();
        }
    });
}

@end
