//
//  DrawingVC.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 01/05/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "DrawingVC.h"

@interface DrawingVC ()

@end

@implementation DrawingVC

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.drawView = [[DrawView alloc] initWithFrame:CGRectMake(2, 2, 1020, 655) andImage:self.schema.image andDelegate:self];
    [self.view addSubview:self.drawView];
    
    self.brushSizesArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.brushSizesArray = nil;
    self.drawView = nil;
    self.colorPicker = nil;
    self.popController = nil;
}

#pragma mark - IBActions

- (IBAction)SizeTapped:(id)sender
{
    [self.brushSizePickerView setHidden:NO];
    [self.donePickerToolbar setHidden:NO];
    [self.view bringSubviewToFront:self.brushSizePickerView];
    [self.view bringSubviewToFront:self.donePickerToolbar];
    
    [self.brushSizePickerView setFrame:CGRectMake(0, 748 + self.donePickerToolbar.frame.size.height, self.brushSizePickerView.frame.size.width, self.brushSizePickerView.frame.size.height)];
    [self.donePickerToolbar setFrame:CGRectMake(0, 748, self.donePickerToolbar.frame.size.width, self.donePickerToolbar.frame.size.height)];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.donePickerToolbar.transform = CGAffineTransformTranslate(self.donePickerToolbar.transform, 0, - self.donePickerToolbar.frame.size.height - self.brushSizePickerView.frame.size.height);
        self.brushSizePickerView.transform = CGAffineTransformTranslate(self.brushSizePickerView.transform, 0, - self.donePickerToolbar.frame.size.height - self.brushSizePickerView.frame.size.height);
    } completion:nil];
    
    int selected = 0;
    
    if (self.drawView.tool == 0)
        selected = self.drawView.sizeBrush;
    else if (self.drawView.tool == 1)
        selected = self.drawView.sizeLine;
    else
        selected = self.drawView.sizeRectangle;
    
    [self.brushSizePickerView selectRow:selected - 1 inComponent:0 animated:YES];
}

- (IBAction)PickerDone:(id)sender
{
    NSString *selected = [self.brushSizesArray objectAtIndex:[self.brushSizePickerView selectedRowInComponent:0]];
    [self.sizeButton setTitle:[NSString stringWithFormat:@"Taille: %@",selected]];
    int size = [selected intValue];
    
    if (self.drawView.tool == 0)
        self.drawView.sizeBrush = size;
    else if (self.drawView.tool == 1)
        self.drawView.sizeLine = size;
    else
        self.drawView.sizeRectangle = size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.brushSizePickerView setFrame:CGRectMake(0, 748 + self.donePickerToolbar.frame.size.height, self.brushSizePickerView.frame.size.width, self.brushSizePickerView.frame.size.height)];
        [self.donePickerToolbar setFrame:CGRectMake(0, 748, self.donePickerToolbar.frame.size.width, self.donePickerToolbar.frame.size.height)];
    } completion:nil];
}

- (IBAction)PopColor:(id)sender
{
    if (self.colorPicker == nil)
    {
        //Create the ColorPickerViewController.
        self.colorPicker = [[ILColorPickerDualExampleController alloc] initWithNibName:@"ILColorPickerDualExampleController" bundle:nil];
        self.colorPicker.delegate = self;
        //Set this VC as the delegate.
        //self.colorPicker.delegate = self;
    }
    
    if (self.popController == nil)
    {
        //The color picker popover is not showing. Show it.
        self.popController = [[UIPopoverController alloc] initWithContentViewController:self.colorPicker];
        [self.popController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
                                   permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else
    {
        //The color picker popover is showing. Hide it.
        
        [self.popController dismissPopoverAnimated:YES];
        self.popController = nil;
    }
}

- (IBAction)SwitchTool:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    int selected = [seg selectedSegmentIndex];
    
    self.drawView.tool = selected;
    
    if (selected == 0)
        self.sizeButton.title = [NSString stringWithFormat:@"Taille: %d", self.drawView.sizeBrush];
    else if (selected == 1)
        self.sizeButton.title = [NSString stringWithFormat:@"Taille: %d", self.drawView.sizeLine];
    else
        self.sizeButton.title = [NSString stringWithFormat:@"Taille: %d", self.drawView.sizeRectangle];
}

#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.brushSizesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.brushSizesArray objectAtIndex:row];
}

#pragma mark - ColorPicked Controller

- (void)colorPickedWithR:(int)rColor withG:(int)gColor withB:(int)bColor
{
    NSLog(@"%d %d %d", rColor, gColor, bColor);
    self.drawView.r = rColor;
    self.drawView.g = gColor;
    self.drawView.b = bColor;
}

@end
