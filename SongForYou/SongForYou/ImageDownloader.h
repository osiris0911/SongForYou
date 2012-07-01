

@class FBFriend;
@class FBFriendsViewController;

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject
{
    FBFriend *fbfriend;
    NSIndexPath *indexPathInTableView;
    id <ImageDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) FBFriend *fbfriend;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol ImageDownloaderDelegate 

- (void)fbImageDidLoad:(NSIndexPath *)indexPath;

@end