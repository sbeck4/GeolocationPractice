//
//  SingleChatViewController.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/9/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "SingleChatViewController.h"
#import "Message.h"
#import "MessageText.h"

@interface SingleChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSString *messageTemp1Id;
@property NSString *messageTemp2Id;
@property NSString *messageId;
@property NSMutableArray *messager1;
@property NSMutableArray *messager2;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation SingleChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.messager1 = [[NSMutableArray alloc]init];

    PFQuery *query = [Message query];
    [query whereKey:@"messagedFromUserId" equalTo:self.currentUser.objectId];
    [query whereKey:@"messagedToUserId" equalTo:self.tappedUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         Message *message1 = objects.firstObject;
         self.messageTemp1Id = message1.objectId;
         PFQuery *query2 = [Message query];
         [query2 whereKey:@"messagedToUserId" equalTo:self.currentUser.objectId];
         [query2 whereKey:@"messagedFromUserId" equalTo:self.tappedUser.objectId];
         [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
          {
              Message *message2 = objects.firstObject;
              self.messageTemp2Id = message2.objectId;

              if (self.messageTemp1Id == nil && self.messageTemp2Id == nil)
              {
                  Message *message = [Message object];
                  message.messagedFromUserId = self.currentUser.objectId;
                  message.messagedToUserId = self.tappedUser.objectId;
                  //add event data
                  [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                   {
                       self.messageId = message.objectId;
                   }];
              }
              else if (self.messageTemp1Id != nil)
              {
                  self.messageId = self.messageTemp1Id;
                  [self queryForAllMessages];
                  
              }
              else
              {
                  self.messageId = self.messageTemp2Id;
                  [self queryForAllMessages];
              }

          }];
     }];
}

- (void)queryForAllMessages
{
    PFQuery *query = [MessageText query];
    [query whereKey:@"messageId" equalTo:self.messageId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [self.messager1 removeAllObjects];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:false];

        self.messager1 = [[objects sortedArrayUsingDescriptors:@[sortDescriptor]]mutableCopy];
        [self.tableView reloadData];
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (self.messager1.count != 0)
    {
        MessageText *thisMessage = self.messager1[indexPath.row];

        if ([thisMessage.sentBy isEqualToString:self.currentUser.objectId])
        {
            cell.textLabel.text = thisMessage.contentOfMessage;
        }
        else
        {
            cell.detailTextLabel.text = thisMessage.contentOfMessage;
        }
    }

    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messager1.count;
    //return  6;
}

- (IBAction)sendButtonTapped:(id)sender
{
    MessageText *messageText = [MessageText object];
    messageText.contentOfMessage = self.textField.text;
    messageText.sentBy = self.currentUser.objectId;
    messageText.messageId = self.messageId;
    //add event data
    [messageText saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         self.textField.text = @"";
         [self.tableView reloadData];
         [self queryForAllMessages];
     }];
}

@end
