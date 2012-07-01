//
//  ViewController.h
//  HelloFB
//
//  Created by Janet Huang on 11/12/5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Facebook.h"
#import "FBConnect.h"
#import "ImageDownloader.h"
//#import "SpotsQuery.h"

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

@interface FBFriendsViewController : UIViewController <
FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate,
UITableViewDataSource,
UITableViewDelegate,
ImageDownloaderDelegate>{
    
    int currentAPICall;
    BOOL loaded;
    
    NSArray *permissions;
    
    UITableView *apiTableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSMutableArray *savedAPIResult;
    UILabel *messageLabel;
    UIView *messageView;
    
    NSMutableArray *myData;
    NSMutableArray *myData2;
    NSString *myAction;
    
    NSMutableDictionary *selectedFBID;
    NSMutableDictionary *imageDictionary;
    
    NSMutableArray *usedFriend;
    
    NSMutableDictionary *imageDownloadsInProgress;
    
    IBOutlet UITableView *FriendsTableView;
    IBOutlet UITextField *tripNameTextField;
    
    NSString* myFacebookID;
    
}

@property (retain, nonatomic) IBOutlet UIButton *HelloBt;
@property (nonatomic, retain) NSArray *permissions;

@property (nonatomic, retain) UITableView *apiTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSMutableArray *savedAPIResult;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIView *messageView;

@property (nonatomic, retain) NSMutableArray *myData;
@property (nonatomic, retain) NSMutableArray *myData2;
@property (nonatomic, retain) NSString *myAction;

@property (nonatomic, retain) NSMutableDictionary *selectedFBID;
@property (nonatomic, retain) NSMutableDictionary *imageDictionary;

@property (nonatomic, retain) IBOutlet UITableView *FriendsTableView;
@property (nonatomic, strong) IBOutlet UITextField *tripNameTextField;
@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSString *tripID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *friendID;
@property (nonatomic, strong) NSMutableArray *usedFriend;

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic, strong) NSString* myFacebookID;

-(IBAction)sendFBID:(id)sender;

- (void)fbImageDidLoad:(NSIndexPath *)indexPath;

@end
