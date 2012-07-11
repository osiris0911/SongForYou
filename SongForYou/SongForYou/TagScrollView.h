//
//  TagScrollView.h
//  SongForYou
//
//  Created by  on 12/7/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagButton.h"

@interface TagScrollView : UIScrollView{
    NSMutableArray *tagButtons;
}



- (void) addTagButtons: (TagButton*) tagButton;
- (void) removeTagButtons;

@end
