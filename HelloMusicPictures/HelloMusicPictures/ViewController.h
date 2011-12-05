//
//  ViewController.h
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class ImageLoader;

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate>
{
	// for MPMediaPlayer
	IBOutlet UISlider *volumeSlider;
    IBOutlet UIButton *playPauseButton;
	
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *albumLabel;
	IBOutlet UIButton *prevButton;
	IBOutlet UIButton *nextButton;	
	IBOutlet UISwitch *randomSwitch;
	IBOutlet UIImageView *picImageView1;
	IBOutlet UIImageView *picImageView2;
	IBOutlet UITextView *lyricsView;
	
	int imageIdx;
	int imageShowing;
	CGFloat imageEffectFlag; // 화면 애니메이션에서 사용
	
	IBOutlet UIView *controls;
	
	MPMusicPlayerController *musicPlayer;
	
	NSTimer *nextPicTimer;
	NSDictionary *responseDict;
	
	NSDate *pauseStart;
	NSDate *previousFireDate;	
	ImageLoader *imageLoader;
	
	NSTimer *controlsHideTimer;
	UISwipeGestureRecognizer *swipeRecog;
	UISwipeGestureRecognizer *swipeRecogRight;
	UISwipeGestureRecognizer *swipeRecogLeft;
}
@property(nonatomic, retain) NSTimer *controlsHideTimer;
- (void)showNextPicture;
- (void)stopShowPicture;
- (void)restartShowPicture;
- (void)pauseShowPicture;

- (void)startSlideshow;
- (void)toggleAlpha;
- (void)toggleShowing;
- (CGAffineTransform)getAfterTransformWithWidth:(CGFloat)width height:(CGFloat)height;
- (CGAffineTransform)getBeforeTransformWithWidth:(CGFloat)width height:(CGFloat)height;



- (IBAction)saveImage:(id)sender;
// flickr
- (NSString *)removeSpecialCharacter:(NSString *)str;
- (NSString *)makeKeywordWithTitle:(NSString*)title artist:(NSString *)artist album:(NSString*)album;

// for MPMediaPlayer
- (IBAction)showMediaPickerViewController:(id)sender;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)randomPlay:(id)sender;
- (IBAction)twit:(id)sender;

- (void)registerMediaPlayerNotifications;
- (void)displayMusicInfo:(MPMediaItem *)currentItem;
- (NSString *)makeKeywordWithItem:(MPMediaItem *)currentItem;


//UI
-(void) onControlsHidingTimerEvent:(NSTimer*)aTimer;


// for MPMediaPlayer
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

// for Flicker
@property (nonatomic, strong) NSDate *pauseStart;
@property (nonatomic, strong) NSDate *previousFireDate;
@property (nonatomic, strong) NSTimer *nextPicTimer;

@property (nonatomic, strong) UIImageView *picImageView2;
@property (nonatomic, strong) UIImageView *picImageView1;





@end
