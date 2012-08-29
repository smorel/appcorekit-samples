//
//  AppDelegate.m
//  LayoutLab
//
//  Created by Martin Dufort on 12-08-10.
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <AppCoreKit/AppCoreKit.h>

@implementation CKLicense(YourAppName)

+ (NSString*)licenseKey{
    //Return your license key here.
    return @"__APPCOREKIT_LICENSE_KEY__";
}

@end

static NSString* kSampleStrings[3] = {
    @"ioeub oqwebvro qwhbveo qwq ewfqwpeoifefj qpwef piqubwepif bqpwiefb piub qwrqwj fbwrb gkjqwr gqwgr ihqbwrig bqwhe fihqweifh qiwhe fiqhweif q2iefh oeur vwe fbweifb qwirbf iqwbef iqbwergib qwrgiboqwf bweifjbwirbg iwerni webr ig bweiurbg iweuubrgi uwberiguub wierbg ibwuev rouquwvr ouuvbsttotoya man manitou",
    @"TEST",
    @"MULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\nMULTILINE TEST\n"
};

static NSString* kSampleButtonStrings[3] = {
    @"",
    @"Button",
    @"Super long text !"
};

static NSInteger currentTextSample = 0;
static NSInteger currentButtonTextSample = 0;

@interface TestData : CKObject
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic) NSString* name;
@property(nonatomic) NSDate* date;
@property(nonatomic) NSString* text;
@end

@implementation TestData
@synthesize coordinate,name,date,text;

- (void)postInit{
    [super postInit];
    
    self.coordinate = CLLocationCoordinate2DMake(45.5195, -73.5853);
    
    self.name = @"@Smorel";
    self.date = [NSDate date];
    self.text = @"ioeub oqwebvro qwhbveo qwq ewfqwpeoifefj qpwef piqubwepif bqpwiefb piub qwrqwj fbwrb gkjqwr gqwgr ihqbwrig bqwhe fihqweifh qiwhe fiqhweif q2iefh oeur vwe fbweifb qwirbf iqwbef iqbwergib qwrgiboqwf bweifjbwirbg iwerni webr ig bweiurbg iweuubrgi uwberiguub wierbg ibwuev rouquwvr ouuvbsttotoya man manitou";
}

@end

@implementation AppDelegate

@synthesize window = _window;


- (id)init{
    self = [super init];
    [[CKStyleManager defaultManager]loadContentOfFileNamed:@"Sample"];
#ifdef DEBUG
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
#else
    [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
#endif
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    //CKViewController* controller = [CKViewController controllerWithName:@"Test"];
    
    /*controller.viewDidLoadBlock = ^(CKViewController* controller){
        
        NSDictionary* dico = [[CKStyleManager defaultManager]dictionaryForKey:@"$nextViewTest"];
        UIView* v = [NSObject objectFromDictionary:dico];
        
        v.autoresizingMask = UIViewAutoresizingFlexibleSize;
        v.frame = controller.view.bounds;
        [controller.view addSubview:v];
    };*/
    
    /*TestData* data = [TestData sharedInstance];
    
    CKFormTableViewController* controller = [CKFormTableViewController controllerWithName:@"Form"];
    CKTableViewCellController* cell = [CKTableViewCellController cellControllerWithName:@"Cell" value:data 
                                       
                                                                               bindings:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                         @"coordinate",@"contentView.Map.centerCoordinate",
                                                                                         @"name",      @"contentView.NameLabel.text",
                                                                                         @"text",      @"contentView.TextLabel.text",
                                                                                         @"date",      @"contentView.DateLabel.text",
                                                                                         nil] 
                                       
                                                                         controlActions:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                         
                                                                                         ^(UIControl* control, CKTableViewCellController* controller){
                                                                                             UILabel* v = [controller.tableViewCell.contentView viewWithKeyPath:@"TextLabel"];
                                                                                             v.hidden = !v.hidden;
                                                                                         },@"contentView.HideText",
                                                                                         
                                                                                         ^(UIControl* control, CKTableViewCellController* controller){
                                                                                             currentTextSample++;
                                                                                             if(currentTextSample >= 3) currentTextSample = 0;
                                                                                             [controller.value setText : kSampleStrings[currentTextSample]];
                                                                                         },@"contentView.ChangeText",
                                                                                         
                                                                                         ^(UIControl* control, CKTableViewCellController* controller){
                                                                                             UIButton* v = [controller.tableViewCell.contentView viewWithKeyPath:@"ChangeText"];
                                                                                             currentButtonTextSample++;
                                                                                             if(currentButtonTextSample >= 3) currentButtonTextSample = 0;
                                                                                             [v setTitle:kSampleButtonStrings[currentButtonTextSample] forState:UIControlStateNormal];
                                                                                         },@"contentView.ChangeButton",
                                                                                         
                                                                                         nil]
                                       
                                                                                 action:^(CKTableViewCellController *controller) { int i =3; }
                                       ];*/
    
    CKFormTableViewController* controller = [CKFormTableViewController controllerWithName:@"Form"];
    __block BOOL hidden = YES;
    [controller.rightButton = [UIBarButtonItem alloc]initWithTitle:@"toolbar" style:UIBarButtonItemStyleBordered block:^{
        [controller.navigationController setToolbarHidden:!hidden animated:YES];
        hidden = !hidden;
    }];
    
    
    CKTableViewCellController* cell1 = [CKTableViewCellController cellControllerWithName:@"first"];
    CKTableViewCellController* cell4 = [CKTableViewCellController cellControllerWithName:@"first"];
    CKTableViewCellController* cell2 = [CKTableViewCellController cellControllerWithName:@"second"];
    CKTableViewCellController* cell3 = [CKTableViewCellController cellControllerWithName:@"second"];
    [controller addSections:[NSArray arrayWithObject:[CKFormSection sectionWithCellControllers:[NSArray arrayWithObjects:cell1,cell2,cell4,cell3,nil]]]];
    
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController: controller];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
