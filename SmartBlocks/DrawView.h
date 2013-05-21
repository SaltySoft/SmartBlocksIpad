//
//  DrawView.h
//  zzzzzzzWebSocket
//
//  Created by Cédric Eugeni on 09/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingProtocol.h"

@interface DrawView : UIView
{
	//CGPoint lastPoint;
    CGPoint drawLastPoint;
    BOOL    mouseSwiped;
}

@property (nonatomic, strong) NSMutableDictionary *dico;

@property (nonatomic, strong) UIImageView *drawImage;
@property (nonatomic, strong) UIImageView *previewImage;

@property (nonatomic) int tool;
@property (nonatomic) int sizeLine;
@property (nonatomic) int sizeBrush;
@property (nonatomic) int sizeRectangle;

@property (nonatomic) float r;
@property (nonatomic) float g;
@property (nonatomic) float b;

@property (nonatomic, strong) id<DrawingProtocol> delegate;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)img andDelegate:(id<DrawingProtocol>)del;

- (void)beginPointWithCoordX:(int)x coordY:(int)y andUser:(NSString*)user;
- (void)drawLineWithSize:(int)size coordX:(int)x coordY:(int)y colorR:(int)r colorG:(int)g colorB:(int)B andUser:(NSString*)user;
- (void)drawRectangleWithSize:(int)size coordX:(int)x coordY:(int)y colorR:(int)r colorG:(int)g colorB:(int)b andUser:(NSString*)user;

@end
