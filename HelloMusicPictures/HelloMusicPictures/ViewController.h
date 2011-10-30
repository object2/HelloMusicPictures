//
//  ViewController.h
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ObjectiveFlickr.h"

@interface ViewController : UIViewController <MPMediaPickerControllerDelegate, OFFlickrAPIRequestDelegate>
{
	// for MPMediaPlayer
	IBOutlet UISlider *volumeSlider;
    IBOutlet UIButton *playPauseButton;
	
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UILabel *albumLabel;
	
    MPMusicPlayerController *musicPlayer;
	
	IBOutlet UIButton *prevButton;
	IBOutlet UIButton *nextButton;
	
//	NSDate pauseStart;
//	NSDate previousFiringDate;

	
	// for Flickr
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;

	IBOutlet UIImageView *picImageView;
	
	NSTimer *nextPicTimer;
	NSDictionary *responseDict;
	
	NSDate *pauseStart;
	NSDate *previousFireDate;
	

	
}

// for Flickr
- (void)showPictureWithKeyword:(NSString *)keyword;
- (void)showNextPicture;
- (void)loadImageWithUrl:(NSURL *)imageUrl;
- (void)displayImage:(UIImage *)image;
- (void)stopShowPicture;
- (void)restartShowPicture;
- (void)pauseShowPicture;


// for MPMediaPlayer
- (IBAction)showMediaPlayer:(id)sender;
- (IBAction)volumeChanged:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void) registerMediaPlayerNotifications;

// for MPMediaPlayer
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

// for Flicker
@property (nonatomic, strong) NSDate *pauseStart;
@property (nonatomic, strong) NSDate *previousFireDate;
@property (nonatomic, strong) NSTimer *nextPicTimer;
@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;

@end
