//
//  DrawView.m
//  zzzzzzzWebSocket
//
//  Created by Cédric Eugeni on 09/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "DrawView.h"

@implementation DrawView

@synthesize drawImage, previewImage;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)img andDelegate:(id<DrawingProtocol>)del
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.delegate = del;
        
        drawImage = [[UIImageView alloc] initWithImage:nil];
        drawImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        drawImage.image = img;
        [self addSubview:drawImage];
        
        previewImage = [[UIImageView alloc] initWithImage:nil];
        previewImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:previewImage];
        
        self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        self.layer.borderColor = [UIColor colorWithRed:63.0/255.0 green:65.0/255.0 blue:79.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 3.0;
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        
        self.tool = 0;
        self.sizeLine = 1;
        self.sizeBrush = 1;
        self.sizeRectangle = 1;
        self.r = 0.0;
        self.g = 0.0;
        self.b = 0.0;
        
        self.dico = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Drawing Methods

- (void)beginPointWithCoordX:(int)x coordY:(int)y andUser:(NSString*)user
{
    [self.dico setObject:[NSValue valueWithCGPoint:CGPointMake(x, y)] forKey:user];
    //lastPoint = CGPointMake(x, y);
}

- (void)drawLineWithSize:(int)size coordX:(int)x coordY:(int)y colorR:(int)r colorG:(int)g colorB:(int)b andUser:(NSString*)user
{
    UIGraphicsBeginImageContext(self.frame.size);
    
	[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), (float)r/255.0, (float)g/255.0, (float)b/255.0, 1.0);
    
	CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGPoint point = [[self.dico valueForKey:user] CGPointValue];
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
    
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
    [self.dico removeObjectForKey:user];
    [self.dico setObject:[NSValue valueWithCGPoint:CGPointMake(x, y)] forKey:user];
}

- (void)drawRectangleWithSize:(int)size coordX:(int)x coordY:(int)y colorR:(int)r colorG:(int)g colorB:(int)b andUser:(NSString *)user
{
    CGPoint point = [[self.dico valueForKey:user] CGPointValue];
    
    UIGraphicsBeginImageContext(self.frame.size);
    
	[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), (float)r/255.0, (float)g/255.0, (float)b/255.0, 1.0);
    
	CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), x, point.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
    
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    [self.dico removeObjectForKey:user];
}

#pragma mark - Touching Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
    
	drawLastPoint = [touch locationInView:self];
    
//    if (self.tool == 0)
//        [self.delegate drawingBeganWithTool:self.tool andSize:self.sizeBrush andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:drawLastPoint.x andCoordY:drawLastPoint.y];
//    else if (self.tool == 1)
//        [self.delegate drawingBeganWithTool:self.tool andSize:self.sizeLine andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:drawLastPoint.x andCoordY:drawLastPoint.y];
//    else
//        [self.delegate drawingBeganWithTool:self.tool andSize:self.sizeRectangle andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:drawLastPoint.x andCoordY:drawLastPoint.y];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
    
    if (self.tool == 0)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        
        [drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.sizeBrush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r/255.0, self.g/255.0, self.b/255.0, 1.0);
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //[self.delegate drawingContinueWithTool:self.tool andSize:self.sizeBrush andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:drawLastPoint.x andCoordY:drawLastPoint.y];
        
        drawLastPoint = currentPoint;
	}
    else if (self.tool == 1)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        
        previewImage.image = nil;
        [previewImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.sizeLine);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r/255.0, self.g/255.0, self.b/255.0, 1.0);
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        previewImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //[self.delegate drawingContinueWithTool:self.tool andSize:self.sizeLine andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:currentPoint.x andCoordY:currentPoint.y];
    }
    else if (self.tool == 2)
    {
        UIGraphicsBeginImageContext(self.frame.size);
        
        previewImage.image = nil;
        [previewImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.sizeRectangle);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r/255.0, self.g/255.0, self.b/255.0, 1.0);
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, drawLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        previewImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //[self.delegate drawingContinueWithTool:self.tool andSize:self.sizeRectangle andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:currentPoint.x andCoordY:currentPoint.y];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
    
	if(!mouseSwiped)
    {
		UIGraphicsBeginImageContext(self.frame.size);
        
		[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.sizeBrush);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r/255.0, self.g/255.0, self.b/255.0, 1.0);
        
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
        
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
		UIGraphicsEndImageContext();
        
        //[self.delegate drawingEndedWithTool:self.tool andSize:self.sizeBrush andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:drawLastPoint.x andCoordY:drawLastPoint.y];
	}
    else if (self.tool == 1)
    {
        previewImage.image = nil;
        
        UIGraphicsBeginImageContext(self.frame.size);
        
		[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.sizeLine);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r/255.0, self.g/255.0, self.b/255.0, 1.0);
        
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
        
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
		UIGraphicsEndImageContext();
        
        //[self.delegate drawingEndedWithTool:self.tool andSize:self.sizeLine andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:currentPoint.x andCoordY:currentPoint.y];
    }
    else if (self.tool == 2)
    {
        previewImage.image = nil;
        
        UIGraphicsBeginImageContext(self.frame.size);
        
		[drawImage.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.sizeRectangle);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.r/255.0, self.g/255.0, self.b/255.0, 1.0);
        
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, drawLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), drawLastPoint.x, drawLastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
        
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
		UIGraphicsEndImageContext();
        
        //[self.delegate drawingEndedWithTool:self.tool andSize:self.sizeLine andColorR:self.r andColorG:self.g andColorB:self.b andCoordX:currentPoint.x andCoordY:currentPoint.y];
    }
}

- (void)dealloc
{
    self.drawImage = nil;
    self.previewImage = nil;
    self.delegate = nil;
    self.dico = nil;
}

@end
