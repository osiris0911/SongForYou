//
//  CommentsViewController.h
//  SongForYou
//
//  Created by  on 12/7/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagScrollView.h"
#import "TagAdder.h"
#import "Tag.h"

@interface CommentsViewController : UIViewController{
    
    IBOutlet UITextField *commentsTextField;
    
    IBOutlet UIImageView *friendImageView;
    IBOutlet UIImageView *albumImageView;
    IBOutlet UILabel *friendLabel;
    IBOutlet UILabel *songLabel;
    IBOutlet UILabel *tagLabel;
    
    IBOutlet TagScrollView *tagList;
    TagAdder *tagAdder;
    UITextField *addTextField;
    
}

@property (nonatomic, strong) UIImage *currFBImage;
@property (nonatomic, strong) NSString *currFBId;
@property (nonatomic, strong) NSString *currFBName;
@property (nonatomic, strong) UIImage *currSongImage;
@property (nonatomic, strong) NSString *currSongId;
@property (nonatomic, strong) NSString *currSongName;

@property (nonatomic, strong) IBOutlet UITextField *commentsTextField;
@property (nonatomic, strong) IBOutlet TagScrollView *tagList;
@property (nonatomic, assign) UITextField *activeTextField;

@end
