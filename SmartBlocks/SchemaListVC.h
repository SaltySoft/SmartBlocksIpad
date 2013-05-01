//
//  SchemaListVC.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 27/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary.h>

#import "DownloadManager.h"
#import "JSONKit.h"
#import "Schema.h"
#import "SchemaText.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "DrawingVC.h"

@interface SchemaListVC : UIViewController <DataTransferProtocolDelegate, TKCoverflowViewDataSource, TKCoverflowViewDelegate>

@property (nonatomic, strong) NSMutableArray    *schemas;
@property (nonatomic, strong) TKCoverflowView   *coverflow;

@property (nonatomic, strong) UILabel           *label;

@end
