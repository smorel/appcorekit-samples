//
//  CKStylesheetSampleGroupedFormViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleGroupedFormViewController.h"

@implementation CKStylesheetSampleGroupedFormViewController

- (instancetype)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)postInit{
    [super postInit];
    [self setup];
}

+ (NSString*)stringRepresentingAccessoryTypeUsingCellController:(CKStandardContentViewController*)cell{
    CKClassPropertyDescriptor* propertyDescriptor = [NSObject propertyDescriptorForClass:[CKReusableViewController class] key:@"accessoryType"];
    
    CKPropertyExtendedAttributes* attributes = [propertyDescriptor extendedAttributesForInstance:cell];
    CKEnumDescriptor* enumDescriptor = attributes.enumDescriptor;
    
    for(NSString* label in [enumDescriptor.valuesAndLabels allKeys]){
        NSInteger value = [[enumDescriptor.valuesAndLabels objectForKey:label]intValue];
        if(value == cell.accessoryType){
            //get the localized string version of "accessoryType"
            return _(label);
        }
    }
    
    return nil;
}

- (void)setup{
    NSMutableArray* cells = [NSMutableArray array];
    
    //Setup 1 cell for each supported accessory types

    for(int accessoryType = UITableViewCellAccessoryNone; accessoryType <= UITableViewCellAccessoryCheckmark; ++accessoryType){
        
        CKStandardContentViewController* fullStylesheet = [CKStandardContentViewController controllerWithTitle:nil
                                                                                              subtitle:_(@"This cell illustrates all the stylesheet customization support.")
                                                                                                 imageName:@"more-info-button"
                                                                                                action:^(CKStandardContentViewController *controller) {
            //ACTION !
        }];
        
        if(accessoryType == UITableViewCellAccessoryDetailDisclosureButton){
            fullStylesheet.didSelectAccessoryBlock = ^(CKReusableViewController* controller) {
                //ACCESSORY ACTION !
            };
        }
        
        fullStylesheet.accessoryType = accessoryType;
        fullStylesheet.name = @"fullStylesheet";
        fullStylesheet.title = [CKStylesheetSampleGroupedFormViewController stringRepresentingAccessoryTypeUsingCellController:fullStylesheet];
        
        [cells addObject:fullStylesheet];
    }

    CKSection* section = [CKSection sectionWithControllers:cells headerTitle:_(@"Cell Controllers :")];
    section.footerTitle = _(@"This is a section footer title\nwith 2 lines of text aligned right.");
    
    [self addSections:@[ section ] animated:NO];
}

@end
