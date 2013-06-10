# AppCoreKit Samples

This repository propose a bunch of samples on how to use the AppCoreKit Framework.
AppCoreKit is an application framework designed to improve productivity while creating Apps for iOS. This is the result of a 3 years experience at Wherecloud and is a production framework that shipped more than 20 apps.

AppCoreKit do not offers out of the box UI components but the technology to help you manage your data, automatic serialization, type conversions, network, view controllers, ui vs. models synchronization, appearance customization, responsive view layouts, forms, maps, objective-C runtime apis and more.

Keep in mind that AppCoreKit is a toolbox. It is non intrusive so that you can cherry pick features and learn how to use it at your own pace.

## Samples

You can clone this repository and try the samples right now as the framework is embedded in the repository as a pre-compiled binary static framework.

## API Documentation

To integrate the AppCoreKit Api documentation into Xcode, copy the following file:
<pre>./Frameworks/AppCoreKit.framework/Documentation/com.wherecloud.AppCoreKit.docset</pre> 
to 
<pre>~/Library/Developer/Shared/Documentation/DocSets/</pre>

## Using AppCoreKit in your own application

* Drag'n'drop <b>AppCoreKit.framework</b> and <b>VendorsKit.framework</b> from the <b>./Frameworks</b> folder into your Xcode project.

* Add the following frameworks and libraries to your project : 
<pre>
libstdc++.dylib, 
UIKit, Foundation, 
CoreGraphics, 
AddressBook, 
CoreData, 
QuartzCore, 
CoreLocation, 
MapKit, 
MediaPlayer, 
CoreFoundation, 
CFNetwork, 
SystemConfiguration, 
MobileCoreServices, 
AdSupport.
</pre>

* Add the following link flags in your build settings (<b>OTHER_LDFLAGS</b>) : 
<pre>
 -ObjC -all_load -lxml2 -licucore -lz -weak_library /usr/lib/libstdc++.dylib
</pre>

* As Xcode do not natively support static frameworks especially for resources, you'll need to add a post build phase if you'd like to use some components. In the build phase for your target, add a <b>"Run Script" build phase</b> and add the following script :

<pre>
YOUR_FRAMEWORKS_PATH="$PROJECT_DIR/../../Frameworks/"
sh "$YOUR_FRAMEWORKS_PATH/copy_framework_resources.sh" 
        --system-developer-dir "$SYSTEM_DEVELOPER_DIR" 
        --executable-name "$EXECUTABLE_NAME" 
        --frameworks-dir "$YOUR_FRAMEWORKS_PATH" 
        --target-build-dir "$TARGET_BUILD_DIR" 
        --project "$PROJECT" 
        --project-dir "$PROJECT_DIR"
</pre>

## Credits

If you have any comments, suggestions, question or information request, please contact us at appcorekitsupport@wherecloud.com.

You can find the sources of the AppCoreKit framework at https://github.com/wherecloud/AppCoreKit
