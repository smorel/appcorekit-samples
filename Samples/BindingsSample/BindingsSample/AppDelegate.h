//
//  AppDelegate.h
//  BindingsSample
//
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 In this sample we'll demonstrate an important pattern for ensuring sync accross the app between the view/controllers
 and the models that are represented by those views/controller.
 It is important to understand that viewControllers or views should not contain the state of the application.
 It is also important to understand that taking action in the UI must result in changing some model's properties
 instead of gettings other views/controllers to update them as a result of an action.
 
 Modifying a model property will "by itself" throw a KVO notification that we can handle almost everywhere.
 And this is the right way to create a too-many relashionship between what's happening when your controller
 take action and the views that must get refreshed at this particular moment!
 
 AppCoreKit provides a binding mechanism that helps you deal with this kind of notifications to update you visual
 representation as a response of changes in your models.
 Bindings have been extended to support asynchronous callbacks on Notification Center and on collections insertion/removal and on UIControl actions
 to uniformize the way we want to react to "events" in our view controller.
 
 Here is a sequence of a good way to synchronize your models and your views :
 
 1. Bind your view controller on a control's touch event (*1)
 2. Bind your view controller on your model property (*2)
 3. A touch occurs on your control : The binding (*1) catches this event and execute your code that updates your model's property.
 4. The property binding (*2) will catch the modification and execute your code that updates the views using the new model's property value.
 
 Why is it so important ?
 
 The reason is simple. Because most of the time, applications will get their models asynchronously from the web
 or other kind of data repository. Your models can also be updated by several view controllers that could be present or not
 at the same time and you don't want to create a relashionship between these view controllers and manage glue code
 to get them updated.
 
 By using bindings, your data model is your HUB for firing changes notification and all the controllers that need to display
 Those models will by the way already have a reference to this model. So use it because it free!
 
 Our binding implementation is also made to support multi-threading and by default will execute your code in the UI-thread.
 Options are availables when starting a binding context to specify wheter or not, the bindings in this context must be executed
 in the thread they receive a notification or on the UI Thread if the code you execute is not updating UI for example.
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
