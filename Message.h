//
//  Message.h
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/9/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import <Parse/Parse.h>

@interface Message : PFObject<PFSubclassing>
+ (NSString *)parseClassName;

@property NSString *messagedToUserId;
@property NSString *messagedFromUserId;
@property NSString *eventId;

@end
