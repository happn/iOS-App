//
//  WebSocketTest.m
//  myHFU
//
//  Created by Benjamin Ruoff on 02.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "WebSocketTest.h"

@implementation WebSocketTest

- (void)sendRequests
{
    /*NSURL *url = [[NSURL alloc] initWithString:@"ws://78.46.19.228:8080"]; 
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    SRWebSocket *ws = [[SRWebSocket alloc] initWithURLRequest:urlRequest]; 
    ws.delegate = self;
    [ws open]; */
    
    ws = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://78.46.19.228:8080"]]];
    ws.delegate = self;
    
    [ws open];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message
{
    NSLog(@"Blub");
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Blub");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Blub");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Blub");
}

@end
