
#import <UIKit/UIKit.h>

@interface FBFriend : NSObject
{
    NSString *friendID;
    NSString *friendName;
    UIImage *friendImage;
    NSString *imageURLString;
}

@property (nonatomic, retain) NSString *friendID;
@property (nonatomic, retain) NSString *friendName;
@property (nonatomic, retain) UIImage *friendImage;
@property (nonatomic, retain) NSString *imageURLString;


@end