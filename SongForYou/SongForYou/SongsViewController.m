//
//  SongsViewController.m
//  SongForYou
//
//  Created by  on 12/7/5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SongsViewController.h"

@interface SongsViewController ()

@end

@implementation SongsViewController

@synthesize SongsTableView;
@synthesize Songs, SongsDictionary;
@synthesize currFBImage, currFBId, currFBName;
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
    NSLog(@"numberOfRowsInSection:%d", [Songs count]);

    if(loaded){
        NSLog(@"numberOfRowsInSection = YES");
        return [Songs count];
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
    
    cell.tag = (NSInteger)[[Songs objectAtIndex:indexPath.row] SongID];
    cell.textLabel.text = [[Songs objectAtIndex:indexPath.row] Title];

    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 2;
    
    // Set image
    cell.imageView.image = [UIImage imageNamed:[[Songs objectAtIndex:indexPath.row] AlbumImage]];
    cell.imageView.image = [SongsViewController imageWithImage:cell.imageView.image scaledToSize:CGSizeMake(50, 50)];
    
    // If extra information available then display this.
    if ([[Songs objectAtIndex:indexPath.row] Singer]) {
        cell.detailTextLabel.text = [[Songs objectAtIndex:indexPath.row] Singer];
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
        
        SongImage = cell.imageView.image;
        SongId = [NSString stringWithFormat:@"%@", cell.tag];
        SongName = cell.textLabel.text;
        SongObject = [SongsDictionary objectForKey:[NSString stringWithFormat:@"%@", cell.tag]];
                      
        [self performSegueWithIdentifier:@"SetComments" sender:self];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSLog(@"cancelAllSongs:%@", AudioPlayerInProgress);
    
    [audioPlayer cancelSong];
    
    // terminate all pending download connections
    //NSArray *allAudioPlayer = [self.AudioPlayerInProgress allValues];
    //NSLog(@"allAudioPlayer:%@",allAudioPlayer);
    //[allAudioPlayer makeObjectsPerformSelector:@selector(pauseSong)];
}

- (void)viewDidLoad
{
    NSLog(@"SongsViewController");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self prepareForData];
    
    loaded = NO;
    
    NSLog(@"currFBId:%@", currFBId);
    
    friendImageView.image = currFBImage;
    friendLabel.text = currFBName;
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{ 
    NSLog(@"prepareForSegue");
    //check the identifier if there are multiple segue connection
    //make sure the correct spelling of identifier
    
    if ([segue.identifier isEqualToString:@"SetComments"] ) {
        
        // go to next page
        CommentsViewController *commentsVController = [segue destinationViewController];
        [commentsVController setCurrFBImage:currFBImage];
        [commentsVController setCurrFBId:currFBId];
        [commentsVController setCurrFBName:currFBName];
        [commentsVController setCurrSongImage:SongImage];
        [commentsVController setCurrSongId:SongId];
        [commentsVController setCurrSongName:SongName];
        [commentsVController setCurrSongObject:SongObject];
        
    }
    
}


- (void)prepareForData{
    
    NSLog(@"prepareForData");
    Songs = [[NSMutableArray alloc] init];
    SongsDictionary = [[NSMutableDictionary alloc] init];
    
    Song *song = [[Song alloc] init];
    [song setSongID:@"1"];
    [song setTitle:@"王妃"];
    [song setAlbum:@"王妃"];
    [song setSinger:@"蕭敬騰"];
    [song setAlbumImage:@"album1.jpg"];
    [song setSongUrl:@"https://dl.dropbox.com/u/16447993/songs/1.mp3"];
    [Songs addObject:song];
    [SongsDictionary setObject:song forKey:[song SongID]];
    
    song = [[Song alloc] init];
    [song setSongID:@"2"];
    [song setTitle:@"空港"];
    [song setAlbum:@"愛靈靈"];
    [song setSinger:@"戴愛玲"];
    [song setAlbumImage:@"album2.jpg"];
    [song setSongUrl:@"https://dl.dropbox.com/u/16447993/songs/2.mp3"];
    [Songs addObject:song];
    [SongsDictionary setObject:song forKey:[song SongID]];
    
    song = [[Song alloc] init];
    [song setSongID:@"3"];
    [song setTitle:@"痴心絕對"];
    [song setAlbum:@"痴心絕對"];
    [song setSinger:@"李聖傑"];
    [song setAlbumImage:@"album3.jpg"];
    [song setSongUrl:@"https://dl.dropbox.com/u/16447993/songs/3.mp3"];
    [Songs addObject:song];
    [SongsDictionary setObject:song forKey:[song SongID]];
    
    song = [[Song alloc] init];
    [song setSongID:@"4"];
    [song setTitle:@"愛"];
    [song setAlbum:@"就 i Karen 莫文蔚精選"];
    [song setSinger:@"莫文蔚"];
    [song setAlbumImage:@"album4.jpg"];
    [song setSongUrl:@"https://dl.dropbox.com/u/16447993/songs/4.mp3"];
    [Songs addObject:song];
    [SongsDictionary setObject:song forKey:[song SongID]];
    
    song = [[Song alloc] init];
    [song setSongID:@"5"];
    [song setTitle:@"紅豆"];
    [song setAlbum:@"可啦思刻"];
    [song setSinger:@"方大同"];
    [song setAlbumImage:@"album5.jpg"];
    [song setSongUrl:@"https://dl.dropbox.com/u/16447993/songs/5.mp3"];
    [Songs addObject:song];
    [SongsDictionary setObject:song forKey:[song SongID]];
    
    loaded = YES;
    [SongsTableView reloadData];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
