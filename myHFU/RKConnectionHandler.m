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

- (void) makeMenuVote:(NSString*) menu parameter:(NSDictionary*) params
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSString *serverAdress = self.appDelegate.baseURLString;
    NSString *resourcePath = [[NSString stringWithFormat:@"/v1/vote%@", self.appDelegate.getCurrentDate] appendQueryParams:params];

    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:resourcePath delegate:self];
}

- (void) loadDay:(NSString*) dateString
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *serverAdress = self.appDelegate.baseURLString;
    NSString *resourcePath = @"/v1/day";
    resourcePath = [resourcePath stringByAppendingString:dateString];
    
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURLString:serverAdress];
    [manager.mappingProvider setObjectMapping:self.dailyMealMapping forKeyPath:@"data"];
    [manager loadObjectsAtResourcePath:resourcePath  delegate:self.appDelegate];
}

- (void) loadWeek:(NSString*) dateString
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *resourcePath = @"/v1/week";
    resourcePath = [resourcePath stringByAppendingString:dateString];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    [manager.mappingProvider setObjectMapping:self.dailyMealMapping forKeyPath:@"data"];
    [manager loadObjectsAtResourcePath:resourcePath  delegate:self.appDelegate];
}

- (void) uploadImage:(NSString*)path forMenu:(NSString*)menu setDelegate:(id)object
{
    RKParams *params = [RKParams params];

    NSData *imageData = [NSData dataWithContentsOfFile:path];
    [params setData:imageData MIMEType:@"image/jpg" forParam:menu];
    
    // Log info about the serialization
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
    
    // Send it for processing!
    [[RKClient sharedClient] put:@"/v1/picture" params:params delegate:object];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error;
{}



@end
