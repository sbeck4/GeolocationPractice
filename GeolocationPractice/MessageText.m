//
//  MessageText.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/9/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "MessageText.h"

@implementation MessageText

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"MessageText";
}

@dynamic sentBy;
@dynamic contentOfMessage;
@dynamic messageId;

@end
