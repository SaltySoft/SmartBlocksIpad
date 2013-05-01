//
//  ILColorPickerExampleViewController.m
//  ILColorPickerExample
//
//  Created by Jon Gilkison on 9/1/11.
//  Copyright 2011 Interfacelab LLC. All rights reserved.
//

#import "ILColorPickerDualExampleController.h"

@implementation ILColorPickerDualExampleController

@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build a random color to show off setting the color on the pickers
    
    UIColor *c=[UIColor colorWithRed:(arc4random()%100)/100.0f 
                               green:(arc4random()%100)/100.0f
                                blue:(arc4random()%100)/100.0f
                               alpha:1.0];
    
    colorChip.backgroundColor=c;
    colorPicker.color=c;
    huePicker.color=c;
}

#pragma mark - ILSaturationBrightnessPickerDelegate implementation

-(void)colorPicked:(UIColor *)newColor forPicker:(ILSaturationBrightnessPickerView *)picker
{
    colorChip.backgroundColor=newColor;
    const CGFloat *components = CGColorGetComponents([newColor CGColor]);
    int red = components[0] * 255;
    int green = components[1] * 255;
    int blue = components[2] * 255;
    
    [self.delegate colorPickedWithR:red withG:green withB:blue];
}

- (CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320, 410);
}

- (void)dealloc
{
    [delegate release];
    [super dealloc];
}
@end
