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

#import "AnimationView.h"


@class ImageLoader;
@class AnimationView;

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

	__weak IBOutlet AnimationView *aniView;
	IBOutlet UITextView *lyricsView;
	
	IBOutlet UIImageView *progressBar;
	
	int imageIdx;
	
	
	IBOutlet UIView *controls;
	
	MPMusicPlayerController *musicPlayer;
	
	NSTimer *nextPicTimer;
	NSTimer *progressTimer;
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
- (void)stopShowPicture;
- (void)restartShowPicture;
- (void)pauseShowPicture;



- (IBAction)saveImage:(id)sender;

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
- (void)updateProgressBar;
- (void)setPlayButtonToPause;
- (void)setPauseButtonToPlay;




//UI
-(void) onControlsHidingTimerEvent:(NSTimer*)aTimer;


// for MPMediaPlayer
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) UIImageView *progressBar;
@property (nonatomic, strong) NSTimer *progressTimer;

// for Flicker
@property (nonatomic, strong) NSDate *pauseStart;
@property (nonatomic, strong) NSDate *previousFireDate;
@property (nonatomic, strong) NSTimer *nextPicTimer;


@end
