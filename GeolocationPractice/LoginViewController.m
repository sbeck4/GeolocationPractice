//
//  LoginViewController.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/8/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "MusicAppUser.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MusicAppUser logOut];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];

}

- (IBAction)loginButtonTapped:(id)sender
{
    NSString *username = [self.usernameField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *password = [self.passwordField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username and password!"
                                                           delegate:Nil cancelButtonTitle:@"Okey"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [MusicAppUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                    message:[error.userInfo objectForKey:@"error"]
                                                                   delegate:Nil cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else
            {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }];
    }
    
}


@end
