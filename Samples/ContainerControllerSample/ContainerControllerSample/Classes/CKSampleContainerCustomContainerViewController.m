//
//  CKSampleContainerCustomContainerViewController.m
//  ContainerControllerSample
//
//  Created by Sebastien Morel on 13-06-06.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "CKSampleContainerCustomContainerViewController.h"

@implementation CKSampleContainerCustomContainerViewController

- (void)postInit{
    [super postInit];
    
    [self setup];
}

- (void)setup{
    self.title = _(@"kCustomTitle");
    
    //Creating children view controllers
    CKViewController* first = [CKViewController controllerWithName:@"first"];
    first.title = @"first";
    CKViewController* second = [CKViewController controllerWithName:@"second"];
    second.title = @"second";
    CKViewController* third = [CKViewController controllerWithName:@"third"];
    third.title = @"third";
    CKViewController* fourth = [CKViewController controllerWithName:@"fourth"];
    fourth.title = @"fourth";
    [self setViewControllers:@[first,second,third,fourth]];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSDictionary* buttons = [NSDictionary dictionaryWithObjectsAndKeys:
                             _(@"kCurl"),           @"CurlButton",
                             _(@"kFlipHorizontal"), @"FlipHorizontalButton",
                             _(@"kFlipVertical"),   @"FlipVerticalButton",
                             _(@"kFade"),           @"FadeButton",
                             _(@"kPushPop"),        @"PushPopButton",
                             nil];
    
    NSInteger pageControlHeight = 44;
    self.containerView.height -= pageControlHeight;
    
    UIView* background = [UIView viewWithFrame:CGRectMake(0,self.view.height - pageControlHeight,self.view.width,pageControlHeight)];
    background.name = @"Background";
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:background];
    
    //We'll layout those wiews in viewWillAppear after stylesheet has been applied.
    for(NSString* name in buttons){
        NSString* title = [buttons objectForKey:name];
        
        UIButton* bu = [UIButton buttonWithType:UIButtonTypeCustom];
        bu.name = name;
        [bu setTitle:title forState:UIControlStateNormal];
        bu.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [background addSubview:bu];
    }
    
    UISlider* slider = [UISlider viewWithFrame:CGRectMake(10,0,10,10)];
    slider.autoresizingMask = UIViewAutoresizingFlexibleSize;
    slider.name = @"UISlider";
    slider.value = 0;
    slider.minimumValue = 0;
    slider.maximumValue = 4;
    
    [background addSubview:slider];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Retriving the views by keypath
    UIView* background = [self.view viewWithKeyPath:@"Background"];
    UISlider* slider = [self.view viewWithKeyPath:@"Background.UISlider"];
    
    UIButton* CurlButton = [self.view viewWithKeyPath:@"Background.CurlButton"];
    UIButton* FlipHorizontalButton = [self.view viewWithKeyPath:@"Background.FlipHorizontalButton"];
    UIButton* FlipVerticalButton = [self.view viewWithKeyPath:@"Background.FlipVerticalButton"];
    UIButton* FadeButton = [self.view viewWithKeyPath:@"Background.FadeButton"];
    UIButton* PushPopButton = [self.view viewWithKeyPath:@"Background.PushPopButton"];
    
    //Select the button for the default animation
    __block NSInteger selectedAnimation = 3;
    
    NSArray* buttons = [NSArray arrayWithObjects:CurlButton,FlipHorizontalButton,FlipVerticalButton,FadeButton,PushPopButton, nil];
    [self selectButtonAtIndex:selectedAnimation inButtons:buttons];
    
    //Adjust the layout
    CGFloat minX = background.width - 10;
    for(UIButton* button in buttons){
        CGFloat x = minX - button.width;
        button.frame = CGRectMake(x,5,button.width,background.height - 10);
        minX = x - 10;
    }
    
    slider.frame = CGRectMake(10,0,minX - 10,background.height);
    
    //Establishing bindings for UIControl events
    __unsafe_unretained CKSampleContainerCustomContainerViewController* bself = self;
    
    [self beginBindingsContextByRemovingPreviousBindings];
    
    [CurlButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
        selectedAnimation = 0;
        [bself selectButtonAtIndex:selectedAnimation inButtons:buttons];
    }];
    
    [FlipHorizontalButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
        selectedAnimation = 1;
        [bself selectButtonAtIndex:selectedAnimation inButtons:buttons];
    }];
    
    [FlipVerticalButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
        selectedAnimation = 2;
        [bself selectButtonAtIndex:selectedAnimation inButtons:buttons];
    }];
    
    [FadeButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
        selectedAnimation = 3;
        [bself selectButtonAtIndex:selectedAnimation inButtons:buttons];
    }];
    
    [PushPopButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
        selectedAnimation = 4;
        [bself selectButtonAtIndex:selectedAnimation inButtons:buttons];
    }];
    
    __block NSInteger lastPage = 0;
    [slider bindEvent:UIControlEventValueChanged withBlock:^() {
        NSInteger page = slider.value;
        if(page != lastPage){
            CKTransitionType transition = CKTransitionNone;
            switch(selectedAnimation){
                case 0: transition = (lastPage > page) ? CKTransitionCurlUp : CKTransitionCurlDown; break;
                case 1: transition = (lastPage > page) ? CKTransitionFlipFromRight : CKTransitionFlipFromLeft; break;
                case 2: transition = (lastPage > page) ? CKTransitionFlipFromBottom : CKTransitionFlipFromTop; break;
                case 3: transition = CKTransitionCrossDissolve; break;
                case 4: transition = (lastPage > page) ? CKTransitionPop : CKTransitionPush; break;
            }
            [bself presentViewControllerAtIndex:page withTransition:transition];
            lastPage = page;
        }
    }];
    
    [self endBindingsContext];
}

- (void)selectButtonAtIndex:(NSInteger)index inButtons:(NSArray*)buttons{
    for(int i =0; i <[buttons count]; ++i){
        UIButton* button = [buttons objectAtIndex:i];
        button.selected = (i == index);
    }
}



@end
