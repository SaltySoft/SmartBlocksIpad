//
//  Schema.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 24/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchemaText.h"
#import "NSData+Additions.h"

@interface Schema : NSObject

@property (nonatomic) NSInteger                 identitier;
@property (nonatomic, strong) NSString          *name;
@property (nonatomic, strong) NSMutableArray    *participants;
@property (nonatomic, strong) NSMutableArray    *participantsSession;
@property (nonatomic, strong) UIImage           *image;
@property (nonatomic, strong) NSMutableArray    *texts;

+ (NSMutableArray*)getSchemasArrayWithArray:(NSArray*)array;

@end
