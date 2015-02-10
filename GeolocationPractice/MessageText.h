//
//  MessageText.h
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/9/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import <Parse/Parse.h>

@interface MessageText : PFObject
+ (NSString *)parseClassName;

@property NSString *sentBy;
@property NSString *contentOfMessage;
@property NSString *messageId;

@end
