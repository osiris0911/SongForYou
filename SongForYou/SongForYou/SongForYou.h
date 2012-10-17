//
//  SongForYou.h
//  SongForYou
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@interface SongForYou : NSObject <NSCoding>{
 
    Song *TheSong;
    NSString *Message;
    NSMutableArray *Tags;
    NSString *Sender;
    NSString *Receiver;
    
}

@property (nonatomic, strong) Song* TheSong;
@property (nonatomic, strong) NSString *Message;
@property (nonatomic, strong) NSMutableArray *Tags;
@property (nonatomic, strong) NSString *Sender;
@property (nonatomic, strong) NSString *Receiver;


@end
