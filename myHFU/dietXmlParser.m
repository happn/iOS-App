//
//  dietXmlParser.m
//  myHFU
//
//  Created by Benjamin Ruoff on 05.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "dietXmlParser.h"
#import "Meal.h"

@implementation dietXmlParser

- (id)init
{
	self = [super init];
	
    if (self != nil) {
        // Initialize the array
        meals = [[NSMutableArray alloc] init];
    }
	
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
	if([elementName isEqualToString:@"item"]) 
    {
        rubbeldiekatz = true;
	}
    
    if([elementName isEqualToString:@"title"] && rubbeldiekatz == true) 
    {
        // Initialize the employer
		currentMeal = [[Meal alloc] init];
        currentElement = [NSString stringWithString:elementName];
    }
    
    if([elementName isEqualToString:@"description"] && rubbeldiekatz == true) 
    {
        currentElement = [NSString stringWithString:elementName];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([currentElement isEqualToString:@"title"] && rubbeldiekatz == true)
        if ([currentElement isEqualToString:[NSCharacterSet newlineCharacterSet]])
        {
            return;
        }
        else
        {
            currentMeal.day = [NSString stringWithString:string];
            currentElement = nil;
        }
    if ([currentElement isEqualToString:@"description"] && rubbeldiekatz == true)
    {
        if ([currentElement isEqualToString:[NSCharacterSet newlineCharacterSet]])
        {
            return;
        }
        else
        {
            currentMeal.description = [NSString stringWithString:string];
            currentElement = nil;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"channel"])
		return;
	
	if ([elementName isEqualToString:@"item"]) {
		[meals addObject:currentMeal];
        rubbeldiekatz = false;
	}
}

- (NSArray *)meals
{
    return [meals copy];
}

@end
