//
//  WebSocketTest.h
//  myHFU
//
//  Created by Benjamin Ruoff on 02.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface WebSocketTest : NSObject <SRWebSocketDelegate>
{
    SRWebSocket *ws;
}

- (void)sendRequests;

@end
