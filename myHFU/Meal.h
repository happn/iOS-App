//
//  Meal.h
//  myHFU
//
//  Created by Benjamin Ruoff on 03.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meal : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSArray* upVotes;
@property (nonatomic, retain) NSArray* downVotes;
@property (nonatomic, retain) NSString* picture;

@end
