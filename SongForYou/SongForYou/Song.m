//
//  Song.m
//  SongForYou
//
//  Created by  on 12/7/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Song.h"

@implementation Song

@synthesize SongID, Title, Album, Singer, AlbumImage, AlbumImageUrl, SongUrl;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.SongID forKey:@"SongID"];
    [encoder encodeObject:self.Title forKey:@"Title"];
    [encoder encodeObject:self.Album forKey:@"Album"];
    [encoder encodeObject:self.Singer forKey:@"Singer"];
    [encoder encodeObject:self.AlbumImage forKey:@"AlbumImage"];
    [encoder encodeObject:self.AlbumImageUrl forKey:@"AlbumImageUrl"];
    [encoder encodeObject:self.SongUrl forKey:@"SongUrl"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.SongID = [decoder decodeObjectForKey:@"SongID"];
        self.Title = [decoder decodeObjectForKey:@"Title"];
        self.Album = [decoder decodeObjectForKey:@"Album"];
        self.Singer = [decoder decodeObjectForKey:@"Singer"];
        self.AlbumImage = [decoder decodeObjectForKey:@"AlbumImage"];
        self.AlbumImageUrl = [decoder decodeObjectForKey:@"AlbumImageUrl"];
        self.SongUrl = [decoder decodeObjectForKey:@"SongUrl"];
    }
    return self;
}

@end
