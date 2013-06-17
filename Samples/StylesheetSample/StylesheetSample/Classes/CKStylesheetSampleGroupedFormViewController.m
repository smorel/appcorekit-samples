//
//  CKStylesheetSampleGroupedFormViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleGroupedFormViewController.h"

@implementation CKStylesheetSampleGroupedFormViewController

+ (NSString*)stylesheetFileName{
    return [[self class]description];
}

+ (NSString*)title{
    return _(@"Form - Grouped");
}

- (void)postInit{
    [super postInit];
    [self setup];
}

+ (NSString*)stringRepresentingAccessoryTypeUsingCellController:(CKTableViewCellController*)cell{
    CKClassPropertyDescriptor* propertyDescriptor = [NSObject propertyDescriptorForClass:[CKTableViewCellController class] key:@"accessoryType"];
    
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
        
        UIImage* image = [UIImage imageNamed:@"more-info-button"];
        CKTableViewCellController* fullStylesheet = [CKTableViewCellController cellControllerWithTitle:nil
                                                                                              subtitle:_(@"This cell illustrates all the stylesheet customization support.")
                                                                                                 image:image
                                                                                                action:^(CKTableViewCellController *controller) {
            //ACTION !
        }];
        
        if(accessoryType == UITableViewCellAccessoryDetailDisclosureButton){
            [fullStylesheet setAccessorySelectionBlock:^(CKTableViewCellController *controller) {
                //ACCESSORY ACTION !
            }];
        }
        
        fullStylesheet.cellStyle = CKTableViewCellStyleSubtitle2;
        fullStylesheet.accessoryType = accessoryType;
        fullStylesheet.name = @"fullStylesheet";
        fullStylesheet.text = [CKStylesheetSampleGroupedFormViewController stringRepresentingAccessoryTypeUsingCellController:fullStylesheet];
        
        [cells addObject:fullStylesheet];
    }

    CKFormSection* section = [CKFormSection sectionWithCellControllers:cells headerTitle:_(@"Cell Controllers :")];
    section.footerTitle = _(@"This is a section footer title\nwith 2 lines of text aligned right.");
    
    [self addSections:@[ section ]];
}

@end
