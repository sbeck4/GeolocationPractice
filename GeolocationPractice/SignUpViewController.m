//
//  SignUpViewController.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/8/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "SignUpViewController.h"
#import "MusicAppUser.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController.navigationBar setHidden:NO];
}


- (IBAction)signUpButtonTapped:(id)sender
{
    NSString *username = [self.usernameField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *password = [self.passwordField.text
                          stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *email = [self.emailField.text
                       stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    //float stepsUsedToday = 0;

    if ([username length] == 0 || [password length] == 0 || [email length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"Make sure you enter a username, password and an email!"
                                                           delegate:Nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        MusicAppUser *newUser = (MusicAppUser *)[MusicAppUser object];
        [newUser setUsername:username];
        [newUser setPassword:password];
        [newUser setEmail:email];

        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                                     message:[error.userInfo objectForKey:@"error"]
                                                                    delegate:Nil cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
             else
             {
                 self.usernameField.text = nil;
                 self.emailField.text = nil;
                 self.passwordField.text = nil;
                 [self.presentingViewController.presentingViewController  dismissViewControllerAnimated:YES completion:nil];
             }
             
         }];
    }
    
}

- (IBAction)backButtonTapped:(id)sender
{
      [self dismissViewControllerAnimated:NO completion:nil];
}


@end
