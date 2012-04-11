//
//  RKConnectionHandler.m
//  myHFU
//
//  Created by Benjamin Ruoff on 03.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "RKConnectionHandler.h"

@implementation RKConnectionHandler

@synthesize mealMapping = _mealMapping, dailyMealMapping = _dailyMealMapping, appDelegate = _appDelegate;

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

- (void) loadDay:(NSString*) dateString
{
    NSString *serverAdress = @"http://78.46.19.228:8010";
    NSString *resourcePath = @"/v1/day";
    resourcePath = [resourcePath stringByAppendingString:dateString];
    //http://webuser.hs-furtwangen.de/~ruoffben/valid.json
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURLString:serverAdress];
    //[manager.mappingProvider setErrorMapping:self.dailyMealMapping];
    [manager.mappingProvider setObjectMapping:self.dailyMealMapping forKeyPath:@"data"];
    //[manager.mappingProvider addObjectMapping:self.dailyMealMapping];
    [manager loadObjectsAtResourcePath:resourcePath  delegate:self.appDelegate];
    
    //Sinnvoll wenn man es nach ResourcePathPattern machen möchte
    /*NSString *serverAdress = @"http://78.46.19.228:8010";
    NSString *resourcePath = @"/v1/day";
    resourcePath = [resourcePath stringByAppendingString:dateString];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURLString:serverAdress];
    [manager.mappingProvider setErrorMapping:self.dailyMealMapping];
    [manager.mappingProvider setObjectMapping:self.dailyMealMapping forResourcePathPattern:resourcePath];
    //[manager.mappingProvider addObjectMapping:self.dailyMealMapping];
    [manager loadObjectsAtResourcePath:resourcePath  delegate:self.appDelegate];*/
}

- (void) loadWeek:(NSString*) dateString
{
    NSString *serverAdress = @"http://78.46.19.228:8010";
    NSString *resourcePath = @"/v1/week";
    resourcePath = [resourcePath stringByAppendingString:dateString];
    //http://webuser.hs-furtwangen.de/~ruoffben/valid.json
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURLString:serverAdress];
    //[manager.mappingProvider setErrorMapping:self.dailyMealMapping];
    [manager.mappingProvider setObjectMapping:self.dailyMealMapping forKeyPath:@"data"];
    //[manager.mappingProvider addObjectMapping:self.dailyMealMapping];
    [manager loadObjectsAtResourcePath:resourcePath  delegate:self.appDelegate];
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
