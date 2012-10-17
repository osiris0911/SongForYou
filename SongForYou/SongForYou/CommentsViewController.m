//
//  CommentsViewController.m
//  SongForYou
//
//  Created by  on 12/7/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentsViewController.h"

#define CGRectSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height )

@interface CommentsViewController ()

@end



@implementation CommentsViewController
@synthesize currFBImage, currFBId, currFBName, currSongImage, currSongId, currSongName, currSongObject;
@synthesize commentsTextField, activeTextView;
@synthesize tagList;
@synthesize audioPlayer;


static CGFloat AdderY;
+ (void) initialize {
    AdderY = 346;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)AddTagClicked:(id)sender{
    NSLog(@"AddTagClicked");
    
    tagList.hidden = NO;
    tagAdder.hidden = YES;
    
    [self.activeTextView resignFirstResponder];
    
    //currEZAPI = EZ_apiAddRest;
    //[self apiAddRest:addRestTextField.text andLat:latitudeStr andLng:longitudeStr andAccessToken:@"6UOzCFaTuKjW0Fw9FaUUz7k2jbW57fo3Z3tsytbT"];
}

- (IBAction)doneButton:(id)sender{
    NSLog(@"doneButton");
    
    SongForYous = [self loadSonForYous];
    if (SongForYous == nil){
        SongForYous = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"currSongObject:%@",currSongObject);
    
    NSLog(@"commentsTextField.text:%@",commentsTextField.text);
    if ([commentsTextField.text isEqualToString:@""]) {
        NSLog(@"MM");
        commentsTextField.text = @"這是我們在大學時期最令人懷念的一首歌曲！祝你出國順利～";
    }
    
    SongForYou *songforyou = [[SongForYou alloc] init];
    [songforyou setTheSong:currSongObject];
    [songforyou setMessage:commentsTextField.text];
    [songforyou setTags:TagsArray];
    [songforyou setSender:@"Hung-Chi Lee"];
    [songforyou setReceiver:currFBName];
    [SongForYous addObject:songforyou];
    NSLog(@"songforyou:%@",songforyou);
    [self saveSongForYous:SongForYous];
    
    [self performSegueWithIdentifier:@"GoToHistory" sender:self];
}



- (IBAction)songPlayClicked:(id)sender{
    NSLog(@"songPlayClicked:%@", sender);
    
    [self cancelAllSongs];
    
    //UIButton *listenButton = (UIButton*)sender;
    //NSLog(@"listenButton.tag:%@",listenButton.tag);
    NSString *songUrl = [NSString stringWithFormat:@"https://dl.dropbox.com/u/16447993/songs/%@.mp3", currSongId];
    
    //AudioPlayerAppDelegate *audioPlayer = [AudioPlayerInProgress objectForKey:[NSString stringWithFormat:@"%@",listenButton.tag]];
    //if( audioPlayer == nil){
    NSLog(@"new audioPlayer");
    //audioPlayer  = [[AudioPlayerAppDelegate alloc] init];
    //[AudioPlayerInProgress setObject:audioPlayer forKey:[NSString stringWithFormat:@"%@",listenButton.tag]];
    [audioPlayer loadSong:songUrl];
    //    }
    //    else {
    //        [audioPlayer playSong];
    //        
    //    }
}

- (void)cancelAllSongs{
    NSLog(@"cancelAllSongs");
    
    [audioPlayer cancelSong];
    
    // terminate all pending download connections
    //NSArray *allAudioPlayer = [self.AudioPlayerInProgress allValues];
    //NSLog(@"allAudioPlayer:%@",allAudioPlayer);
    //[allAudioPlayer makeObjectsPerformSelector:@selector(pauseSong)];
}


// 儲存資料
-(void)saveSongForYous:(NSMutableArray*) saveObject {
    NSLog(@"saveSongForYous:%@", saveObject);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:saveObject];
    [defaults setObject:saveData forKey:@"SongForYouHistory"];
    NSLog(@"save done");
}

// 讀取資料
-(NSMutableArray*) loadSonForYous {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *saveData = [defaults objectForKey:@"SongForYouHistory"];
    NSLog(@"loadSonForYous:%@", saveData);
    NSMutableArray *loadObject = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
    return loadObject;
}


- (void)keyboardWasShown:(NSNotification *)notification{
    NSLog(@"keyboardWasShown");
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGRect AdderShowRect;
    AdderShowRect = CGRectSetPos(tagAdder.frame, 0 , AdderY - keyboardSize.height);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationTransitionNone 
                     animations:^{
                         tagAdder.frame = AdderShowRect;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"completion");
                     }];
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"keyboardWillHide");
    
    CGRect AdderHideRect;
    AdderHideRect = CGRectSetPos(tagAdder.frame, 0, AdderY);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationTransitionNone 
                     animations:^{
                         tagAdder.frame = AdderHideRect;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"completion");
                     }];
    
    [UIView commitAnimations];
    
}

- (void)prepareForData{
    NSLog(@"prepareForData");
    
    Tag *tag = [[Tag alloc] init];
    [tag setText:@"出國"];
    [tag setTagID:@"1"];
    [Tags addObject:tag];
    
    tag = [[Tag alloc] init];
    [tag setText:@"大學"];
    [tag setTagID:@"2"];
    [Tags addObject:tag];
    
    tag = [[Tag alloc] init];
    [tag setText:@"演唱會"];
    [tag setTagID:@"3"];
    [Tags addObject:tag];
    
    tag = [[Tag alloc] init];
    [tag setText:@"台語歌"];
    [tag setTagID:@"4"];
    [Tags addObject:tag];
    
    tag = [[Tag alloc] init];
    [tag setText:@"樂團"];
    [tag setTagID:@"5"];
    [Tags addObject:tag];
    
    tag = [[Tag alloc] init];
    [tag setText:@"New Tag"];
    [tag setTagID:@"0"];
    [Tags addObject:tag];
    
    [self ShowTagList:Tags];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"currFBId:%@", currFBId);
    NSLog(@"currSongId:%@", currSongId);
    NSLog(@"currFBImage:%@", currFBImage);
    NSLog(@"currSongImage:%@", currSongImage);
    
    friendImageView.image = currFBImage;
    albumImageView.image = currSongImage;
    friendLabel.text = currFBName;
    songLabel.text = currSongName;
    
    Tags = [[NSMutableArray alloc] init];
    TagsArray = [[NSMutableArray alloc] init];
    [self prepareForData];
    
    [self.view addSubview:tagList];
    tagList.hidden = NO;
    
    tagAdder = [[TagAdder alloc] initWithFrame:CGRectMake(0, 380, 320, 70)];
    tagAdder.hidden = YES;
    NSArray *addTagSubView = tagAdder.subviews;
    UIButton *addTagButton = [addTagSubView objectAtIndex:1];
    addTextField = [addTagSubView objectAtIndex:0];
    addTextField.delegate = (id)self;
    
    [addTagButton addTarget:self action:@selector(AddTagClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tagAdder];
    
    // Register Keyboard Observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    NSLog(@"AudioPlayerInProgress init");
    //AudioPlayerInProgress = [[NSMutableDictionary alloc] init];
    audioPlayer = [[AudioPlayerAppDelegate alloc] init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [audioPlayer cancelSong];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)ShowTagList:(NSMutableArray*) Array{
    NSLog(@"ShowTagList:%@",Array);
    
    for(int i=0; i<Array.count;i++){
        TagButton *current = [[TagButton alloc] initWithName:[[Array objectAtIndex:i] Text] andID:[[[Array objectAtIndex:i] TagID] intValue]];
        
        [self.tagList addTagButtons: current];
        [current addTarget:self action:@selector(TagClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showAddNewTag{
    NSLog(@"showAddNewTag");
    
    tagList.hidden = YES;
    tagAdder.hidden = NO;
    
}

- (void)TagClicked:(id)sender {
    UIButton *Button = (UIButton *)sender;
    NSArray *SubViews = Button.subviews;
    UILabel *Label = [SubViews objectAtIndex:1];
    
    if(Label.text == @"New Tag"){
        [self showAddNewTag];
    }
    else {
        // Show restaurant's name on the image
        //tagLabel.text = Label.text;
        if (![TagsArray containsObject:Label.text]) {
            [TagsArray addObject:Label.text];
        }
        else {
            [TagsArray removeObject:Label.text];
        }
        
        tagLabel.text = @"";
        for (int i=0; i < TagsArray.count ; i++){
            if (i == 0) {
                tagLabel.text = [TagsArray objectAtIndex:i];
            }
            else {
                tagLabel.text = [NSString stringWithFormat:@"%@, %@",tagLabel.text, [TagsArray objectAtIndex:i]]; 
            }
        }
    }
}

- (BOOL)textViewShouldReturn:(UITextView *)textView{
    NSLog(@"textViewShouldReturn");
    [self.activeTextView resignFirstResponder];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textViewDidBeginEditing");
    self.activeTextView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing");
    self.activeTextView = nil;
}

@end
