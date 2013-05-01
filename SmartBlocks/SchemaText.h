//
//  SchemaText.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 24/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchemaText : NSObject

@property (nonatomic) NSInteger         identifier;
@property (nonatomic) NSInteger         x;
@property (nonatomic) NSInteger         y;
@property (nonatomic, strong) NSString  *content;

+ (SchemaText*)getSchemaTextFromDictionary:(NSDictionary*)dico;

@end
