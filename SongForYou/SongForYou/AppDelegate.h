//
//  AppDelegate.h
//  SongForYou
//
//  Created by  on 12/6/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    Facebook *facebook;
    NSString *FacebookID;
    NSString *FacebookName;
    NSString *DeviceToken;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Facebook *facebook;
@property (nonatomic, strong) NSString *FacebookID;
@property (nonatomic, strong) NSString *FacebookName;
@property (nonatomic, strong) NSString *DeviceToken;

@end
