//
//  DrawingProtocol.h
//  zzzzzzzWebSocket
//
//  Created by Cédric Eugeni on 10/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DrawingProtocol <NSObject>

- (void)drawingBeganWithTool:(int)tool andSize:(int)size andColorR:(float)r andColorG:(float)g andColorB:(float)b andCoordX:(int)x andCoordY:(int)y;
- (void)drawingContinueWithTool:(int)tool andSize:(int)size andColorR:(float)r andColorG:(float)g andColorB:(float)b andCoordX:(int)x andCoordY:(int)y;
- (void)drawingEndedWithTool:(int)tool andSize:(int)size andColorR:(float)r andColorG:(float)g andColorB:(float)b andCoordX:(int)x andCoordY:(int)y;

@end
