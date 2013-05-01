//
//  SchemaListVC.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 27/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "SchemaListVC.h"

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DownloadManager *manager = [DownloadManager downloadManagerSingleton];
    
    [manager addDownloadWithStringUrl:[[NSString alloc] initWithFormat:@"http://localhost/Enterprise/Schemas/?token=%@", [User getCurrentUser].token] identifier:nil delegate:self];
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Schema *schema = [schemas objectAtIndex:coverflow.currentCoverIndex];
    DrawingVC *destinationController = (DrawingVC *)[segue destinationViewController];
    
    destinationController.schema = schema;
}

@end
