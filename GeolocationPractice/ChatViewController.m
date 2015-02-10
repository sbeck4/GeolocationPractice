//
//  ChatViewController.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/9/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "ChatViewController.h"
#import "SingleChatViewController.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    MusicAppUser *thisUser = [self.closestUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = thisUser.username;

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.closestUsers.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"singleChat"])
    {
        SingleChatViewController *singleVC = segue.destinationViewController;
        singleVC.currentUser = self.currentUser;
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        singleVC.tappedUser = self.closestUsers[path.row];
    }
}

@end
