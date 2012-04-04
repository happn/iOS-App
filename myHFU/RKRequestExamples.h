//
//  RKRequestExamples.h
//  myHFU
//
//  Created by Benjamin Ruoff on 28.03.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//
#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@interface RKRequestExamples : NSObject <RKRequestDelegate> {
}

- (void)sendRequests;
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response;

@end
