//
//  ViewController.h
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

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
	IBOutlet UIImageView *picImageView;
	
	
	MPMusicPlayerController *musicPlayer;
	
	NSTimer *nextPicTimer;
	NSDictionary *responseDict;
	
	NSDate *pauseStart;
	NSDate *previousFireDate;	
	ImageLoader *imageLoader;
}

- (void)showNextPicture;
- (void)stopShowPicture;
- (void)restartShowPicture;
- (void)pauseShowPicture;

- (IBAction)saveImage:(id)sender;

// for MPMediaPlayer
- (IBAction)showMediaPlayer:(id)sender;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)randomPlay:(id)sender;

- (void) registerMediaPlayerNotifications;

// for MPMediaPlayer
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

// for Flicker
@property (nonatomic, strong) NSDate *pauseStart;
@property (nonatomic, strong) NSDate *previousFireDate;
@property (nonatomic, strong) NSTimer *nextPicTimer;


@property (nonatomic, strong) UIImageView *picImageView;


@end
