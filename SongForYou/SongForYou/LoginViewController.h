//
//  LoginViewController.h
//  TakeDishes
//
//  Created by  on 12/5/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "FBConnect.h"

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;

@interface LoginViewController : UIViewController <
FBRequestDelegate,
FBSessionDelegate, 
FBDialogDelegate>{
    
    int currentAPICall;
    
    Facebook *facebook;
    NSArray *permissions;
    
    IBOutlet UIButton *fbButton;
    NSString *myFacebookID;
    NSString *myFacebookName;
    
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSArray *permissions;

@property (nonatomic, retain) IBOutlet UIButton *fbButton;

@property (nonatomic, strong) NSString* myFacebookID;
@property (nonatomic, strong) NSString* myFacebookName;

-(IBAction)loginFB:(id)sender;
@end
