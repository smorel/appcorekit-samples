//
//  CKStylesheetSampleTextViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleTextViewController.h"
#import "JSONSyntaxHighlight.h"

@interface CKStylesheetSampleTextViewController ()
@property(nonatomic,retain) UILabel* label;
@property(nonatomic,retain) UIScrollView* scrollView;
@end

@implementation CKStylesheetSampleTextViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleSize;
    [self.view addSubview:self.scrollView];
    
    self.label = [[UILabel alloc]init];
    [self.scrollView addSubview:self.label];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self update];
}

- (void)setContent:(NSString *)theContent{
    _content = theContent;
    
    if(self.label){
        if([CKOSVersion() floatValue] >= 6){
            id JSONObj = [NSJSONSerialization JSONObjectWithData:[_content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            
            // create the JSONSyntaxHighilight Object
            JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:JSONObj];
            
            // place the text into the view
            self.label.attributedText = [jsh highlightJSON];
        }else{
            self.label.text = theContent;
        }
        [self update];
    }
}

- (void)update{
    if(self.label && self.scrollView){
        CGSize size = CGSizeMake(0, 0);
        if([CKOSVersion() floatValue] >= 6){
            size = [self.label sizeThatFits:CGSizeMake(self.view.width, MAXFLOAT)];
        }else{
            size = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(self.view.width,MAXFLOAT)];
        }
        
        self.label.frame = CGRectMake(0,0,size.width,size.height);
        self.scrollView.contentSize = size;
    }
}

@end
