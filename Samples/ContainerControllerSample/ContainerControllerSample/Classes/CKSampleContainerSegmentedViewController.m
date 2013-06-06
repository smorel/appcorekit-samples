//
//  CKSampleContainerSegmentedViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerSegmentedViewController.h"

@implementation CKSampleContainerSegmentedViewController

- (void)postInit{
    [super postInit];
    [self setup];
}

- (void)setup{
    self.title = _(@"kSegmentedTitle");
    self.segmentPosition = CKSegmentedViewControllerPositionBottom;
    
    NSMutableArray* imagePaths = [NSMutableArray arrayWithObjects:
                                  @"http://i.usatoday.net/tech/_photos/2012/07/30/NASA-to-Mars-rover-Stick-the-landing-L81VDQ59-x-large.jpg",
                                  @"http://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/NASA_Mars_Rover.jpg/300px-NASA_Mars_Rover.jpg",
                                  @"http://images.nationalgeographic.com/wpf/media-live/photos/000/578/overrides/mars-rover-landing-sequence-lowering-sky-crane_57832_600x450.jpg",
                                  @"http://images.nationalgeographic.com/wpf/media-live/photos/000/578/overrides/mars-rover-landing-sequence-outside-atmosphere_57833_600x450.jpg",
                                  nil];
    
    CKSlideShowViewController* slideShow = [CKSlideShowViewController slideShowControllerWithImagePaths:imagePaths startAtIndex:0];
    slideShow.overrideTitleToDisplayCurrentPage = NO;
    slideShow.title = @"SlideShow";
    
    CKViewController* PlaceHolder = [CKViewController controllerWithName:@"PlaceHolder"];
    PlaceHolder.title = @"PlaceHolder";
    
    [self setViewControllers:@[slideShow,PlaceHolder]];

}

@end
