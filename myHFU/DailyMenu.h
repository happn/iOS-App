//
//  DailyMenu.h
//  myHFU
//
//  Created by Benjamin Ruoff on 03.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyMenu.h"
#import "Meal.h"

@interface DailyMenu : NSObject

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) Meal *menu_a;
@property (nonatomic, retain) Meal *menu_b;
@end


