//
//  AppDelegate.m
//  myHFU
//
//  Created by Benjamin Ruoff on 29.11.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

//Generate UserID
@interface NSString (UUID)
+ (NSString *)uuid;
@end 

@implementation NSString (UUID)
+ (NSString *)uuid {
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
} 
@end


@implementation AppDelegate

@synthesize window = _window, allMeals = _allMeals, moviePlayer = _moviePlayer, playerIsPlaying = _playerIsPlaying, loadedMeals = _loadedMeals, baseURLString = _baseURLString, baseURLCouchDbString = _baseURLCouchDbString, connectionHandler = _connectionHandler;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Testflight Live activation
    [TestFlight takeOff:@"2398fdad899edb548aab3abd62a3da34_OTAxODYyMDEyLTA1LTE0IDE2OjUyOjQ3LjAxOTcwNw"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = [[LeftTableViewController alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[MealViewController alloc] init]];
    
    self.window.rootViewController = self.viewController;
    
    [TTURLCache sharedCache].disableImageCache = YES; 
    [TTURLCache sharedCache].disableDiskCache = YES;
    [[TTURLCache sharedCache] removeAll:YES];
    
    self.baseURLString = @"http://ec2-176-34-89-224.eu-west-1.compute.amazonaws.com:8010";
    self.baseURLCouchDbString =  @"http://ec2-176-34-89-224.eu-west-1.compute.amazonaws.com:5984";
    
    //set userID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"UID_USER_DEFAULTS_KEY"] == nil) {
        [defaults setObject:[NSString uuid] forKey:@"UID_USER_DEFAULTS_KEY"];
        [defaults synchronize];
    }
    
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURLString:self.baseURLString];
    RKClient *client = manager.client;
    //RKClient *client = [RKClient clientWithBaseURLString:self.baseURLString];
    [client setAuthenticationType:RKRequestAuthenticationTypeHTTPBasic];
    client.username = @"appclient";
    client.password = @"lassmiendlichnei";
    
    NSLog(@"I am your RKClient singleton : %@", [RKClient sharedClient]);
    
    self.connectionHandler = [[RKConnectionHandler alloc] init];
    //[self.connectionHandler loadWeek:[self getCurrentDate]];

    //Stuff we do not need to change
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (setCategoryError) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    [audioSession setActive:YES error:&activationError];
    if (activationError) { /* handle the error condition */ }
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://camm.dm.hs-furtwangen.de:8100/"]; 
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.moviePlayer.useApplicationAudioSession = NO;
    [self.moviePlayer setMovieSourceType:MPMovieSourceTypeUnknown];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch(event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if (self.playerIsPlaying == NO)
            {
                self.playerIsPlaying = YES;
                [self.moviePlayer play];
            }
            else
            {
                self.playerIsPlaying = NO;
                [self.moviePlayer pause];
            }
            break;
        case UIEventSubtypeNone:
            break;
        case UIEventSubtypeRemoteControlBeginSeekingBackward:
            break;
        case UIEventSubtypeRemoteControlEndSeekingBackward:
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self.moviePlayer play];
            break;
        case UIEventSubtypeRemoteControlStop:
            [self.moviePlayer pause];
            break;
        case UIEventSubtypeMotionShake:
            break;
        case UIEventSubtypeRemoteControlPause:
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            break;
        case UIEventSubtypeRemoteControlEndSeekingForward:
            break;
        case UIEventSubtypeRemoteControlBeginSeekingForward:
            break;
    }
}

- (void) objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{ 
    //RKLogInfo(@"Load Collection of Meals: %@", objects);
    self.loadedMeals = objects;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mealsLoaded"
                                                        object:self
                                                      userInfo:nil];

}
     
- (void) objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    //RKLogInfo(@"Some Error occured: %@", error);
}

- (NSString*)getCurrentDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"/ddMMyyyy"];
    
    
    NSDate *currentDate = [NSDate date]; // aktuelles Datum und die Uhrzeit
    if ([self checkIfIsSunday:currentDate]) //Wenn es Sonntag is soll er gleich die Nächste Woche laden
    {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        currentDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

- (NSDate*)getCurrentDateAsDate
{
    NSDate *currentDate = [NSDate date]; // aktuelles Datum und die Uhrzeit
    if ([self checkIfIsSunday:currentDate]) //Wenn es Sonntag is soll er gleich die Nächste Woche laden
    {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        currentDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
    
    return currentDate;
}

- (NSString*)getCurrentDateWithoutSlash
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyy"];
    
    
    NSDate *currentDate = [NSDate date]; // aktuelles Datum und die Uhrzeit
    if ([self checkIfIsSunday:currentDate]) //Wenn es Sonntag is soll er gleich die Nächste Woche laden
    {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        currentDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

- (NSString*)getStringDateFromDate:(NSDate*)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ddMMyyyy"];
    
    if ([self checkIfIsSunday:date]) //Wenn es Sonntag is soll er gleich die Nächste Woche laden
    {
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        date = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
    }
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

- (BOOL) checkIfIsSunday:(NSDate*)date
{
    int day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
                                               fromDate:date] weekday];
    
    if (day == 1) 
    { 
        return YES;
    }  
    else 
    {
        return NO;
    }
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.connectionHandler loadWeek:[self getCurrentDate]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

@end
