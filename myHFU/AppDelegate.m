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

#import "JASidePanelController.h"
#import "LeftTableViewController.h"
#import "MealViewController.h"


@implementation AppDelegate

@synthesize window = _window, allMeals = _allMeals, moviePlayer = _moviePlayer, playerIsPlaying = _playerIsPlaying, connectionHandler = _connectionHandler, loadedMeals = _loadedMeals;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.leftPanel = [[LeftTableViewController alloc] init];
    self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[MealViewController alloc] init]];
    
    

    
    //self.viewController.centerPanel.navigationController.title = @"FUUUUU";
    
    //self.viewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:34.0 green:23.0 blue:56.0 alpha:1];
    //self.viewController.rightPanel = [[RightViewController alloc] init];
    
    [[[[self.viewController gestureController] navigationController] navigationBar] setBarStyle:UIBarStyleBlack];

    
    self.window.rootViewController = self.viewController;
    
    self.connectionHandler = [[RKConnectionHandler alloc] init];
    [self.connectionHandler loadDay:[self getCurrentDate]];

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
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
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
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
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
