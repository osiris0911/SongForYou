//
//  ViewController.m
//  HelloFB
//
//  Created by Janet Huang on 11/12/5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "FBFriendsViewController.h"
#import "AppDelegate.h"
#import "FBConnect.h"
#import "FBFriend.h"

@implementation FBFriendsViewController
@synthesize HelloBt;
@synthesize apiTableView;
@synthesize savedAPIResult;
@synthesize permissions;
@synthesize activityIndicator;
@synthesize messageLabel;
@synthesize messageView;
@synthesize myData;
@synthesize myData2;
@synthesize myAction;
@synthesize selectedFBID;
@synthesize FriendsTableView;
@synthesize imageDictionary;
@synthesize tripName, tripID, userID, friendID, tripNameTextField;
@synthesize usedFriend;
@synthesize imageDownloadsInProgress;
@synthesize myFacebookID;


static NSString* facebookAppId = @"146412965489498";



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)sayHello:(id)sender {
    //[facebook dialog:@"feed" andDelegate:self];
}


// Method that gets called when the logout button is pressed
- (void) logoutButtonClicked {
    NSLog(@"hi");
    //[facebook logout:self];
}

//FB login
- (void)fbDidLogin
{
    NSLog(@"fbDidLogin");
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[delegate facebook] accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[delegate facebook] expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSLog(@"accessToken: %@", [[delegate facebook] accessToken]);
    NSLog(@"expirationDate: %@", [[delegate facebook] expirationDate]);
    
    // get my FB ID
    [self apiGraphMe];
}

//FB logout
- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled{

}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{

}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated{
    
}

/*
 * This method shows the activity indicator and
 * deactivates the table to avoid user input.
 */
- (void) showActivityIndicator
{
    NSLog(@"showActivityIndicator");
    if (![activityIndicator isAnimating]) {
        //apiTableView.userInteractionEnabled = NO;
        [activityIndicator startAnimating];   
    }
}

/*
 * This method hides the activity indicator
 * and enables user interaction once more.
 */
- (void) hideActivityIndicator
{
    NSLog(@"hideActivityIndicator");
    if ([activityIndicator isAnimating]) {
        [activityIndicator stopAnimating];   
        //apiTableView.userInteractionEnabled = YES;
    }
}


#pragma mark - Facebook API Calls

/*
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */
- (void) apiGraphMe {
    NSLog(@"apiGraphMe");
    
    [self showActivityIndicator];
    currentAPICall = kAPIGraphMe;
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"me" andParams:params andDelegate:self];
}

/*
 * Graph API: Get the user's friends
 */
- (void) getUserFriends {
    NSLog(@"getUserFirends");
    currentAPICall = kAPIGraphUserFriends;
    [self apiGraphFriends];
}
/*
 * Helper method to get friends using the app which will in turn
 * send a request to current app users.
 */
- (void)getAppUsersFriendsUsing {
    currentAPICall = kAPIGetAppUsersFriendsUsing;
    [self apiRESTGetAppUsers];
}

/*
 * Graph API: Method to get the user's friends.
 */
- (void) apiGraphFriends {
    NSLog(@"apiGraphFriends");
    
    [self showActivityIndicator];
    // Do not set current API as this is commonly called by other methods
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate]; 
    [[delegate facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

/*
 * API: Legacy REST for getting the friends using the app. This is a helper method
 * being used to target app requests in follow-on examples.
 */
- (void)apiRESTGetAppUsers {
    [self showActivityIndicator];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"friends.getAppUsers", @"method",
                                   nil];
    [[delegate facebook] requestWithParams:params
                               andDelegate:self];
}



#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"request didLoad");
    
    [self hideActivityIndicator];

    switch (currentAPICall) {
        case kAPIGraphMe:
        {
            NSLog(@"kAPIGraphMe");
            NSString *nameID = [[NSString alloc] initWithFormat:@"%@ (%@)", [result objectForKey:@"name"], [result objectForKey:@"id"]];
            myFacebookID = [result objectForKey:@"id"];
            NSLog(@"myFacebookIDL%@",myFacebookID);
            
            NSMutableArray *userData = [[NSMutableArray alloc] initWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [result objectForKey:@"id"], @"id", 
                                         nameID, @"name", 
                                         [result objectForKey:@"picture"], @"details", 
                                         nil], nil];

            NSLog(@"userData:%@", userData);
            NSLog(@"nameID:%@", nameID);
            
            // get my Facebook friends
            //[self getUserFriends];
            [self getAppUsersFriendsUsing];
            
            break;
        }
        case kAPIGraphUserFriends:
        {
            if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
                result = [result objectAtIndex:0];
            }
            
            NSLog(@"users:%@", usedFriend);
            
            NSLog(@"kAPIGraphUserFriends");
            //NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:1];
            NSMutableArray *friends = [[NSMutableArray alloc] init];
            NSArray *resultData = [result objectForKey:@"data"];
            if ([resultData count] > 0) {
                for (NSUInteger i=0; i<[resultData count]; i++) {
                    NSString* fbID = [[resultData objectAtIndex:i] objectForKey:@"id"];
                    bool isFriend = NO;
                    for (NSUInteger j=0; j<[usedFriend count]; j++) {
                        if ( [[[usedFriend objectAtIndex:j] stringValue] isEqualToString:fbID] ) {
                            NSLog(@"addObject:%@", [resultData objectAtIndex:i]);
                            [friends addObject:[resultData objectAtIndex:i]];
                            isFriend = YES;
                        }
                    }
                    
                    if(!isFriend && [myData2 count] <= 10){
                        [myData2 addObject:[resultData objectAtIndex:i]];
                    }
                        
                }
                // Show the friend information in a new view controller
                NSLog(@"friends:%@", friends);
                

                myData = [[NSMutableArray alloc] initWithArray:friends copyItems:YES];
                [myData addObjectsFromArray:myData2];
                selectedFBID = [[NSMutableDictionary alloc] init];
                NSLog(@"myData:%@",myData);

                loaded = YES;
                [FriendsTableView reloadData];
                NSLog(@"YES");
                
                
                 
            } else {
                [self showMessage:@"You have no friends."];
            }
            [friends release];
            break;
            
        }
        case kAPIGetAppUsersFriendsUsing:
        {
            NSLog(@"kAPIGetAppUsersFriendsUsing");
            NSMutableArray *friendsWithApp = [[NSMutableArray alloc] initWithCapacity:1];
            // Many results
            if ([result isKindOfClass:[NSArray class]]) {
                NSLog(@"NSArray");
                [friendsWithApp addObjectsFromArray:result];
            } else if ([result isKindOfClass:[NSDecimalNumber class]]) {
                NSLog(@"NSDecimalNumber");
                [friendsWithApp addObject: [result stringValue]];
            }
            
            usedFriend = [[NSMutableArray alloc] initWithArray:friendsWithApp copyItems:YES];
            
            NSLog(@"usedFriend:%@", usedFriend);
            
            [friendsWithApp release];
            
            [self getUserFriends];
            
            break;
        }
        default:
            break;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    [self hideActivityIndicator];
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    [self showMessage:@"Oops, something went haywire."];
}


#pragma mark - Private Methods
/*
 * Helper method to return the picture endpoint for a given Facebook
 * object. Useful for displaying user, friend, or location pictures.
 */
- (UIImage *) imageForObject:(NSString *)objectID {
    
    NSLog(@"imageDictionary:%@",[imageDictionary valueForKey:objectID]);
    /*
    if( [imageDictionary valueForKey:objectID] == nil){
        // Get the image from url
        NSLog(@"Get the image from url");
        NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        NSLog(@"imageForObject:%@",url);
        
        [imageDictionary setObject:image forKey:objectID];
        
        [url release];
        return image;
    }
    else {
     
        // Get the image from Dictionary
        NSLog(@"Get the image from Dictionary");
        UIImage *image = [imageDictionary valueForKey:objectID];
        return image;
    }
    */
    // Get the image from Dictionary
    NSLog(@"Get the image from Dictionary");
    UIImage *image = [imageDictionary valueForKey:objectID];
    return image;
}

- (void)getImageForObject:(FBFriend*) fbfriend forIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"getImageForObject:%@",indexPath);
    
    /*
    // Get the image from url
    NSLog(@"Get the image from url");
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    NSLog(@"imageForObject:%@",url);
    
    [imageDictionary setObject:image forKey:objectID];
    
    [url release];
    
    [self setCellImage:image forIndexPath:indexPath];
    */
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) 
    {
        NSLog(@"imageDownloader == nil");
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.fbfriend = fbfriend;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
    
    NSLog(@"imageDownloadsInProgress:%@",imageDownloadsInProgress);
    
    
}

- (void)setCellImage:(UIImage*) image forIndexPath:(NSIndexPath*) indexPath{
    
    NSLog(@"setCellImage");
    UITableViewCell *cell = [FriendsTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = image;
    
}

- (void)fbImageDidLoad:(NSIndexPath *)indexPath{
    NSLog(@"fbImageDidLoad imageDownloadsInProgress:%@",imageDownloadsInProgress);
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil)
    {
        NSLog(@"imageDownloader != nil");
        UITableViewCell *cell = [FriendsTableView cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = imageDownloader.fbfriend.friendImage;
        
        // Save to Dictionary
        [imageDictionary setObject:imageDownloader.fbfriend.friendImage forKey:imageDownloader.fbfriend.friendID];
    }
}

/*
 * This method is used to display API confirmation and
 * error messages to the user.
 */
-(void)showMessage:(NSString *)message
{
    
    CGRect labelFrame = messageView.frame;
    labelFrame.origin.y = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    messageView.frame = labelFrame;
    messageLabel.text = message;
    messageView.hidden = NO;
    
    // Use animation to show the message from the bottom then
    // hide it.
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         CGRect labelFrame = messageView.frame;
                         labelFrame.origin.y -= labelFrame.size.height;
                         messageView.frame = labelFrame;
                     } 
                     completion:^(BOOL finished){
                         if (finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:3.0
                                                 options: UIViewAnimationCurveEaseOut
                                              animations:^{
                                                  CGRect labelFrame = messageView.frame;
                                                  labelFrame.origin.y += messageView.frame.size.height;
                                                  messageView.frame = labelFrame;
                                              } 
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      messageView.hidden = YES;
                                                      messageLabel.text = @"";  
                                                  }
                                              }];
                         }
                     }];
}

/*
 * This method hides the message, only needed if view closed
 * and animation still going on.
 */
-(void)hideMessage
{
    messageView.hidden = YES;
    messageLabel.text = @"";
}

- (void) loadView {
    NSLog(@"loadView");
	[super loadView];
        
}


#pragma mark - UITableView Datasource and Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    return 50.0;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    if(loaded){
        NSLog(@"numberOfRowsInSection = YES");
        return [myData count];
    }
    else {
        NSLog(@"numberOfRowsInSection = NO");
        return 0;
    }
    //return 25;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"My facebook friends";
    else
        return @"";
}
*/
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.tag = (NSInteger)[[myData objectAtIndex:indexPath.row] objectForKey:@"id"];
    cell.textLabel.text = [[myData objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if ([selectedFBID valueForKey:cell.textLabel.text] != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 2;
    
    
    
    // If extra information available then display this.
    if ([[myData objectAtIndex:indexPath.row] objectForKey:@"details"]) {
        cell.detailTextLabel.text = [[myData objectAtIndex:indexPath.row] objectForKey:@"details"];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    NSString* objectID = [[myData objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    FBFriend *fbfriend = [[FBFriend alloc] init];
    fbfriend.friendID = objectID;
    fbfriend.friendImage = [self imageForObject:[[myData objectAtIndex:indexPath.row] objectForKey:@"id"]];
    fbfriend.friendName = [[myData objectAtIndex:indexPath.row] objectForKey:@"name"];
    fbfriend.imageURLString = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
                            
    if( !fbfriend.friendImage){
        //if (tableView.dragging == NO && tableView.decelerating == NO)
        //{
            [self getImageForObject:fbfriend forIndexPath:indexPath];
        //}
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        
    }
    else {
        // The object's image
        cell.imageView.image = fbfriend.friendImage;
    }
    
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"indexPath:%@", indexPath);
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [selectedFBID removeObjectForKey:cell.textLabel.text];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        NSLog(@"CheckMark:%@",cell.tag);
        [selectedFBID setObject:(NSString*)cell.tag forKey:cell.textLabel.text];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) sendToFriend:(NSMutableArray *)coworkers
{
    
    NSLog(@"coworkers:%@",coworkers);
    NSLog(@"tripID:%@",self.tripID);
    NSString* coworkers_string = @"";
    
    for(NSString* coworker in coworkers)
    {
        coworkers_string = [coworkers_string stringByAppendingString:coworker];
        coworkers_string = [coworkers_string stringByAppendingString:@","];
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://map-out.appspot.com/update"];
    //宣告要post的值
    NSString *httpBodyString;
    
    
    httpBodyString=[NSString stringWithFormat:@"fb_id=%@&name=%@&trip_id=%@&friend_id=%@",
                    myFacebookID,
                    [self.tripNameTextField text],
                    self.tripID,
                    coworkers_string];
    
    
    //設定連線位置
    [request setURL:connection];
    //設定連線方式
    [request setHTTPMethod:@"POST"];
    //將編碼改為UTF8
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Fetch the JSON response
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",jsonString);
    
    //[self updateStays];
}

/*
-(void) updateStays
{
    NSLog(@"Start updateStays");
    
    NSMutableArray* stays_array = [[SpotsQuery getInstance] getStaysByTripId:self.tripID andUserId:myFacebookID];
    NSLog(@"Stays_array got%@",stays_array);
    
    NSString* spots_string = @"";
    NSString* arrivals_string = @"";
    for(NSDictionary* stay_dictionary in stays_array)
    {
        NSLog(@"stay_dictionary:%@",stay_dictionary);
        NSLog(@"spot_id:%@",[[stay_dictionary valueForKey:@"SpotId"] stringValue]);
        spots_string = [spots_string stringByAppendingString:[[stay_dictionary valueForKey:@"SpotId"] stringValue]];
        spots_string = [spots_string stringByAppendingString:@","];
        
        NSLog(@"at_time:%@",[stay_dictionary valueForKey:@"AtTime"]);
        
        
        arrivals_string = [arrivals_string stringByAppendingString:[stay_dictionary valueForKey:@"AtTime"]];
        arrivals_string = [arrivals_string stringByAppendingString:@","];
    }
    
     //for(NSDictionary* stay_dictionary in stays_array)
     //{
     //spots_string = [spots_string stringByAppendingString:[[stay_dictionary valueForKey:@"SpotId"] //stringValue]];
     //spots_string = [spots_string stringByAppendingString:@","];
     
     //arrivals_string = [arrivals_string stringByAppendingString:[[stay_dictionary valueForKey:@"AtTime"] stringValue]];
     //arrivals_string = [arrivals_string stringByAppendingString:@","];
     
     //}
     
    
    //NSString* spots_string = @"22,34,14,11,23";
    NSLog(@"spots:%@",spots_string);
    //NSString* arrivals_string = @"111,222,333,444,555";
    NSLog(@"arrivals:%@",arrivals_string);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://map-out.appspot.com/updatestays"];
    //宣告要post的值
    NSString *httpBodyString;
    
    httpBodyString=[NSString stringWithFormat:@"fb_id=%@&trip_id=%@&spots=%@&arrivals=%@",
                    myFacebookID,
                    self.tripID,
                    spots_string,
                    arrivals_string];
    
    //設定連線位置
    [request setURL:connection];
    //設定連線方式
    [request setHTTPMethod:@"POST"];
    //將編碼改為UTF8
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Fetch the JSON response
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",jsonString);
    
    
}
*/


-(IBAction)sendFBID:(id)sender{
    NSLog(@"sendFBID");
    NSLog(@"selectedFBID:%@", selectedFBID);
    
    NSMutableArray* allFBID = [NSMutableArray array];
    for (NSString* key in selectedFBID) {
        //if ([key hasPrefix:@"www_"]) {
        [allFBID addObject:[selectedFBID objectForKey:key]];
        
        // write to a dictionary instead of an array
        // if you want to keep the keys too.
        //}
    }
    [self sendToFriend:allFBID];
    
    NSLog(@"allFBID:%@", allFBID);
    
    UIButton *sendButton = (UIButton*)sender;
     
    [sendButton setBackgroundImage:[UIImage imageNamed:@"mailbar_press.png"] forState:UIControlStateNormal];
     
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    NSLog(@"viewDidLoad");
    [self.tripNameTextField setText:tripName];
    loaded = NO;
    imageDictionary = [[NSMutableDictionary alloc] init ];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    myData2 = [[NSMutableArray alloc] init];

    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [delegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [delegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        
        NSLog(@"(viewDidLoad)accessToken: %@", [[delegate facebook] accessToken]);
        NSLog(@"(viewDidLoad)expirationDate: %@", [[delegate facebook] expirationDate]);
    }
    
    if (![[delegate facebook] isSessionValid]) {
        NSLog(@"not isSessionValid");
        [delegate facebook].sessionDelegate = self;
        [[delegate facebook] authorize:permissions];
    } else {
        NSLog(@"isSessionValid");

        // get my FB ID
        [self apiGraphMe];
        
    }
    
}

- (void)viewDidUnload
{
    [self setHelloBt:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     NSLog(@"textFieldShouldReturn");
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)dealloc {
    [HelloBt release];
    [super dealloc];
}
    
@end
