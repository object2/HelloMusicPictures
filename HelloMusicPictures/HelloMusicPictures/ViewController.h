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

	
	// for Flickr
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;

	IBOutlet UIImageView *picImageView;
	
	NSTimer *nextPicTimer;
	NSDictionary *responseDict;
	

	
}

// for Flickr
- (void)showPictureWithKeyword:(NSString *)keyword;
- (void)showNextPicture;
- (void)loadImageWithUrl:(NSURL *)imageUrl;
- (void)displayImage:(UIImage *)image;

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
@property (nonatomic, strong) NSTimer *nextPicTimer;
@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;

@end
