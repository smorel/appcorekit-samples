//
//  FeedSourceFactory.m
//  Copyright (c) 2012 WhereCloud Inc. All rights reserved.
//

#import "FeedSourceFactory.h"


//----------------------- CustomFeedSource

//This illustrates how to create a custom feedsource that request local results.
//As you can see the process here is not optimal as we read the whole JSON file at each request but it's just a sample ;)

@interface CustomFeedSource : CKFeedSource
@end

@implementation CustomFeedSource

- (BOOL)fetchRange:(NSRange)theRange{
    [super fetchRange:theRange];
    
    //Loads the payload from the LocalApiResults.json file
    NSString* filePath = [[[NSBundle mainBundle]URLForResource:@"LocalApiResults" withExtension:@"json"]path];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    //Parse the json payload to get a dictionary
    NSDictionary* dico = [NSObject objectFromJSONData:data];
    CKAssert([[dico objectForKey:@"results"]count] > 0,@"Invalid data format!");
    
    //Gets the requested range objects from the dictionary
    NSArray* results = [dico objectForKey:@"results"];
    NSInteger length = MIN([results count] - theRange.location,theRange.length);
    if(length <= 0){
        self.hasMore = NO;
        return NO;
    }
    
    NSArray* items = [results objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(theRange.location,(NSUInteger)length)]];
    
    //Transform the array of dictionaries to Model objects using the '$Model' mapping defined in Api.mapping.
    CKMappingContext* context =[CKMappingContext contextWithIdentifier:@"$Model"];
    
    NSError* error = nil;
    NSArray* transformedItem = [context objectsFromValue:items error:&error];
    
    //Asynchronously gets the geo localization from the address and notify the feedsource delegate (in this case, our collection) that we have new objects to insert.
    __block NSInteger numberOfReceivedLocalization = 0;
    __block CustomFeedSource* bself = self;
    for(Model* model in transformedItem){
        [FeedSourceFactory reverseGeolocalizationUsingAddress:model.address completionBlock:^(CLLocationCoordinate2D coordinates){
            model.longitude = coordinates.longitude;
            model.latitude = coordinates.latitude;
            
            numberOfReceivedLocalization++;
            if(numberOfReceivedLocalization >= [transformedItem count]){
                [bself addItems:transformedItem];
            }
        }];
    }
    
    return YES;
}

@end




//----------------------- FeedSourceFactory


@implementation FeedSourceFactory

//Retrieves the CLLocationCoordinate2D from an address using the google API.
+ (void)reverseGeolocalizationUsingAddress:(NSString*)address completionBlock:(void(^)(CLLocationCoordinate2D coordinates))completionBlock{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
	[params setObject:address forKey:@"address"];
	[params setObject:@"true" forKey:@"sensor"];
    
    NSURL* url = [NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode/json"];
	[CKWebRequest scheduledRequestWithURL:url parameters:params completion:^(id object, NSHTTPURLResponse *response, NSError *error) {
        NSString* status = [object objectForKey:@"status"];
        if([status isEqual:@"OK"] == YES){
            NSArray* results = [object objectForKey:@"results"];
            if([results count] >= 1){
                NSDictionary* firstResult = [results objectAtIndex:0];
                NSDictionary* location = [firstResult valueForKeyPath:@"geometry.location"];
                NSAssert(location != nil,@"Location not found");
                
                CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([[location objectForKey:@"lat"]floatValue], [[location objectForKey:@"lng"]floatValue]);
                if(completionBlock){
                    completionBlock(coordinates);
                }
            }
        }
    }];
}

+ (CKFeedSource*)feedSourceForModels{
    return [CustomFeedSource feedSource];
}

@end




//----------------------- CustomTransformers

@interface CustomTransformers : NSObject
@end

@implementation CustomTransformers

//The mappings defined in Api.mappings refers to this selector to transform some particular payload values to Model's properties.
+ (id)transformStringByTrimmingValue:(id)value error:(NSError**)error{
    if(![value isKindOfClass:[NSString class]]){
        *error = [NSError errorWithDomain:@"CustomTransformers" code:0 userInfo:nil];
        return nil;
    }
    
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end