//
//  colorPickedProtocol.h
//  zzzzzzzWebSocket
//
//  Created by Cédric Eugeni on 13/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ColorPickedProtocol <NSObject>

@required
- (void)colorPickedWithR:(int)rColor withG:(int)gColor withB:(int)bColor;

@end
