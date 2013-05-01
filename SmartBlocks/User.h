//
//  User.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 23/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *session_id;

+ (User*)getCurrentUser;

@end
