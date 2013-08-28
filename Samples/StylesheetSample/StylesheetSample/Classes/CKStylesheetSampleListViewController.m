//
//  CKStylesheetSampleListViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleListViewController.h"
#import "CKStylesheetSampleProtocol.h"

@interface CKStylesheetSampleFactory : NSObject<CKStylesheetSampleProtocol>

+ (CKStylesheetSampleFactory*)sampleFactoryWithSampleOfClass:(Class)sampleClass fileName:(NSString*)filename title:(NSString*)title;

@property(nonatomic,retain) Class sampleClass;
@property(nonatomic,retain) NSString* sampleFilename;
@property(nonatomic,retain) NSString* sampleTitle;

@end

@implementation CKStylesheetSampleFactory

+ (CKStylesheetSampleFactory*)sampleFactoryWithSampleOfClass:(Class)sampleClass fileName:(NSString*)filename title:(NSString*)title{
    CKStylesheetSampleFactory* factory = [[CKStylesheetSampleFactory alloc]init];
    factory.sampleClass = sampleClass;
    factory.sampleTitle = title;
    factory.sampleFilename = filename;
    return factory;
}

- (CKViewController*)newViewController{
    CKViewController* controller = [[self.sampleClass alloc]init];
    controller.stylesheetFileName = self.sampleFilename;
    controller.name = self.title;
    return controller;
}

- (NSString*)stylesheetFileName{
    return self.sampleFilename;
}

- (NSString*)title{
    return _(self.sampleTitle);
}

- (NSString*)subtitle{
    NSString* subtitleKey = [NSString stringWithFormat:@"%@_subtitle",self.sampleTitle];
    NSString* result =  _(subtitleKey);
    return [subtitleKey isEqualToString:result] ? nil : result;
}

@end


static char* ignore[3] = {
    "CKStylesheetSampleViewController",
    "CKStylesheetSampleListViewController",
    "CKStylesheetSampleTextViewController" };

@interface CKStylesheetSampleListViewController ()

@end

@implementation CKStylesheetSampleListViewController

- (void)postInit{
    [super postInit];
    [self setup];
}

- (NSArray*)sampleFactoriesByAppendingViewsSampleFactories:(NSArray*)classes{
    NSArray* allViewClasses = [NSObject allClassesKindOfClass:[UIView class]];
    
    NSMutableArray* allClasses = classes ? [NSMutableArray arrayWithArray:classes] : [NSMutableArray array];
    for(Class c in allViewClasses){
        NSString* name = [c description];
        NSString* sampleClassName = [NSString stringWithFormat:@"CKStylesheetSample%@ViewController",name];
        
        Class existingClass = NSClassFromString(sampleClassName);
        if(!existingClass){
            NSString* path = [[NSBundle mainBundle]pathForResource:sampleClassName ofType:@"style"];
            
            if([[NSFileManager defaultManager]fileExistsAtPath:path]){
                CKStylesheetSampleFactory* factory = [CKStylesheetSampleFactory sampleFactoryWithSampleOfClass:[CKViewController class] fileName:sampleClassName title:sampleClassName];
                [allClasses addObject:factory];
            }
        }
    }
    
    return allClasses;
}

- (NSArray*)sampleFactoriesByAppendingViewControllersSampleFactories:(NSArray*)classes{
    NSArray* allViewControllerClasses = [NSObject allClassesKindOfClass:[CKViewController class]];
    
    NSMutableArray* allClasses = classes ? [NSMutableArray arrayWithArray:classes] : [NSMutableArray array];
    for(Class c in allViewControllerClasses){
        BOOL ignoreClass = NO;
        for(int i =0; i<3; ++i){
            NSString* ignoreString = [NSString stringWithUTF8String:ignore[i]];
            if([ignoreString isEqualToString:[c description]]){
                ignoreClass = YES;
                break;
            }
        }
        
        if(ignoreClass)
            continue;
        
        NSString* path = [[NSBundle mainBundle]pathForResource:[c description] ofType:@"style"];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path]){
            CKStylesheetSampleFactory* factory = [CKStylesheetSampleFactory sampleFactoryWithSampleOfClass:c fileName:[c description] title:[c description]];
            [allClasses addObject:factory];
        }
    }
    
    return allClasses;
}


- (NSArray*)sortedAndFilteredSampleFactories{
    NSArray* allFactories = [self sampleFactoriesByAppendingViewControllersSampleFactories:nil];
    allFactories = [self sampleFactoriesByAppendingViewsSampleFactories:allFactories];
    
    NSArray* sortedFactories = [allFactories sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 title]compare:[obj2 title]];
    }];
    
    return sortedFactories;
}

- (void)setup{
    self.style = UITableViewStylePlain;
    self.stickySelectionEnabled = YES;
    
    __unsafe_unretained CKStylesheetSampleListViewController* bself = self;
    
    NSMutableArray* cells = [NSMutableArray array];
    
    NSArray* sortedAndFilteredClasses = [self sortedAndFilteredSampleFactories];
    for(id<CKStylesheetSampleProtocol> sampleFactory in sortedAndFilteredClasses){
        CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithTitle:[sampleFactory title] subtitle:[sampleFactory subtitle] action:^(CKTableViewCellController *controller) {
            if(bself.didSelectSample){
                bself.didSelectSample(sampleFactory);
            }
        }];
        [cells addObject:cell];
    }
    
    [self addSections:@[[CKFormSection sectionWithCellControllers:cells]]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSIndexPath* firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self selectRowAtIndexPath:firstRow animated:NO];
    if(self.didSelectSample){
        CKTableViewCellController* cell = (CKTableViewCellController*)[self controllerAtIndexPath:firstRow];
        [cell didSelectRow];
    }
}

@end
