//
//  HistoryViewController.m
//  SongForYou
//
//  Created by  on 12/7/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize HistoryTableView;
@synthesize AudioPlayerInProgress;
@synthesize audioPlayer;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    NSLog(@"numberOfRowsInSection:%d", [SongForYous count]);
    
    if(loaded){
        NSLog(@"numberOfRowsInSection = YES");
        return [SongForYous count];
    }
    else {
        NSLog(@"numberOfRowsInSection = NO");
        return 0;
    }
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    Song *song = [[SongForYous objectAtIndex:indexPath.row] TheSong];
    
    NSLog(@"song:%@", [song SongID]);
    cell.tag = (NSInteger)[song SongID];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ( to: %@ )", [song Title], [[SongForYous objectAtIndex:indexPath.row] Receiver]];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 2;
    
    // Set image
    cell.imageView.image = [UIImage imageNamed:[song AlbumImage]];
    cell.imageView.image = [HistoryViewController imageWithImage:cell.imageView.image scaledToSize:CGSizeMake(50, 50)];
    
    // If extra information available then display this.
    
    if ([[SongForYous objectAtIndex:indexPath.row] Message]) {
        cell.detailTextLabel.text = [[SongForYous objectAtIndex:indexPath.row] Message];
        if ([[SongForYous objectAtIndex:indexPath.row] Message].length > 20) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@...", [[cell.detailTextLabel.text substringToIndex:20] substringFromIndex:0]];
        }
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    
    UIButton *listenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listenButton setImage:[UIImage imageNamed:@"listen.png"] forState:UIControlStateNormal];
    [listenButton setFrame:CGRectMake(260, 12, 22, 20)];
    [listenButton addTarget:self action:@selector(songPlayClicked:) forControlEvents:UIControlEventTouchUpInside];
    [listenButton setTag:cell.tag];
    
    [cell.contentView addSubview:listenButton];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"indexPath:%@", indexPath);
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        //[selectedFBID removeObjectForKey:cell.textLabel.text];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        NSLog(@"CheckMark:%@",cell.tag);
        //[selectedFBID setObject:(NSString*)cell.tag forKey:cell.textLabel.text];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //SongImage = cell.imageView.image;
        //SongId = [NSString stringWithFormat:@"%d", cell.tag];
        //SongName = cell.textLabel.text;
        
        //[self performSegueWithIdentifier:@"SetComments" sender:self];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 讀取資料
-(NSMutableArray*) loadSonForYous {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *saveData = [defaults objectForKey:@"SongForYouHistory"];
    NSLog(@"loadSonForYous:%@", saveData);
    NSMutableArray *loadObject = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
    return loadObject;
}

- (IBAction)cancelAllHistory:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SongForYouHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SongForYous = nil;
    loaded = YES;
    [HistoryTableView reloadData];
}
- (void)songPlayClicked:(id)sender{
    NSLog(@"songPlayClicked:%@", sender);
    
    [self cancelAllSongs];
    
    UIButton *listenButton = (UIButton*)sender;
    NSLog(@"listenButton.tag:%@",listenButton.tag);
    NSString *songUrl = [NSString stringWithFormat:@"https://dl.dropbox.com/u/16447993/songs/%@.mp3", listenButton.tag];
    
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
 

- (void)prepareForData{
        
    SongForYous = [self loadSonForYous];
    if (SongForYous == nil){
        SongForYous = [[NSMutableArray alloc] init];
    }
    NSLog(@"prepareForData:%@", SongForYous);
    
    
    loaded = YES;
    [HistoryTableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    loaded = NO;
    
    [self prepareForData];
    
    NSLog(@"AudioPlayerInProgress init");
    //AudioPlayerInProgress = [[NSMutableDictionary alloc] init];
    audioPlayer = [[AudioPlayerAppDelegate alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self cancelAllSongs];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
