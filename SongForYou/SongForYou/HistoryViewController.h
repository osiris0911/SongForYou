//
//  HistoryViewController.h
//  SongForYou
//
//  Created by  on 12/7/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "SongForYou.h"
#import "AudioPlayerAppDelegate.h"

@interface HistoryViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>{
    
    BOOL loaded;
    
    IBOutlet UITableView *HistoryTableView;
    
    NSMutableArray *SongForYous;
    
    NSMutableDictionary *AudioPlayerInProgress;
    
    AudioPlayerAppDelegate *audioPlayer;
}

@property (nonatomic, strong) IBOutlet UITableView *HistoryTableView;
@property (nonatomic, strong) NSMutableDictionary *AudioPlayerInProgress;

@property (nonatomic, strong) AudioPlayerAppDelegate *audioPlayer;

- (IBAction)cancelAllHistory:(id)sender;

@end
