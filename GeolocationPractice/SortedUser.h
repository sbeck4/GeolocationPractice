//
//  SortedUser.h
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/7/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicAppUser.h"

@interface SortedUser : NSObject

@property MusicAppUser *user;
@property float distanceFromCurrentUser;

@end
