//
//  SchemaListVC.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 27/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "SchemaListVC.h"

#import "DataTransferOperation.h"


@interface SchemaListVC ()

@end

@implementation SchemaListVC

@synthesize schemas;
@synthesize coverflow;
@synthesize label;

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
	rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(90 * M_PI / 180.));
	rect.origin = CGPointZero;
	
	self.view = [[UIView alloc] initWithFrame:rect];
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //CGRect coverFlowFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 44);
    
	self.coverflow = [[TKCoverflowView alloc] initWithFrame:self.view.bounds deleclerationRate:UIScrollViewDecelerationRateFast];
	self.coverflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.coverflow.coverflowDelegate = self;
	self.coverflow.coverflowDataSource = self;
	self.coverflow.tag = 0;
	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
		self.coverflow.coverSize = CGSizeMake(300, 300);
	}
	
	[self.view addSubview:self.coverflow];
    self.coverflow.backgroundColor = [UIColor colorWithRed:136.0/255.0 green:141.0/255.0 blue:169.0/255.0 alpha:1.0];
    
    
    UIView *center = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0, 0,1, 1000)];
	center.backgroundColor = [UIColor redColor];
	center.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(354, 600, 316, 47)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:24]];
    [self.view addSubview:label];
    
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 108, self.view.frame.size.width, 44)];
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove Schema" style:UIBarButtonItemStyleBordered target:self action:@selector(removeSchema:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Schema" style:UIBarButtonItemStyleBordered target:self action:@selector(addSchema:)];
    toolbar.items = [NSArray arrayWithObjects:removeButton, flexible, addButton, nil];
    [self.view addSubview:toolbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.shouldReload)
    {
        self.shouldReload = NO;
        
        DownloadManager *manager = [DownloadManager downloadManagerSingleton];
        
        [manager addDownloadWithStringUrl:[[NSString alloc] initWithFormat:@"http://localhost/Meetings/Schemas/?token=%@", [User getCurrentUser].token] identifier:nil delegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.schemas = nil;
    self.coverflow = nil;
    self.label = nil;
}

#pragma mark - IBActions

- (void)removeSchema:(id)sender
{
    NSLog(@"removed");
    Schema *selectedSchema = [self.schemas objectAtIndex:self.coverflow.currentCoverIndex];
    
    DownloadManager *downloadManager = [DownloadManager downloadManagerSingleton];
    [downloadManager addDownloadWithStringUrl:[[NSString alloc] initWithFormat:@"http://localhost/Meetings/Schemas/delete/%d", selectedSchema.identitier] identifier:@"delete" delegate:self];
    
    [self.schemas removeObjectAtIndex:self.coverflow.currentCoverIndex];
    [self.coverflow reloadData];
}

- (void)addSchema:(id)sender
{
    NSLog(@"add");
    
    [self performSegueWithIdentifier:@"goToAddSchemaViewSegue" sender:self];
}

#pragma mark - Tapku CoverFlow Delegate Datasource

- (NSInteger) numberOfCoversInCoverflowView:(TKCoverflowView *)coverflowView
{
	return [schemas count];
}

- (TKCoverflowCoverView *) coverflowView:(TKCoverflowView *)coverflowView coverForIndex:(NSInteger)index
{
	TKCoverflowCoverView *cover = [coverflowView dequeueReusableCoverView];
	
	if(cover == nil)
    {
		CGRect rect = CGRectMakeWithSize(0, 0, self.coverflow.coverSize);
		
		cover = [[TKCoverflowCoverView alloc] initWithFrame:rect reflection:NO]; // 224
	}
    
    UIImage *image = [[schemas objectAtIndex:index] image];
    
    UIGraphicsBeginImageContext(self.coverflow.coverSize);
    [image drawInRect:CGRectMake(0, 0, self.coverflow.coverSize.width, self.coverflow.coverSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    cover.image = newImage;
	
    return cover;
}

- (void)coverflowView:(TKCoverflowView *)coverflowView coverAtIndexWasTappedInFront:(NSInteger)index tapCount:(NSInteger)tapCount
{
    [self performSegueWithIdentifier:@"goToDrawingviewSegue" sender:self];
}

- (void)coverflowView:(TKCoverflowView *)coverflowView coverAtIndexWasBroughtToFront:(NSInteger)index
{
    Schema *schema = [schemas objectAtIndex:index];
    label.text = schema.name;
}

#pragma mark - Data Transfer Protocol Delegate

- (void)didFinishWithSender:(id)download WithData:(NSData *)data
{
    DataTransferOperation *operation = (DataTransferOperation*)download;
    
    if (operation.identifier == nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id object = [jsonString objectFromJSONString];
        
        if ([SVProgressHUD isVisible])
            [SVProgressHUD dismiss];
        
        if ([object isKindOfClass:[NSDictionary class]])
        {
            [SVProgressHUD showErrorWithStatus:@"Vous n'êtes pas connecté"];
            return;
        }
        
        NSArray *array = (NSArray*)object;
        
        schemas = [Schema getSchemasArrayWithArray:array];
        
        [self.coverflow reloadData];
        
        label.text = [[schemas objectAtIndex:0] name];
    }
}

#pragma mark - ShouldReloadData Protocol

- (void)controllerShouldReloadData
{
    self.shouldReload = YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[DrawingVC class]])
    {
        Schema *schema = [schemas objectAtIndex:coverflow.currentCoverIndex];
        DrawingVC *destinationController = (DrawingVC *)[segue destinationViewController];
        
        destinationController.schema = schema;
    }
    else
    {
        AddSchemaVC *destinationController = (AddSchemaVC *)[segue destinationViewController];
        
        destinationController.del = self;
    }
}

@end
