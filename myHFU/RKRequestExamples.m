//
//  RKRequestExamples.m
//  myHFU
//
//  Created by Benjamin Ruoff on 28.03.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "RKRequestExamples.h"

@implementation RKRequestExamples

- (void)sendRequests {
    // Perform a simple HTTP GET and call me back with the results
    NSLog(@"I am your RKClient singleton : %@", [RKClient sharedClient]);
    [[RKClient sharedClient] get:@"/v1/showDay/28032012" delegate:self];
    
    //NSLog(@"I am your RKClient singleton : %@", [[RKClient sharedClient] baseURL]);
    // Send a POST to a remote resource. The dictionary will be transparently
    // converted into a URL encoded representation and sent along as the request body
    NSDictionary* params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"123456", @"a", @"up", nil] forKeys:[NSArray arrayWithObjects:@"user", @"menu", @"vote", nil]];
    
    [[RKClient sharedClient] post:@"/v1/vote/28032012" params:params delegate:self];
    
    
    //[NSArray arrayWithObjects:@"Screen J",
    // DELETE a remote resource from the server
    //[ [RKClient client] delete:@"/missing_resource.txt" delegate:self];
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {
        // Handling GET /foo.xml
        
        if ([response isOK]) {
            // Success! Let's take a look at the data
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);
        }
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isPOST]) {
        
        // Handling POST /other.json        
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our POST!");
        }
        
    } else if ([request isDELETE]) {
        
        // Handling DELETE /missing_resource.txt
        if ([response isNotFound]) {
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);
        }
    }
}

@end
