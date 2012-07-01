//
//  LoginViewController.m
//  TakeDishes
//
//  Created by  on 12/5/9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize facebook;
@synthesize permissions;
@synthesize fbButton;
@synthesize myFacebookID;
@synthesize myFacebookName;

static NSString* facebookAppId = @"146412965489498";
AppDelegate *delegate;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{ 
    NSLog(@"prepareForSegue");
    //check the identifier if there are multiple segue connection
    //make sure the correct spelling of identifier
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)sayHello:(id)sender {
    [facebook dialog:@"feed" andDelegate:self];
}

- (IBAction) loginFB:(id)sender{
    [delegate facebook].sessionDelegate = self;
    [[delegate facebook] authorize:permissions];

}


// Method that gets called when the logout button is pressed
- (void) logoutButtonClicked {
    NSLog(@"logout");
    [facebook logout:self];
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
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */
- (void) apiGraphMe {
    NSLog(@"apiGraphMe");
    
    currentAPICall = kAPIGraphMe;
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name,picture",  @"fields",
                                   nil];
    [[delegate facebook] requestWithGraphPath:@"me" andParams:params andDelegate:self];
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
    
    switch (currentAPICall) {
        case kAPIGraphMe:
        {
            NSLog(@"kAPIGraphMe");
            NSString *nameID = [[NSString alloc] initWithFormat:@"%@ (%@)", [result objectForKey:@"name"], [result objectForKey:@"id"]];
            NSString* facebookID = [result objectForKey:@"id"];
            NSMutableArray *userData = [[NSMutableArray alloc] initWithObjects:
                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                         [result objectForKey:@"id"], @"id", 
                                         nameID, @"name", 
                                         [result objectForKey:@"picture"], @"details", 
                                         nil], nil];
            
            
            NSLog(@"userData:%@", userData);
            NSLog(@"facebookID:%@", facebookID );
            
            myFacebookID = [NSString stringWithFormat:@"%@", facebookID];
            myFacebookName = [NSString stringWithFormat:@"%@", [result objectForKey:@"name"]];
            
            NSLog(@"myFacebookID:%@", myFacebookID);
            [self saveToAppDelegate:myFacebookID andName:myFacebookName ];
            
            [self goToNextView:myFacebookID];
            
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
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);

}

-(void) saveToAppDelegate:(NSString*) FBID andName:(NSString*) NAME{
    NSLog(@"saveToAppDelegate:%@",FBID);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setFacebookID:FBID];
    [appDelegate setFacebookName:NAME];
}

-(void) goToNextView:(NSString*) Parameter{
    
    NSLog(@"Go to NavController:%@", Parameter);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NavController"];
    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    

    
    [self presentModalViewController:vc animated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    fbButton.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)viewDidUnload
{
    //[self setHelloBt:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    fbButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //init facebook
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
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
        //[delegate facebook].sessionDelegate = self;
        //[[delegate facebook] authorize:permissions];
        fbButton.hidden = NO;
        
    } else {
        NSLog(@"isSessionValid");
        //[self showLoggedIn];
        //[self getUserFriends];
        
        [self apiGraphMe];
        
    }

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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    //[HelloBt release];
    //[super dealloc];
}
@end

