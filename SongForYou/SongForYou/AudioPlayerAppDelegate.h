//
//  AudioPlayerAppDelegate.h
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface AudioPlayerAppDelegate : NSObject <UIApplicationDelegate, UITextFieldDelegate, AudioPlayerDelegate> {
    UIWindow *window;
	IBOutlet UITextField *urlTextField;
	IBOutlet UIActivityIndicatorView *activityIndicatorView;
	IBOutlet UIButton *pauseButton;
	IBOutlet UIButton *playButton;
	
	AudioPlayer *audioPlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) AudioPlayer *audioPlayer;

/*
 * Loads and plays the audio URL input by the user.
 */
- (IBAction)load;
- (void)loadSong:(NSString*) songUrl;
/*
 * Pauses the currently playing audio.
 */
- (IBAction)pause;
- (void)pauseSong;

/*
 * Resumes playing the current audio after pause.
 */
- (IBAction)play;
- (void)playSong;

- (void)cancelSong;


@end

