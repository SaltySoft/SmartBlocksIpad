//
//  Schema.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 24/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "Schema.h"
#import <resolv.h>

@implementation Schema

@synthesize identitier;
@synthesize name;
@synthesize image;
@synthesize participants, participantsSession, texts;

+ (NSMutableArray*)getSchemasArrayWithArray:(NSArray*)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dico in array)
    {
        Schema *schema = [Schema getSchemaWithDictionary:dico];
        
        [result addObject:schema];
    }
    
    return result;
}

+ (id)getSchemaWithDictionary:(NSDictionary *)dico
{
    Schema *schema = [[Schema alloc] init];
    NSArray *participants = [dico objectForKey:@"participants"];
    NSArray *sessions = [dico objectForKey:@"sessions"];
    NSString *imgString = [dico objectForKey:@"data"];
    NSArray *texts = [dico objectForKey:@"texts"];
    
    schema.identitier = [((NSNumber*)[dico objectForKey:@"id"]) integerValue];
    schema.name = [dico objectForKey:@"name"];
    schema.participantsSession = [[NSMutableArray alloc] initWithArray:sessions];
    schema.participants = [[NSMutableArray alloc] init];
    schema.texts = [[NSMutableArray alloc] init];
    
    NSData *imgData = [NSData dataWithBase64EncodedString:imgString];
    
    schema.image = [UIImage imageWithData:imgData];
    
    for (NSDictionary *participantDico in participants)
    {
        [schema.participants addObject:[participantDico objectForKey:@"id"]];
    }
    
    for (NSDictionary *textDico in texts)
    {
        [schema.texts addObject:[SchemaText getSchemaTextFromDictionary:textDico]];
    }
    
    return schema;
}

@end
