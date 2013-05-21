//
//  AddSchemaVC.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 12/05/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "AddSchemaVC.h"

#import "DataTransferOperation.h"


@interface AddSchemaVC ()

@end

@implementation AddSchemaVC

#pragma mark - LifeCycle

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
    
    self.selectedIds = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Chargement en cours" maskType:SVProgressHUDMaskTypeBlack];
    
    DownloadManager *manager = [DownloadManager downloadManagerSingleton];
    [manager addDownloadWithStringUrl:@"http://localhost/Users/" identifier:nil delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *dico = [self.users objectAtIndex:indexPath.row];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [dico objectForKey:@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dico = [self.users objectAtIndex:indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.selectedIds addObject:[dico objectForKey:@"id"]];
        // Reflect selection in data model
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.selectedIds removeObject:[dico objectForKey:@"id"]];
        // Reflect deselection in data model
    }
}

#pragma mark - IBActions

- (IBAction)createSchema:(id)sender
{
    if (self.schemaName == nil || self.schemaName.text == nil || [self.schemaName.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"Veuillez entre un nom de schéma"];
        return;
    }
    
    DownloadManager *manager = [DownloadManager downloadManagerSingleton];
    NSMutableDictionary *dicoToSend = [[NSMutableDictionary alloc] init];
    NSMutableArray *participants = [[NSMutableArray alloc] init];
    
    for (NSNumber *num in self.selectedIds)
    {
        NSMutableDictionary *dico = [[NSMutableDictionary alloc] init];
        
        [dico setValue:num forKey:@"id"];
        
        [participants addObject:dico];
    }
    
    [dicoToSend setValue:self.schemaName.text forKey:@"name"];
    [dicoToSend setValue:participants forKey:@"participants"];
    
    NSData *message = [dicoToSend JSONData];
    
    [manager addUploadWithStringUrl:[[NSString alloc] initWithFormat:@"http://localhost/Meetings/Schemas/?token=%@", [[User getCurrentUser] token]] identifier:@"create" delegate:self data:message];
    
    [self.del controllerShouldReloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DataTransfer Protocol

- (void)didFinishWithSender:(id)download WithData:(NSData *)data
{
    DataTransferOperation *operation = (DataTransferOperation *)download;
    
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if (operation.identifier == nil)
    {
        NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *array = [message objectFromJSONString];
    
        self.users = [NSMutableArray arrayWithArray:array];
    
        [self.usersSelectedTableView reloadData];
    
        [SVProgressHUD dismiss];
    }
}

@end
