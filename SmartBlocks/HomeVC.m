//
//  HomeVC.m
//  SmartBlocks
//
//  Created by Cédric Eugeni on 23/04/13.
//  Copyright (c) 2013 Cédric Eugeni. All rights reserved.
//

#import "HomeVC.h"
#import "Extension.h"
#import "JSONKit.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "SchemaListVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)ConnectionAction:(id)sender
{
    if (self.usernameTextField == nil || self.usernameTextField.text == nil || [self.usernameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez saisir un nom d'utilisateur" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.passwordTextField == nil || self.passwordTextField.text == nil || [self.passwordTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez saisir un mot de passe" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Connexion en cours" maskType:SVProgressHUDMaskTypeBlack];
    
    DownloadManager *manager = [DownloadManager downloadManagerSingleton];
    [manager addDownloadWithStringUrl:[[NSString alloc] initWithFormat:@"http://localhost/Users/Connect/%@/%@", self.usernameTextField.text, [self.passwordTextField.text sha1]] identifier:nil delegate:self];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (![self.usernameTextField isFirstResponder] && ![self.passwordTextField isFirstResponder])
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordTextField)
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField)
        [self.passwordTextField becomeFirstResponder];
    else
    {
        [self.passwordTextField resignFirstResponder];
        [self performSelectorOnMainThread:@selector(ConnectionAction:) withObject:nil waitUntilDone:NO];
    }
    
    return YES;
}

#pragma mark - Data Transfer Protocol

- (void)didFinishWithSender:(id)download WithData:(NSData *)data
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dico = [jsonString objectFromJSONString];
    NSArray *array = [dico allKeys];
    
    
    if ([array containsObject:@"error"] || ![array containsObject:@"token"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Une erreur est survenue" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        User *user = [User getCurrentUser];
        
        user.session_id = [dico objectForKey:@"session_id"];
        user.token = [dico objectForKey:@"token"];
        
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self performSegueWithIdentifier:@"connexionSegue" sender:self];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SchemaListVC *destinationController = (SchemaListVC *)[segue destinationViewController];
    
    destinationController.shouldReload = YES;
}

@end
