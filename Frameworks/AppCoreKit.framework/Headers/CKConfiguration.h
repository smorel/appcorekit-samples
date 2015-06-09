//
//  CKConfiguration.h
//  AppCoreKit
//
//  Created by Sebastien Morel.
//  Copyright (c) 2012 Wherecloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Singleton.h"
#import "CKCascadingTree.h"

#define ENABLE_XCODE5

typedef NS_ENUM(NSInteger, CKConfigurationType){
    CKConfigurationTypeDebug,
    CKConfigurationTypeRelease
};

/** CKConfiguration allow to enable/disable debug features in the AppCoreKit. The configuration is defined as a cascading tree in a .conf file.
 To initialize the configuration, just paste this code in your AppDelegate init method:
 
     #ifdef DEBUG
         [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeDebug];
     #else
         [CKConfiguration initWithContentOfFileNames:@"AppCoreKit" type:CKConfigurationTypeRelease];
     #endif
 
 Here is a sample configuration file enabling the debug features in debug only:
 
     "@debug" : {
         "inlineDebuggerEnabled" : 1,
         "checkViewControllerCopyInBlocks" : 1,
         "assertForBindingsOutOfContext" : 1
     },
 
     "@release" : {
     }
 */
@interface CKConfiguration : CKCascadingTree

///-----------------------------------
/// @name Initializing AppCoreKit configuration
///-----------------------------------

/** Initialize the CKConfiguration sharedInstance using the specified .cong file and the type (debug/release)
 @param fileName : The name of your .conf file.
 @param type : CKConfigurationTypeDebug or CKConfigurationTypeRelease.
 */
+ (CKConfiguration*)initWithContentOfFileNames:(NSString*)fileName type:(CKConfigurationType)type;

/** Access the type who's CKConfiguration sharedInstance has been initialized with.
 */
@property(nonatomic,assign,readonly) CKConfigurationType type;


///-----------------------------------
/// @name Accessing Configuration attributes
///-----------------------------------

/** This flag enable the inline debugger for CKViewController objects. The debugger can be launched by double tapping on the navigation bar.
 */
@property(nonatomic,assign,readwrite) BOOL inlineDebuggerEnabled;

/** This flag checks if a CKViewController object is beeing retained when a block is copied. In most cases this should not happend and can lead to retain cycles.
 This flag is only available on simulator as the process is time consuming.
 */
@property(nonatomic,assign,readwrite) BOOL checkViewControllerCopyInBlocks;

/** Enabling this flag will assert when a binding is created out of a context (beginBindingsContex/endBindingContext). Context allow to manage the life cycle of a binding. Bindings created out of a context will live forever or beeing killed when one of the referenced objects is beeing deallocated. We prefer to manage their life cycle in contexts as we know exactly when we want to start/end the binding.
 @warning This flags will be enabled only with IOS 4.3 and earlier because after 5.0, The new view controller hieracrhy from apple copies views controllers in animation blocks.
 */
@property(nonatomic,assign,readwrite) BOOL assertForBindingsOutOfContext;

/** This flag specify if the application is compiled using ARC. This will bypass some automatic deallocation in AppCoreKit objects.
 */
@property(nonatomic,assign,readwrite) BOOL usingARC;

@end
