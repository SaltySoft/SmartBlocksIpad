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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reconnect];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
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
    self.webSocket = nil;
}

#pragma mark - SRWebSocket Delegate

- (void)reconnect;
{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    //{"identification":"4f070ffa0a98fb42869919f2ba15430e"}
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:10001"]] protocols:[[NSArray alloc] initWithObjects:@"muffin-protocol", nil]];
    self.webSocket.delegate = self;
    
    NSLog(@"Opening Connection...");
    [self.webSocket open];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
    User *currentUser = [User getCurrentUser];
    NSString *session = currentUser.session_id;
    
    NSDictionary *dico = [[NSDictionary alloc] initWithObjectsAndKeys:session, @"identification", nil];
    NSString *handshake = [dico JSONString];
    
    NSLog(@"%@", handshake);
    
    //NSString *userid = @"e7680297f02e04d85213a17334873fb9";
    //NSString *handshake = [[NSString alloc] initWithFormat:@"{\"identification\":\"%@\"}", userid];
    
    [self.webSocket send:handshake];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSString *strMsg = [message stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    strMsg = [strMsg substringWithRange:NSMakeRange(1, [strMsg length] - 2)];
    
    id object = [strMsg objectFromJSONString];
    NSDictionary *dico = (NSDictionary *)object;
    
    dico = dico;
    
    NSString *app = [dico objectForKey:@"app"];
    NSString *action = [dico objectForKey:@"action"];
    
    if ([app isEqualToString:@"schemas"])
    {
        if ([action isEqualToString:@"mousedown"] || [action isEqualToString:@"mouseup"] || [action isEqualToString:@"mousemove"])
        {
            NSNumber *schema_id = [dico objectForKey:@"schema_id"];
            
            if ([schema_id intValue] == self.schema.identitier)
            {
                NSNumber *tool = [dico objectForKey:@"tool_id"];
                NSNumber *x = [dico objectForKey:@"x"];
                NSNumber *y = [dico objectForKey:@"y"];
                NSNumber *size = [dico objectForKey:@"size"];
                NSString *color = [dico objectForKey:@"color"];
                NSString *user = [dico objectForKey:@"user"];
                NSArray *colorArray = [color componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"rgb(,)"]];
                int r = [[colorArray objectAtIndex:4] intValue];
                int g = [[colorArray objectAtIndex:5] intValue];
                int b = [[colorArray objectAtIndex:6] intValue];
                
                if ([tool intValue] == 0)
                {
                    if ([action isEqualToString:@"mousedown"])
                        [self.drawView beginPointWithCoordX:[x intValue] coordY:[y intValue] andUser:user];
                    else
                    {
                        int sizeInt = [size intValue];
                        [self.drawView drawLineWithSize:sizeInt coordX:[x intValue] coordY:[y intValue] colorR:r colorG:g colorB:b andUser:user];
                    }
                    //draw point
                }
                else if ([tool intValue] == 1)
                {
                    if ([action isEqualToString:@"mousedown"])
                        [self.drawView beginPointWithCoordX:[x intValue] coordY:[y intValue] andUser:user];
                    else if ([action isEqualToString:@"mouseup"])
                        [self.drawView drawLineWithSize:[size intValue] coordX:[x intValue] coordY:[y intValue] colorR:r colorG:g colorB:b andUser:user];
                    //if mousedown save Point
                    //if mousemouve, nothing
                    //if mouseup draw line
                    //draw line
                }
                else if ([tool intValue] == 2)
                {
                    if ([action isEqualToString:@"mousedown"])
                        [self.drawView beginPointWithCoordX:[x intValue] coordY:[y intValue] andUser:user];
                    else if ([action isEqualToString:@"mouseup"])
                        [self.drawView drawRectangleWithSize:[size intValue] coordX:[x intValue] coordY:[y intValue] colorR:r colorG:g colorB:b andUser:user];
                    //if mousedown save Point
                    //if mousemouve, nothing
                    //if mouseup draw rect
                    //draw rect
                }
            }
        }
    }

//        color = [color stringByReplacingOccurrencesOfString:@"#" withString:@""];
//        NSScanner *scanner = [NSScanner scannerWithString:color];
//        unsigned hex;
//        [scanner scanHexInt:&hex];
//        int r = (hex >> 16) & 0xFF;
//        int g = (hex >> 8) & 0xFF;
//        int b = (hex) & 0xFF;
}

#pragma mark - Drawing Protocol Methods

- (void)drawingBeganWithTool:(int)tool andSize:(int)size andColorR:(float)r andColorG:(float)g andColorB:(float)b andCoordX:(int)x andCoordY:(int)y
{
    NSMutableDictionary *dicoToSend = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setValue:@"mousedown" forKey:@"action"];
    [data setValue:@"schemas" forKey:@"app"];
    [data setValue:[NSNumber numberWithInteger:self.schema.identitier] forKey:@"schema_id"];
    [data setValue:[NSNumber numberWithInt:size] forKey:@"size"];
    [data setValue:[NSNumber numberWithInt:tool] forKey:@"tool_id"];
    [data setValue:[[User getCurrentUser] session_id] forKey:@"user"];
    [data setValue:[NSNumber numberWithInt:x] forKey:@"x"];
    [data setValue:[NSNumber numberWithInt:y] forKey:@"y"];
    [data setValue:[[NSString alloc] initWithFormat:@"rgb(%d,%d,%d)", (int)r, (int)g, (int)b] forKey:@"color"];
    
    [dicoToSend setValue:[NSNumber numberWithBool:NO] forKey:@"broadcast"];
    [dicoToSend setValue:self.schema.participantsSession forKey:@"session_ids"];
    [dicoToSend setValue:data forKey:@"data"];
    
    NSString *jsonString = [dicoToSend JSONString];
    
    [self.webSocket send:jsonString];
}

- (void)drawingContinueWithTool:(int)tool andSize:(int)size andColorR:(float)r andColorG:(float)g andColorB:(float)b andCoordX:(int)x andCoordY:(int)y
{
    NSMutableDictionary *dicoToSend = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setValue:@"mousemove" forKey:@"action"];
    [data setValue:@"schemas" forKey:@"app"];
    [data setValue:[NSNumber numberWithInteger:self.schema.identitier] forKey:@"schema_id"];
    [data setValue:[NSNumber numberWithInt:size] forKey:@"size"];
    [data setValue:[NSNumber numberWithInt:tool] forKey:@"tool_id"];
    [data setValue:[[User getCurrentUser] session_id] forKey:@"user"];
    [data setValue:[NSNumber numberWithInt:x] forKey:@"x"];
    [data setValue:[NSNumber numberWithInt:y] forKey:@"y"];
    [data setValue:[[NSString alloc] initWithFormat:@"rgb(%d,%d,%d)", (int)r, (int)g, (int)b] forKey:@"color"];
    
    [dicoToSend setValue:[NSNumber numberWithBool:NO] forKey:@"broadcast"];
    [dicoToSend setValue:self.schema.participantsSession forKey:@"session_ids"];
    [dicoToSend setValue:data forKey:@"data"];
    
    NSString *jsonString = [dicoToSend JSONString];
    
    [self.webSocket send:jsonString];
}

- (void)drawingEndedWithTool:(int)tool andSize:(int)size andColorR:(float)r andColorG:(float)g andColorB:(float)b andCoordX:(int)x andCoordY:(int)y
{
    NSLog(@"test");
    NSMutableDictionary *dicoToSend = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setValue:@"mouseup" forKey:@"action"];
    [data setValue:@"schemas" forKey:@"app"];
    [data setValue:[NSNumber numberWithInteger:self.schema.identitier] forKey:@"schema_id"];
    [data setValue:[NSNumber numberWithInt:size] forKey:@"size"];
    [data setValue:[NSNumber numberWithInt:tool] forKey:@"tool_id"];
    [data setValue:[[User getCurrentUser] session_id] forKey:@"user"];
    [data setValue:[NSNumber numberWithInt:x] forKey:@"x"];
    [data setValue:[NSNumber numberWithInt:y] forKey:@"y"];
    [data setValue:[[NSString alloc] initWithFormat:@"rgb(%d,%d,%d)", (int)r, (int)g, (int)b] forKey:@"color"];
    
    [dicoToSend setValue:[NSNumber numberWithBool:NO] forKey:@"broadcast"];
    [dicoToSend setValue:self.schema.participantsSession forKey:@"session_ids"];
    [dicoToSend setValue:data forKey:@"data"];
    
    NSString *jsonString = [dicoToSend JSONString];
    
    [self.webSocket send:jsonString];
    
    NSData *dataIMG = UIImagePNGRepresentation(self.drawView.drawImage.image);
    NSString *stringImgTmp = [dataIMG base64Encoding];
    
    NSString *imgString = [[NSString alloc] initWithFormat:@"data:image/png;base64,%@", stringImgTmp];
    NSMutableDictionary *dico = [[NSMutableDictionary alloc] init];
    [dico setValue:imgString forKey:@"data"];
    [dico setValue:self.schema.name forKey:@"name"];
    [dico setValue:@"" forKey:@"texts"];
    DownloadManager *downloadManager = [DownloadManager downloadManagerSingleton];
    [downloadManager addUploadWithStringUrl:[[NSString alloc] initWithFormat:@"http://localhost/Meetings/Schemas/update/%d?token=%@", self.schema.identitier, [[User getCurrentUser] token]] identifier:nil delegate:self dictionary:dico];
    NSLog(@"=====================");
    NSLog(@"saved, %@", self.schema.name);
    NSLog(@"=====================");
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

#pragma mark - ColorPicker Controller

- (void)colorPickedWithR:(int)rColor withG:(int)gColor withB:(int)bColor
{
    self.drawView.r = rColor;
    self.drawView.g = gColor;
    self.drawView.b = bColor;
}

#pragma mark - Data Transfer Protocol

- (void)didFinishWithSender:(id)download WithData:(NSData *)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
