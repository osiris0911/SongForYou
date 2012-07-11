//
//  TagAdder.m
//  SongForYou
//
//  Created by  on 12/7/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagAdder.h"

@implementation TagAdder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"TagAdder initWithFrame");
        self.backgroundColor = [UIColor grayColor];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 200, 44)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = @"tag...";
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
        textField.delegate = (id)self;
        
        textField.text = @"New Tag";
        
        UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
        [addBtn setFrame:CGRectMake(220, 15, 90, 44)];
        [addBtn setTitle:@"Add" forState:UIControlStateNormal];
        
        [self addSubview:textField];
        [self addSubview:addBtn];
        
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
