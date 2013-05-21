//
//  AddSchemaVC.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 12/05/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVProgressHUD.h"
#import "DownloadManager.h"
#import "JSONKit.h"
#import "User.h"
#import "ShouldReloadDataProtocol.h"

@interface AddSchemaVC : UIViewController <UITableViewDataSource, UITableViewDelegate, DataTransferProtocolDelegate>

@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *selectedIds;

@property (weak, nonatomic) IBOutlet UITextField *schemaName;
@property (weak, nonatomic) IBOutlet UITableView *usersSelectedTableView;

@property (nonatomic, strong) id<ShouldReloadDataProtocol> del;

- (IBAction)createSchema:(id)sender;
- (IBAction)backAction:(id)sender;

@end
