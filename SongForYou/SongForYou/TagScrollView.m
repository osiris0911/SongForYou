//
//  TagScrollView.m
//  SongForYou
//
//  Created by  on 12/7/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagScrollView.h"

@implementation TagScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) addTagButtons: (TagButton*) tagButton{
    
    NSLog(@"addTagButtons");
    
    if(tagButtons == nil){
        tagButtons = [[NSMutableArray alloc] init ];
    }
    
    int index = [tagButtons count];
    int newX = 85*index+5;
    [tagButton setFrame:CGRectMake(newX, 5, tagButton.frame.size.width, tagButton.frame.size.height)];
    [self addSubview: tagButton];
    
    [tagButtons addObject:tagButton];
    
    int plength = newX + 85;
    [self setContentSize:CGSizeMake(plength<320?320:plength, 70)];
    
}

- (void) removeTagButtons {
    for(TagButton *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    [tagButtons removeAllObjects];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
