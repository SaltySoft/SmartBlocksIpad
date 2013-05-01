//
//  DrawingVC.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 01/05/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrawView.h"
#import "Schema.h"
#import "ILColorPickerDualExampleController.h"

@interface DrawingVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, ColorPickedProtocol, DrawingProtocol>

@property (nonatomic, strong) NSMutableArray                        *brushSizesArray;
@property (nonatomic, strong) Schema                                *schema;

@property (weak, nonatomic) IBOutlet UIPickerView                   *brushSizePickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem                *sizeButton;
@property (weak, nonatomic) IBOutlet UIToolbar                      *donePickerToolbar;

@property (nonatomic, strong) DrawView                              *drawView;
@property (nonatomic, strong) ILColorPickerDualExampleController    *colorPicker;
@property (nonatomic, strong) UIPopoverController                   *popController;

- (IBAction)SizeTapped:(id)sender;
- (IBAction)PickerDone:(id)sender;
- (IBAction)PopColor:(id)sender;
- (IBAction)SwitchTool:(id)sender;

@end
