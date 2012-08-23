//
//  ViewControllerFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "ViewControllerFactory.h"

@implementation ViewControllerFactory

//------------------------------------- CKFormTableViewController

+ (CKFormTableViewController*)tableWithWebSitesWithSelectionBlock:(void(^)(NSURL* url))selectionBlock{
    NSMutableArray* urls = [NSMutableArray arrayWithObjects:
                            [NSURL URLWithString:@"http://www.google.com"],
                            [NSURL URLWithString:@"http://www.stackoverflow.com"],
                            [NSURL URLWithString:@"http://www.github.com"],
                            nil];
    
    NSMutableArray* cells = [NSMutableArray array];
    for(NSURL* url in urls){
        CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:[url description] action:^(CKTableViewCellController *controller) {
            if(selectionBlock){
                selectionBlock(url);
            }
        }];
        cell.value = url;
        [cells addObject:cell];
    }
    
    CKFormTableViewController* form = [CKFormTableViewController controllerWithName:@"WebSitesForm"];
    form.stickySelectionEnabled = YES;
    
    [form addSections:[NSArray arrayWithObject:[CKFormSection sectionWithCellControllers:cells]]];
    
    //Initialize first selected row
    __block BOOL initialized = NO;
    form.viewWillAppearBlock = ^(CKViewController* controller, BOOL animated){
        CKFormTableViewController* form = (CKFormTableViewController*)controller;
        
        if(!initialized){
            initialized = YES;
            [form selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
            
            if(selectionBlock){
                selectionBlock([urls objectAtIndex:0]);
            }
        }
    };
    
    return form;
}

+ (CKFormTableViewController*)breadCrumbFormWithIndexSet:(NSIndexPath*)indexSet breadCrumbController:(CKBreadCrumbViewController*)breadCrumbController{
    BOOL stop = ([indexSet length] >=5);
    
    NSMutableArray* cells = [NSMutableArray array];
    for(int i=0; i<10; ++i){
        NSIndexPath* newIndexSet = [indexSet indexPathByAddingIndex:i];
        
        NSMutableString* title = [NSMutableString stringWithString:_(@"kBreadCrumbCellTitle")];
        
        if(newIndexSet){
            for(int j=0;j<[newIndexSet length]; ++j){
                [title appendFormat:@"_%d",[newIndexSet indexAtPosition:j]];
            }
        }
        
        __block CKBreadCrumbViewController* bBreadCrumbController = breadCrumbController;
        CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:title action:stop ? nil : ^(CKTableViewCellController* controller){
            CKFormTableViewController* newController = [self breadCrumbFormWithIndexSet:newIndexSet breadCrumbController:bBreadCrumbController];
            newController.title = title;
            [bBreadCrumbController pushViewController:newController animated:YES];
        }];
        [cells addObject:cell];
    }
    
    CKFormTableViewController* form = [CKFormTableViewController controllerWithName:@"BreadCrumbForm"];
    [form addSections:[NSArray arrayWithObject:[CKFormSection sectionWithCellControllers:cells]]];
    return form;
}

//------------------------------------- CKSplitViewController

+ (CKViewController*)viewControllerForSplitterSeparator{
    CKViewController* controller = [CKViewController controllerWithName:@"SplitterSeparator"];
    controller.viewDidLoadBlock = ^(CKViewController* controller){
        {
            UIButton* bu = [UIButton buttonWithType:UIButtonTypeCustom];
            bu.name = @"ShowHideLeft";
            
            //This could have been made in stylesheets
            [bu setImage:[UIImage imageNamed:@"CKWebViewControllerGoBack"] forState:UIControlStateNormal];
            [bu setImage:[UIImage imageNamed:@"CKWebViewControllerGoForward"] forState:UIControlStateSelected];
            [bu sizeToFit];
            
            bu.frame = CGRectMake(controller.view.width / 2 - bu.width / 2,10,bu.width,bu.height);
            bu.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [controller.view addSubview:bu];
        }
        
        {
            UIButton* bu = [UIButton buttonWithType:UIButtonTypeCustom];
            bu.name = @"ShowHideRight";
            
            //This could have been made in stylesheets
            [bu setImage:[UIImage imageNamed:@"CKWebViewControllerGoBack"] forState:UIControlStateSelected];
            [bu setImage:[UIImage imageNamed:@"CKWebViewControllerGoForward"] forState:UIControlStateNormal];
            [bu sizeToFit];
            bu.frame = CGRectMake(controller.view.width / 2 - bu.width / 2,controller.view.height - bu.height - 10,bu.width,bu.height);
            bu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [controller.view addSubview:bu];
        }
    };
    return controller;
}

+ (CKSplitViewController*)splitViewController{
    //Creating the splitView controller
    CKSplitViewController* Splitter = [CKSplitViewController controllerWithName:@"Splitter"];
    Splitter.title = _(@"kSplitterTitle");
    
    //Creates a web browser view controller
    CKWebBrowserViewController* browser = [CKWebBrowserViewController controllerWithName:@"WebSiteBrowser"];
    browser.viewWillAppearEndBlock = ^(CKViewController* controller, BOOL animated){
        [controller.navigationController setNavigationBarHidden:YES];
        [controller.navigationController setToolbarHidden:NO animated:NO];
    };
    
    //Creates a table view controller whose cell selection sets the browser url.
    __block CKWebBrowserViewController* bBrowser = browser;
    CKFormTableViewController* table = [self tableWithWebSitesWithSelectionBlock:^(NSURL* url){
        bBrowser.homeURL = url;
    }];
    
    
    __block CKFormTableViewController* bTable = table;
    
    //Creates a split view separator controller allowing to show/hide the table or the webBrowser
    CKViewController* splitSeparatorViewController = [self viewControllerForSplitterSeparator];
    splitSeparatorViewController.viewWillAppearBlock = ^(CKViewController* controller, BOOL animated){
        UIButton* ShowHideLeft = [controller.view viewWithKeyPath:@"ShowHideLeft"];
        UIButton* ShowHideRight = [controller.view viewWithKeyPath:@"ShowHideRight"];
        
        __block CKViewController* bsplitSeparatorViewController = controller;
        
        [controller beginBindingsContextByRemovingPreviousBindings];
        [ShowHideLeft bindEvent:UIControlEventTouchUpInside withBlock:^(){
            ShowHideLeft.selected = !ShowHideLeft.selected;
            ShowHideRight.enabled = !ShowHideLeft.selected;
            if(ShowHideLeft.selected){
                //hide left
                [Splitter setViewControllers:[NSArray arrayWithObjects:
                                              bsplitSeparatorViewController,
                                              [UINavigationController navigationControllerWithRootViewController:bBrowser], 
                                              nil] animated:YES];
            }else{
                //show left
                [Splitter setViewControllers:[NSArray arrayWithObjects:
                                              bTable,
                                              bsplitSeparatorViewController,
                                              [UINavigationController navigationControllerWithRootViewController:bBrowser], 
                                              nil] animated:YES];
            }
        }];
        
        //As table constroller has a fixed size defined in stylesheet,
        //when hiding the right controller, we have to switch this constraint to
        //be flexible in order to fill the whole screen.
        //set it back the original constraint when the right view controller comes back.
        
        __block CKSplitViewConstraintsType tableOriginalConstraintType;
        [ShowHideRight bindEvent:UIControlEventTouchUpInside withBlock:^(){
            ShowHideRight.selected = !ShowHideRight.selected;
            ShowHideLeft.enabled = !ShowHideRight.selected;
            if(ShowHideRight.selected){
                //hide right
                
                tableOriginalConstraintType = bTable.splitViewConstraints.type;
                bTable.splitViewConstraints.type = CKSplitViewConstraintsTypeFlexibleSize;
                
                [Splitter setViewControllers:[NSArray arrayWithObjects:
                                              bTable,
                                              bsplitSeparatorViewController,
                                              nil] animated:YES];
            }else{
                //show right
                bTable.splitViewConstraints.type = tableOriginalConstraintType;
                [Splitter setViewControllers:[NSArray arrayWithObjects:
                                              bTable,
                                              bsplitSeparatorViewController,
                                              [UINavigationController navigationControllerWithRootViewController:bBrowser], 
                                              nil] animated:YES];
            }
        }];
        [controller endBindingsContext];
    };
    
    //Initialize the splitter with the 3 viewControllers at launch
    [Splitter setViewControllers:[NSArray arrayWithObjects:table,splitSeparatorViewController,[UINavigationController navigationControllerWithRootViewController:browser], nil]];
    
    return Splitter;
}

//------------------------------------- CKSegmentedViewController

+ (CKSegmentedViewController*)segmentedViewController{
    CKSegmentedViewController* Segmented = [CKSegmentedViewController controllerWithName:@"Segmented"];
    Segmented.title = _(@"kSegmentedTitle");
    Segmented.segmentPosition = CKSegmentedViewControllerPositionBottom;
    
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
    
    [Segmented setViewControllers:[NSArray arrayWithObjects:slideShow,PlaceHolder, nil]];
    
    return Segmented;
}

//------------------------------------- CKBreadCrumbViewController

+ (CKBreadCrumbViewController*)breadcrumbViewController{
    CKBreadCrumbViewController* BreadCrumb = [CKBreadCrumbViewController controllerWithName:@"BreadCrumb"];
    BreadCrumb.title = _(@"kBreadCrumbTitle");
    
    CKFormTableViewController* first = [self breadCrumbFormWithIndexSet:[NSIndexPath indexPathWithIndex:0] breadCrumbController:BreadCrumb];
    first.title = _(@"kBreadCrumbFirstTitle");
    [BreadCrumb setViewControllers:[NSArray arrayWithObjects:first, nil]];

    return BreadCrumb;
}


//------------------------------------- CKContainerViewController

+ (void)selectButtonAtIndex:(NSInteger)index inButtons:(NSArray*)buttons{
    for(int i =0; i <[buttons count]; ++i){
        UIButton* button = [buttons objectAtIndex:i];
        button.selected = (i == index);
    }
}

+ (CKContainerViewController*)customContainerViewController{
    CKContainerViewController* Custom = [CKContainerViewController controllerWithName:@"Custom"];
    Custom.title = _(@"kCustomTitle");
    
    //Creating children view controllers
    CKViewController* first = [CKViewController controllerWithName:@"first"];
    first.title = @"first";
    CKViewController* second = [CKViewController controllerWithName:@"second"];
    second.title = @"second";
    CKViewController* third = [CKViewController controllerWithName:@"third"];
    third.title = @"third";
    CKViewController* fourth = [CKViewController controllerWithName:@"fourth"];
    fourth.title = @"fourth";
    [Custom setViewControllers:[NSArray arrayWithObjects:first,second,third,fourth, nil]];
    
    NSDictionary* buttons = [NSDictionary dictionaryWithObjectsAndKeys:
                             _(@"kCurl"),           @"CurlButton", 
                             _(@"kFlipHorizontal"), @"FlipHorizontalButton", 
                             _(@"kFlipVertical"),   @"FlipVerticalButton", 
                             _(@"kFade"),           @"FadeButton", 
                             _(@"kPushPop"),        @"PushPopButton", 
                             nil];
    
    __block NSInteger lastPage = 0;
    
    //Setuping the Custom view controller view
    Custom.viewDidLoadBlock = ^(CKViewController* controller){
        CKContainerViewController* Custom = (CKContainerViewController*)controller;
        
        NSInteger pageControlHeight = 44;
        Custom.containerView.height -= pageControlHeight;
        
        UIView* background = [UIView viewWithFrame:CGRectMake(0,controller.view.height - pageControlHeight,controller.view.width,pageControlHeight)];
        background.name = @"Background";
        background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [controller.view addSubview:background];
        
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
        slider.value = lastPage;
        slider.minimumValue = 0;
        slider.maximumValue = 4;
        
        [background addSubview:slider];
    };
    
    __block NSInteger selectedAnimation = 3;
    Custom.viewWillAppearBlock = ^(CKViewController* controller,BOOL animated){
        //Retriving the views by keypath
        UIView* background = [controller.view viewWithKeyPath:@"Background"];
        UISlider* slider = [controller.view viewWithKeyPath:@"Background.UISlider"];
        
        UIButton* CurlButton = [controller.view viewWithKeyPath:@"Background.CurlButton"];
        UIButton* FlipHorizontalButton = [controller.view viewWithKeyPath:@"Background.FlipHorizontalButton"];
        UIButton* FlipVerticalButton = [controller.view viewWithKeyPath:@"Background.FlipVerticalButton"];
        UIButton* FadeButton = [controller.view viewWithKeyPath:@"Background.FadeButton"];
        UIButton* PushPopButton = [controller.view viewWithKeyPath:@"Background.PushPopButton"];
        
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
        __block CKContainerViewController* bCustom = (CKContainerViewController*)controller;
        [controller beginBindingsContextByRemovingPreviousBindings];
        [CurlButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
            selectedAnimation = 0;
            [self selectButtonAtIndex:selectedAnimation inButtons:buttons];
        }];
        [FlipHorizontalButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
            selectedAnimation = 1;
            [self selectButtonAtIndex:selectedAnimation inButtons:buttons];
        }];
        [FlipVerticalButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
            selectedAnimation = 2;
            [self selectButtonAtIndex:selectedAnimation inButtons:buttons];
        }];
        [FadeButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
            selectedAnimation = 3;
            [self selectButtonAtIndex:selectedAnimation inButtons:buttons];
        }];
        [PushPopButton bindEvent:UIControlEventTouchUpInside withBlock:^() {
            selectedAnimation = 4;
            [self selectButtonAtIndex:selectedAnimation inButtons:buttons];
        }];
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
                [bCustom presentViewControllerAtIndex:page withTransition:transition];
                lastPage = page;
            }
        }];
        [controller endBindingsContext];
    };
    
    return Custom;
}

//------------------------------------- CKTabViewController

+ (CKViewController*)mainViewController{
    NSMutableArray* controllers = [NSMutableArray array];
    
    [controllers addObject:[self splitViewController]];
    [controllers addObject:[self segmentedViewController]];
    [controllers addObject:[self breadcrumbViewController]];
    [controllers addObject:[self customContainerViewController]];
    
    CKTabViewController* mainTab = [CKTabViewController controllerWithViewControllers:controllers];
    mainTab.name = @"MainTab";
    return mainTab;
}

@end
