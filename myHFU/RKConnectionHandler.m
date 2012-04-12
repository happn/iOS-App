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

- (void) uploadImage:(NSString*)path forMenu:(NSString*)menu
{
    RKParams *params = [RKParams params];
    //RKClient *client = [[RKClient alloc] initWithBaseURLString:@"http://78.46.19.228:8010"];

    NSData *imageData = [NSData dataWithContentsOfFile:path];
    [params setData:imageData MIMEType:@"image/png" forParam:menu];
    
    // Log info about the serialization
    NSLog(@"RKParams HTTPHeaderValueForContentType = %@", [params HTTPHeaderValueForContentType]);
    NSLog(@"RKParams HTTPHeaderValueForContentLength = %d", [params HTTPHeaderValueForContentLength]);
    
    // Send it for processing!
    [[RKClient sharedClient] put:@"/v1/picture" params:params delegate:self];

}

- (void)requestDidStartLoad:(RKRequest *)request {
    /*_uploadButton.enabled = NO;
    [_activityIndicatorView startAnimating];*/
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite 
{
    /*
    _progressView.progress = (totalBytesWritten / totalBytesExpectedToWrite) * 100.0;*/
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    /*_uploadButton.enabled = YES;
    [_activityIndicatorView stopAnimating];
    
    if ([response isOK]) {
        _statusLabel.text = @"Upload Successful!";
        _statusLabel.textColor = [UIColor greenColor];
    } else {
        _statusLabel.text = [NSString stringWithFormat:@"Upload failed with status code: %d", [response statusCode]];
        _statusLabel.textColor = [UIColor redColor];
    }*/
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    /*_uploadButton.enabled = YES;
    [_activityIndicatorView stopAnimating];
    _progressView.progress = 0.0;
    
    _statusLabel.text = [NSString stringWithFormat:@"Upload failed with error: %@", [error localizedDescription]];
    _statusLabel.textColor = [UIColor redColor];*/
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
