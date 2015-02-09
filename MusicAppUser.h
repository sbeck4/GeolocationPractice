//
//  MusicAppUser.h
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/8/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import <Parse/Parse.h>

@interface MusicAppUser : PFUser<PFSubclassing>

@property float latitude;
@property float longitude;

@end
