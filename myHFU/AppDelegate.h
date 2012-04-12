//
//  AppDelegate.h
//  myHFU
//
//  Created by Benjamin Ruoff on 29.11.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <RestKit/RestKit.h>
#import "RKRequestExamples.h"
#import "RKConnectionHandler.h"
#import "WebSocketTest.h"
#import "JASidePanelController.h"
#import "LeftTableViewController.h"
#import "MealViewController.h"

@class JASidePanelController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, RKObjectLoaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *loadedMeals;
@property (strong, nonatomic) NSArray *allMeals;
@property (strong, nonatomic) NSString *baseURLString;
@property (strong, nonatomic) NSString *baseURLCouchDbString;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (assign, nonatomic) BOOL playerIsPlaying;
@property (strong, nonatomic) JASidePanelController *viewController;

- (NSString*)getCurrentDate;
- (NSString*)getCurrentDateWithoutSlash;
- (NSString*)getStringDateFromDate:(NSDate*)date;

@end
