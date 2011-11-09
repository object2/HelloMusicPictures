//
//  ViewController.m
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import "ViewController.h"
#import "MPMediaPickerControllerLandScape.h"
#import "ImageLoader.h"

#define L_WIDTH 1024
#define L_HEIGHT 748
#define P_WIDTH 768
#define P_HEIGHT 1004


@implementation ViewController

@synthesize picImageView1, picImageView2;
@synthesize nextPicTimer;
@synthesize musicPlayer;
@synthesize pauseStart, previousFireDate;



CGFloat flag = 1.0; // 화면 애니메이션에서 사용


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
												  object: musicPlayer];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self
													name: MPMusicPlayerControllerVolumeDidChangeNotification
												  object: musicPlayer];
	
	[musicPlayer endGeneratingPlaybackNotifications];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
	musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	[volumeSlider setValue:[musicPlayer volume]];
	
	
	if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {		
		
		[playPauseButton setTitle:@"일시정지" forState:UIControlStateNormal];
	}else {
		
		[playPauseButton setTitle:@"재생" forState:UIControlStateNormal];
	}

	
	
	[self registerMediaPlayerNotifications];
	imageLoader = [[ImageLoader alloc] init];
	
	// TODO : 뮤직 플레이어 완성 시 아래 메소드는 음악 선택 후 불려지도록 옮겨져야함
	//[self showPictureWithKeyword:@"music"];

	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - MediaPlayer
- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
	
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
	
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
	
	
	
    [musicPlayer beginGeneratingPlaybackNotifications];
}

- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
	
	
	
	
    //UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
//    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
	
//    if (artwork) {
//        artworkImage = [artwork imageWithSize: CGSizeMake (200, 200)];
//    }
//	
    //[artworkImageView setImage:artworkImage];
	
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        titleLabel.text = [NSString stringWithFormat:@"%@",titleString];
    } else {
        titleLabel.text = @"Unknown Title";
    }
	
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"%@",artistString];
    } else {
        artistLabel.text = @"Unknown Artist";
    }
	
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumLabel.text = [NSString stringWithFormat:@"%@",albumString];
    } else {
        albumLabel.text = @"Unknown Album";
    }
	

	
	// TODO 키워드 뽑아내기
	NSString *keyword = @"music";
	if(artistString) {
		keyword = artistString;
	} else if(titleString) {
		keyword = titleString;
	} else if(albumString) {
		keyword = albumString;
	} 
	
	[imageLoader loadImages:keyword completion:^{
		[nextPicTimer invalidate];

		imageShowing = 1;
		picImageView1.alpha = 1.0;
		picImageView2.alpha = 0.0;
		
		
		picImageView1.image = [imageLoader nextImage];
		
//		self.nextPicTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showNextPicture) userInfo:nil repeats:YES];
		self.nextPicTimer = [NSTimer scheduledTimerWithTimeInterval:9.2 target:self selector:@selector(fadeScreen) userInfo:nil repeats:YES];
	}];
}

- (void) handle_PlaybackStateChanged: (id) notification
{
	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
		[playPauseButton setTitle:@"재생" forState:UIControlStateNormal];
		
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[playPauseButton setTitle:@"일시정지" forState:UIControlStateNormal];
		
	} else if (playbackState == MPMusicPlaybackStateStopped) {
		[playPauseButton setTitle:@"재생" forState:UIControlStateNormal];
		[musicPlayer stop];
		[self stopShowPicture];
		
	}
	

	
}

- (void) handle_VolumeChanged: (id) notification
{
    [volumeSlider setValue:[musicPlayer volume]];
}


- (IBAction)showMediaPlayer:(id)sender
{
	MPMediaPickerControllerLandScape *picker =
			[[MPMediaPickerControllerLandScape alloc] initWithMediaTypes: MPMediaTypeMusic];
		
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");

	// The media item picker uses the default UI style, so it needs a default-style
	//		status bar to match it visually
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];

	[self presentModalViewController: picker animated: YES];
}


- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
	NSLog(@"음악 선택 %@", mediaItemCollection);
	if (mediaItemCollection) {
		
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
    }
	
    [self dismissModalViewControllerAnimated: YES];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	NSLog(@"음악선택 포기");
	[self dismissModalViewControllerAnimated: YES];
}


- (IBAction)volumeChanged:(id)sender
{
    [musicPlayer setVolume:[volumeSlider value]];
}

- (IBAction)playPause:(id)sender
{
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        [musicPlayer pause];
		[self pauseShowPicture];
		
    } else {
        [musicPlayer play];
		[self restartShowPicture];
		
    }
}

- (IBAction)previousSong:(id)sender
{
    [musicPlayer skipToPreviousItem];
}

- (IBAction)nextSong:(id)sender
{
    [musicPlayer skipToNextItem];
}

- (IBAction)randomPlay:(id)sender
{	
	if(randomSwitch.on)
	{
		[musicPlayer setShuffleMode:MPMusicShuffleModeSongs];
		//[musicPlayer skipToNextItem];
	}
	else{
		[musicPlayer setShuffleMode:MPMusicShuffleModeDefault];
	}
}



#pragma mark - Picture

- (void)showNextPicture
{
	[picImageView1 setImage:[imageLoader nextImage]];
}


- (void)stopShowPicture
{
	NSLog(@"stop pic");
	[nextPicTimer invalidate];

}

- (void)pauseShowPicture
{
	NSLog(@"pause pic");
	pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
	
	previousFireDate = [nextPicTimer fireDate];
	
	[nextPicTimer setFireDate:[NSDate distantFuture]];
}

- (IBAction)saveImage:(id)sender {
	UIImageWriteToSavedPhotosAlbum(picImageView1.image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	NSLog(@"%s %@ error=%@ context=%@", __PRETTY_FUNCTION__, image, error, contextInfo);
}


- (void)restartShowPicture
{
	NSLog(@"restart pic");
	float pauseTime = -1 * [pauseStart timeIntervalSinceNow];
	
	[nextPicTimer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];

}



#pragma mark animation
- (void)toggleAlpha
{
	if (picImageView1.alpha == 1.0) {
		picImageView1.alpha = 0.0;
		picImageView2.alpha = 1.0;
	} else {
		picImageView1.alpha = 1.0;
		picImageView2.alpha = 0.0;
	}
}

- (void)toggleShowing
{
	imageShowing = (imageShowing == 1) ? 2: 1;
}

- (CGAffineTransform)getBeforeTransformWithWidth:(CGFloat)width height:(CGFloat)height
{
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		if(width / height > 1.6) {
			//float aspectRatio = L_HEIGHT / height;
			int dx = (width * L_HEIGHT / height - L_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * flag, 0);
			NSLog(@"Moving hor");
			
		} else if(width / height < 0.8) {
			int dy = (height * L_WIDTH / width - L_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * flag); // 임시
			NSLog(@"Moving ver %d", dy);
		} else {
			transform = CGAffineTransformMakeScale(1.4, 1.4);	
		}
		
	} else {
		if(width / height > 1.2) {
			//float aspectRatio = P_HEIGHT / height;
			int dx = (width * P_HEIGHT / height - P_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * flag, 0);
			
		} else if(width / height < 0.6) {
			int dy = (height * P_WIDTH / width - P_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * flag); // 임시
			
		} else {
			transform = CGAffineTransformMakeScale(1.4, 1.4);	
		}
		
	}
	
	return transform;
}

- (CGAffineTransform)getAfterTransformWithWidth:(CGFloat)width height:(CGFloat)height
{
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		if(width / height > 1.5) {
			//float aspectRatio = L_HEIGHT / height;
			flag = flag * -1;
			int dx = (width * L_HEIGHT / height - L_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * flag, 0);
			
		} else if(width / height < 0.8) {
			flag = flag * -1;
			int dy = (height * L_WIDTH / width - L_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * flag); // 임시

		} else {
			transform = CGAffineTransformIdentity;
			
		}
		
	} else {
		if(width / height > 1.2) {
			//float aspectRatio = P_HEIGHT / height;
			flag = flag * -1;
			int dx = (width * P_HEIGHT / height - P_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * flag, 0);
			
		} else if(width / height < 0.6) {
			flag = flag * -1;
			int dy = (height * P_WIDTH / width - P_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * flag); // 임시
			
		} else {
			transform = CGAffineTransformIdentity;
		}
		
	}
	
	return transform;
	
	
}



- (void)fadeScreen
{
	// beforeAnimation
	
	
//	imageIdx++;
//	if(imageIdx > [imageLoader numOfPictures] - 1)
//		imageIdx = 0;
	
	
	if (imageShowing == 1) {
		picImageView2.image = [imageLoader nextImage];//[imageList objectAtIndex:imageIdx];
		picImageView2.transform = [self getBeforeTransformWithWidth:picImageView2.image.size.width 
														  height:picImageView2.image.size.height];
		
	} else {
		picImageView1.image = [imageLoader nextImage];//[imageList objectAtIndex:imageIdx];
		picImageView1.transform = [self getBeforeTransformWithWidth:picImageView1.image.size.width 
														  height:picImageView1.image.size.height];
		
	}
	
	[self toggleShowing];
	
	// Animation
	[UIView 
	 animateWithDuration:2.0 
	 //  delay:1.0
	 //options:UIViewAnimationCurveLinear
	 animations:^{ /* fade animations */ 
		 
		 [self toggleAlpha];
		 
		 
		 
	 } 
	 completion:^(BOOL finished){
		 // beforeAnimation
		 
		 // Animation
		 [UIView 
		  animateWithDuration:6.0
		  delay:0.0
		  options:UIViewAnimationCurveEaseInOut
		  animations:^{ /* ken animations */
			  
			  if (imageShowing == 1) {
				  picImageView1.transform = [self getAfterTransformWithWidth:picImageView1.image.size.width
																   height:picImageView1.image.size.height];
			  } else {
				  picImageView2.transform = [self getAfterTransformWithWidth:picImageView2.image.size.width
																   height:picImageView2.image.size.height];
			  }
			  
			  
		  }
		  completion:^(BOOL finished){
			  
		  }];
	 }
	 ];
	
}


@end