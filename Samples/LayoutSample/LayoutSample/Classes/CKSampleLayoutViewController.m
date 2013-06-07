//
//  CKSampleLayoutViewController.m
//  LayoutSample
//
//  Created by Sebastien Morel on 13-06-07.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleLayoutViewController.h"

#define kNumberOfImageViews 6

@interface CKSampleLayoutViewController()
@property(nonatomic,retain) NSArray* imageUrlSets;
@property(nonatomic,retain) NSArray* imageUrls;
@property(nonatomic,assign) NSInteger currentIndex;
@end

@implementation CKSampleLayoutViewController

- (void)postInit{
    [super postInit];
    
    self.title = _(@"Layout - View Controller");
    self.currentIndex = 0;
    
    //Loads the payload from the LocalApiResults.json file
    NSString* filePath = [[[NSBundle mainBundle]URLForResource:@"CKSampleLayoutData" withExtension:@"json"]path];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    //Parse the json payload to get a dictionary
    self.imageUrlSets = [NSObject objectFromJSONData:data];
    
    self.imageUrls = [[self.imageUrlSets objectAtIndex:self.currentIndex]objectForKey:@"urls"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self beginBindingsContextByRemovingPreviousBindings];
    
    [self setupImageViews];
    [self scheduleNextUrls];
    
    [self endBindingsContext];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self cancelPeformBlock];
}

- (void)scheduleNextUrls{
    __unsafe_unretained CKSampleLayoutViewController* bself = self;
    
    [self performBlock:^{
        [bself nextImageUrls];
        [bself scheduleNextUrls];
    } afterDelay:2];
}

- (void)nextImageUrls{
    self.currentIndex ++;
    if(self.currentIndex >= self.imageUrlSets.count)
        self.currentIndex = 0;
    
    self.imageUrls = [[self.imageUrlSets objectAtIndex:self.currentIndex]objectForKey:@"urls"];
}

- (void)setupImageViews{
    __unsafe_unretained CKSampleLayoutViewController* bself = self;
    
    [self bind:@"imageUrls" executeBlockImmediatly:YES withBlock:^(id value) {
        for(int i =0;i<kNumberOfImageViews;++i){
            NSString* imageViewPath = [NSString stringWithFormat:@"ImageViewContainer.ImageView%d",i];
            
            CKImageView* imageView = [bself.view viewWithKeyPath:imageViewPath];
            imageView.imageURL = [NSURL URLWithString:[bself.imageUrls objectAtIndex:i]];
        }
    }];
}

@end
