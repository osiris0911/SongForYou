//
//  TagButton.m
//  SongForYou
//
//  Created by  on 12/7/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagButton.h"

@implementation TagButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithName: (NSString*)text andID:(NSInteger) tagID
{
    self = [super initWithFrame:CGRectMake(0, 5, 80, 60)];
    if (self) {
        NSLog(@"TagButton:%@", text);
        
        UIImageView *image = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 80, 60)];

        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 45, 80, 15)];
        
        [image setImage: [UIImage imageNamed:@"Placeholder.png"]];
        [label setText: text];
        [label setTag:tagID];
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont fontWithName:@"American Typewriter" size:12]];
        
        [label setTextAlignment: UITextAlignmentCenter];
        
        [self addSubview: image];
        [self addSubview: label];
        
    }
    
    return self;
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
