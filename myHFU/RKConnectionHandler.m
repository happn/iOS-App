//
//  RKConnectionHandler.m
//  myHFU
//
//  Created by Benjamin Ruoff on 03.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "RKConnectionHandler.h"

@implementation RKConnectionHandler

@synthesize manager = _manager, mealMapping = _mealMapping, dailyMealMapping = _dailyMealMapping, appDelegate = _appDelegate;

- (id)init
{
	self = [super init];
	
    if (self != nil) {
        self.mealMapping = [RKObjectMapping mappingForClass:[Meal class]];
        [self.mealMapping mapKeyPath:@"title" toAttribute:@"title"];
        [self.mealMapping mapKeyPath:@"picture" toAttribute:@"picture"];
        [self.mealMapping mapKeyPath:@"up_votes" toAttribute:@"upVotes"];
        [self.mealMapping mapKeyPath:@"down_votes" toAttribute:@"downVotes"];
        self.dailyMealMapping = [RKObjectMapping mappingForClass:[DailyMenu class]];
        [self.dailyMealMapping mapKeyPath:@"date" toAttribute:@"date"];
        [self.dailyMealMapping mapKeyPath:@"menu_a" toRelationship:@"menu_a" withMapping:self.mealMapping];
        [self.dailyMealMapping mapKeyPath:@"menu_b" toRelationship:@"menu_b" withMapping:self.mealMapping];
        
        
    }
	
	return self;
}

- (void) loadDay 
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.manager = [RKObjectManager objectManagerWithBaseURL:@"http://78.46.19.228:8010/v1/showDay"];
    [self.manager loadObjectsAtResourcePath:@"/04042012" objectMapping:self.dailyMealMapping delegate:self.appDelegate];
}
/*
- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object
{
   RKLogInfo(@"didLoadObjects Id"); 
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjectDictionary:(NSDictionary*)dictionary
{
   RKLogInfo(@"didLoadObjectDictionary");  
}

- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader
{
    RKLogInfo(@"objectLoaderDidFinishLoading"); 
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader*)objectLoader
{
   RKLogInfo(@"objectLoaderDidLoadUnexpectedResponse"); 
}

- (void)objectLoader:(RKObjectLoader*)loader willMapData:(inout id *)mappableData
{
    RKLogInfo(@"willMapData"); 
}
*/
@end
