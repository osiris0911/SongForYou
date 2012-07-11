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

@interface SongsViewController : UIViewController 
<UITableViewDataSource, UITableViewDelegate>{
    
    BOOL loaded;
    
    IBOutlet UITableView *SongsTableView;
    IBOutlet UIImageView *friendImageView;
    IBOutlet UILabel*friendLabel;
    
    NSMutableArray *Songs;
    
    UIImage *SongImage;
    NSString *SongId;
    NSString *SongName;
    
}

@property (nonatomic, retain) IBOutlet UITableView *SongsTableView;
@property (nonatomic, retain) NSMutableArray *Songs;
@property (nonatomic, strong) UIImage *currFBImage;
@property (nonatomic, strong) NSString *currFBId;
@property (nonatomic, strong) NSString *currFBName;


@end
