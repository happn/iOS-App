//
//  RKConnectionHandler.h
//  myHFU
//
//  Created by Benjamin Ruoff on 03.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>
#import "Meal.h"
#import "DailyMenu.h"

@class AppDelegate;

@interface RKConnectionHandler : NSObject

@property (strong, nonatomic) RKObjectMapping *mealMapping;
@property (strong, nonatomic) RKObjectMapping *dailyMealMapping;
@property (assign, nonatomic) AppDelegate *appDelegate;

- (void) loadDay:(NSString*) dateString;
- (void) loadWeek:(NSString*) dateString;

@end
