//
//  HomeVC.h
//  SmartBlocks
//
//  Created by Cédric Eugeni on 23/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadManager.h"

@interface HomeVC : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, DataTransferProtocolDelegate>

@property (weak, nonatomic) IBOutlet UITextField    *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField    *passwordTextField;


- (IBAction)ConnectionAction:(id)sender;

@end
