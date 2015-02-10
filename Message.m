//
//  Message.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/9/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "Message.h"
#import <Parse/PFObject+Subclass.h>

@implementation Message

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Message";
}

@dynamic messagedFromUserId;
@dynamic messagedToUserId;
@dynamic eventId;

@end
