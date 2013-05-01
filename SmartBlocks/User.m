//
//  User.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 23/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize token, session_id;

+ (User*)getCurrentUser
{
    static User *object = nil;
    
    if (!object)
        object = [[User alloc] init];
    
    return object;
}

@end
