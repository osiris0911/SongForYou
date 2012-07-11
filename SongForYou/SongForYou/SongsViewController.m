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
@synthesize Songs;
@synthesize currFBImage, currFBId, currFBName;

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

- (void)songPlayClicked:(id)sender{
    NSLog(@"songPlayClicked");
    
    
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
    [cell.contentView addSubview:listenButton];
    
    /*
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    [downloadButton setFrame:CGRectMake(100, 0, 100, 35)];
    //[tableView cellForRowAtIndexPath:indexPath].accessoryView = downloadButton;
    [cell.contentView addSubview:downloadButton];
    */
    
    /*
    NSString* objectID = [[Songs objectAtIndex:indexPath.row] objectForKey:@"id"];
    
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
    */
    
    // Configure the cell.
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
        SongId = (NSString*)cell.tag;
        SongName = cell.textLabel.text;
        
        [self performSegueWithIdentifier:@"SetComments" sender:self];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
        
    }
    
}


- (void)prepareForData{
    
    NSLog(@"prepareForData");
    Songs = [[NSMutableArray alloc] init];
    Song *song = [[Song alloc] init];
    [song setSongID:@"1"];
    [song setTitle:@"阿爸的虱目魚"];
    [song setAlbum:@"思念會驚"];
    [song setSinger:@"蕭煌奇"];
    [song setAlbumImage:@"album1.jpg"];
    [Songs addObject:song];
    
    song = [[Song alloc] init];
    [song setSongID:@"2"];
    [song setTitle:@"活著"];
    [song setAlbum:@"蕭敬騰同名專輯"];
    [song setSinger:@"蕭敬騰"];
    [song setAlbumImage:@"album2.jpg"];
    [Songs addObject:song];
    
    song = [[Song alloc] init];
    [song setSongID:@"3"];
    [song setTitle:@"故事細膩"];
    [song setAlbum:@"學不會"];
    [song setSinger:@"林俊傑"];
    [song setAlbumImage:@"album3.jpg"];
    [Songs addObject:song];
    
    song = [[Song alloc] init];
    [song setSongID:@"4"];
    [song setTitle:@"完美落地"];
    [song setAlbum:@"「翻滾吧！阿信」電影原聲帶"];
    [song setSinger:@"陳泰翔(阿翔)"];
    [song setAlbumImage:@"album4.jpg"];
    [Songs addObject:song];
    
    song = [[Song alloc] init];
    [song setSongID:@"5"];
    [song setTitle:@"諾亞方舟"];
    [song setAlbum:@"第二人生 Now Here 明日版"];
    [song setSinger:@"五月天(Mayday)"];
    [song setAlbumImage:@"album5.png"];
    [Songs addObject:song];
    
    NSLog(@"Songs:%@", Songs);
    
    loaded = YES;
    [SongsTableView reloadData];
    NSLog(@"reloadData");
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
