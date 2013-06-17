//
//  CKStylesheetSampleTextViewController.m
//  StylesheetSample
//
//  Created by Sebastien Morel on 2013-06-17.
//  Copyright (c) 2013 Sebastien Morel. All rights reserved.
//

#import "CKStylesheetSampleTextViewController.h"

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
        self.label.text = theContent;
        [self update];
    }
}

- (void)update{
    if(self.label && self.scrollView){
        CGSize size = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
        
        self.label.frame = CGRectMake(0,0,size.width,size.height);
        self.scrollView.contentSize = size;
    }
}

@end
