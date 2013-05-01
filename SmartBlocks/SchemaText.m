//
//  SchemaText.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 24/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "SchemaText.h"

@implementation SchemaText

@synthesize identifier, x, y;
@synthesize content;

+ (SchemaText*)getSchemaTextFromDictionary:(NSDictionary*)dico
{
    SchemaText *text = [[SchemaText alloc] init];
    
    text.identifier = [((NSNumber*)[dico objectForKey:@"id"]) integerValue];
    text.x = [((NSNumber*)[dico objectForKey:@"x"]) integerValue];
    text.y = [((NSNumber*)[dico objectForKey:@"y"]) integerValue];
    text.content = [dico objectForKey:@"content"];
    
    return text;
}

@end
