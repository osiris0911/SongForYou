//
//  SongsViewController.h
//  SongForYou
//
//  Created by  on 12/7/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "CommentsViewController.h"
#import "AudioPlayerAppDelegate.h"

@interface SongsViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate>{
    
    BOOL loaded;
    
    IBOutlet UITableView *SongsTableView;
    IBOutlet UIImageView *friendImageView;
    IBOutlet UILabel*friendLabel;
    
    NSMutableArray *Songs;
    NSMutableDictionary *SongsDictionary;
    
    UIImage *SongImage;
    NSString *SongId;
    NSString *SongName;
    Song* SongObject;
    
    NSMutableDictionary *AudioPlayerInProgress;
    
    AudioPlayerAppDelegate *audioPlayer;
    
}

@property (nonatomic, retain) IBOutlet UITableView *SongsTableView;
@property (nonatomic, retain) NSMutableArray *Songs;
@property (nonatomic, retain) NSMutableDictionary *SongsDictionary;
@property (nonatomic, strong) UIImage *currFBImage;
@property (nonatomic, strong) NSString *currFBId;
@property (nonatomic, strong) NSString *currFBName;

@property (nonatomic, strong) NSMutableDictionary *AudioPlayerInProgress;

@property (nonatomic, strong) AudioPlayerAppDelegate *audioPlayer;

@end
