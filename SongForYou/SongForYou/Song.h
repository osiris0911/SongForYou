//
//  Song.h
//  SongForYou
//
//  Created by  on 12/7/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject <NSCoding>{
    
    NSString *SongID;
    NSString *Title;
    NSString *Album;
    NSString *Singer;
    NSString *AlbumImage;
    NSString *AlbumImageUrl;
    NSString *SongUrl;
    
}

@property (nonatomic, strong) NSString *SongID;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Album;
@property (nonatomic, strong) NSString *Singer;
@property (nonatomic, strong) NSString *AlbumImage;
@property (nonatomic, strong) NSString *AlbumImageUrl;
@property (nonatomic, strong) NSString *SongUrl;


@end
