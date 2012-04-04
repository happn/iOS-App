//
//  dietXmlParser.h
//  myHFU
//
//  Created by Benjamin Ruoff on 05.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class Meal;

@interface dietXmlParser : NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentElement;
    Meal *currentMeal;

    NSMutableArray *meals;
    
    BOOL rubbeldiekatz;
}
@property (nonatomic, readonly) NSArray *meals;


@end
