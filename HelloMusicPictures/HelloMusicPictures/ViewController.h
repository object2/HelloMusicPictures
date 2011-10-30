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
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;

	IBOutlet UIImageView *picImageView;
	
	NSTimer *nextPicTimer;
	
    
	
	UIButton *showPictureButton;
	UITextField *keywordTextField;
	NSDictionary *responseDict;
	

	
}
- (IBAction)showMediaPlayer:(id)sender;
- (void)showPictureWithKeyword:(NSString *)keyword;
- (void)showNextPicture;
- (void)loadImageWithUrl:(NSURL *)imageUrl;
- (void)displayImage:(UIImage *)image;

@property (nonatomic, retain) NSTimer *nextPicTimer;
@property (nonatomic, retain) NSDictionary *responseDict;

@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;

@end
