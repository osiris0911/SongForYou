//
//  SongForYou.m
//  SongForYou
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongForYou.h"

@implementation SongForYou

@synthesize TheSong, Message, Tags, Sender, Receiver;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.TheSong forKey:@"TheSong"];
    [encoder encodeObject:self.Message forKey:@"Message"];
    [encoder encodeObject:self.Tags forKey:@"Tags"];
    [encoder encodeObject:self.Sender forKey:@"Sender"];
    [encoder encodeObject:self.Receiver forKey:@"Receiver"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.TheSong = [decoder decodeObjectForKey:@"TheSong"];
        self.Message = [decoder decodeObjectForKey:@"Message"];
        self.Tags = [decoder decodeObjectForKey:@"Tags"];
        self.Sender = [decoder decodeObjectForKey:@"Sender"];
        self.Receiver = [decoder decodeObjectForKey:@"Receiver"];
    }
    return self;
}

@end
