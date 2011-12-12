//
//  ViewController.m
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import "ViewController.h"
#import "MPMediaPickerControllerLandScape.h"
#import "FlickrImageLoader.h"
#import <Twitter/TWTweetComposeViewController.h> 



#define GUI_TIME 7.0f
#define GUI_ALPHA 1.0f

#define PROGRESS_BAR_LENGTH 858



#pragma mark - ViewController


@implementation ViewController

@synthesize controlsHideTimer;
//@synthesize picImageView1, picImageView2;
@synthesize progressBar, progressTimer;
@synthesize nextPicTimer;
@synthesize musicPlayer;
@synthesize pauseStart, previousFireDate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)dealloc
{
	self.controlsHideTimer = nil;
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

-(void) twoFingerSwipeUp:(id)sender
{
	[self showMediaPickerViewController:nil];
}

-(void)swipeNextSong:(id)sender
{
	[self nextSong:nil];
}

-(void)swipePrevSong:(id)sender
{
	[self previousSong:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	swipeRecog = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerSwipeUp:)];
	swipeRecog.numberOfTouchesRequired = 2;
	swipeRecog.direction = UISwipeGestureRecognizerDirectionUp;
	[self.view addGestureRecognizer: swipeRecog];
	
	
	swipeRecogRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeNextSong:)];
	swipeRecogRight.numberOfTouchesRequired = 2;
	swipeRecogRight.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipeRecogRight];
	
	swipeRecogLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipePrevSong:)];
	swipeRecogLeft.numberOfTouchesRequired = 2;
	swipeRecogLeft.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipeRecogLeft];
	
	
	
	// Do any additional setup after loading the view, typically from a nib.
	musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	[volumeSlider setValue:[musicPlayer volume]];
	
	
	if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
		[self setPlayButtonToPause];
//		[playPauseButton setTitle:@"일시정지" forState:UIControlStateNormal];
	}else {
		[self setPauseButtonToPlay];
//		[playPauseButton setTitle:@"재생" forState:UIControlStateNormal];
	}

	
	
	[self registerMediaPlayerNotifications];
	imageLoader = [[FlickrImageLoader alloc] init];
	
	[self.view setMultipleTouchEnabled: YES];
}

- (void)viewDidUnload
{
	controls = nil;
	aniView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) extendControlsHidingTimer
{
	[self.controlsHideTimer invalidate];
	self.controlsHideTimer = [NSTimer scheduledTimerWithTimeInterval:GUI_TIME target:self selector:@selector(onControlsHidingTimerEvent:) userInfo:nil repeats:NO];
}

-(void) animateControlsWithAlpha:(CGFloat)aFloat
{
	[UIView 
	 animateWithDuration:0.5
	 delay:0.0
	 options:UIViewAnimationCurveEaseOut
	 animations:^{		
		 [controls setAlpha: aFloat];
	 }
	 completion:^(BOOL finished){
	 }];
}

-(void) onControlsHidingTimerEvent:(NSTimer*)aTimer
{
	[self.controlsHideTimer invalidate];
	self.controlsHideTimer = nil;
	[self animateControlsWithAlpha:0.0f];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.controlsHideTimer != nil) {
		[self onControlsHidingTimerEvent:nil];
	}else
	{
		[self animateControlsWithAlpha:GUI_ALPHA];
		[self extendControlsHidingTimer];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[controls setAlpha: 0.0];
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


// 기기가 회전하면 애니매이션 중인 이미지가 깨지지 않도록 애니매이션이 멈추고 이미지 transform을 보정한다
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[[aniView showingPicImageView] stopAllAnimation];
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


// 음악이 바뀌면
- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
	
	if (currentItem == nil) 
		return; //곡이 없으면 스킵
	
	[self displayMusicInfo:currentItem];
	
	// 음악 진행바
	[progressTimer invalidate];
	progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self 
												   selector:@selector(updateProgressBar) 
												   userInfo:nil repeats:YES];
	

	
	
	
	
	if (![aniView hasImage]) 
	{
		MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
		[aniView setAnimationImage:[artwork imageWithSize:artwork.bounds.size]];
	}
	
	
	// 키워드를 걸러냄
	NSString *filteredKeyword = [self makeKeywordWithItem:currentItem];


	// 이미지 불러오기
	[imageLoader loadImages:filteredKeyword completion:^{
		NSLog(@"load completed");
		
		[aniView setAnimationImage:[imageLoader nextImage]];

		[nextPicTimer invalidate];
		self.nextPicTimer = [NSTimer scheduledTimerWithTimeInterval:9.2 target:aniView selector:@selector(startSlideshow:) 
														   userInfo:imageLoader repeats:YES];
		
		MPMusicPlaybackState playbackState = [musicPlayer playbackState];
		if (playbackState == MPMusicPlaybackStatePlaying) {
			[self.nextPicTimer fire];
		}
		else
		{
			[self pauseShowPicture];
		}
		
		
	}];
}


// 음악 정보 추출
- (void)displayMusicInfo:(MPMediaItem *)currentItem
{
	NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
	titleLabel.text = titleString?titleString:@"Unknown Title";
	
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
	artistLabel.text = artistString?artistString:@"Unknown Artist";
	
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
	albumLabel.text = albumString?albumString:@"Unknown Album";
	
	NSURL*     songURL = [currentItem valueForProperty:MPMediaItemPropertyAssetURL];
	AVAsset* songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
	NSString*   lyrics = [songAsset lyrics];
	
	if (lyrics.length > 10) {
		
		[lyricsView setHidden:NO];
		lyricsView.text = [NSString stringWithFormat:@"%@",lyrics];
		
		
	}else
	{
		[lyricsView setHidden:YES];
		lyricsView.text = @"가사가 없음..";
	}
}



- (void) handle_PlaybackStateChanged: (id) notification
{
	MPMusicPlaybackState playbackState = [musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
		[self setPauseButtonToPlay];
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[self setPlayButtonToPause];
		
	} else if (playbackState == MPMusicPlaybackStateStopped) {
		[self setPauseButtonToPlay];
		[musicPlayer stop];
		[self stopShowPicture];
		
	}
	

	
}

- (void)setPlayButtonToPause
{
	[playPauseButton setImage:[UIImage imageNamed:@"pause_icon_02"] forState:UIControlStateNormal];

}

- (void)setPauseButtonToPlay
{
	[playPauseButton setImage:[UIImage imageNamed:@"play_icon_02"] forState:UIControlStateNormal];
}

- (void) handle_VolumeChanged: (id) notification
{
    [volumeSlider setValue:[musicPlayer volume]];
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



// 음악 진행바 업데이트
- (void)updateProgressBar
{
	NSTimeInterval currentTime	= [musicPlayer currentPlaybackTime];
	NSTimeInterval fullTime		= [[[musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
	CGRect curFrame = [progressBar frame];
	curFrame.size.width = PROGRESS_BAR_LENGTH * currentTime / fullTime;
	[progressBar setFrame:curFrame];
	
	
}


#pragma mark - buttons


- (IBAction)showMediaPickerViewController:(id)sender
{
	[self extendControlsHidingTimer];
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

- (IBAction)volumeChanged:(id)sender
{
	[self extendControlsHidingTimer];
    [musicPlayer setVolume:[volumeSlider value]];
}

- (IBAction)playPause:(id)sender
{
	[self extendControlsHidingTimer];
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
	[self extendControlsHidingTimer];
    [musicPlayer skipToPreviousItem];
}

- (IBAction)nextSong:(id)sender
{
	[self extendControlsHidingTimer];
    [musicPlayer skipToNextItem];
}

- (IBAction)randomPlay:(id)sender
{	
	[self extendControlsHidingTimer];
	if(randomSwitch.on)
	{
		[musicPlayer setShuffleMode:MPMusicShuffleModeSongs];
		//[musicPlayer skipToNextItem];
	}
	else{
		[musicPlayer setShuffleMode:MPMusicShuffleModeDefault];
	}
}

- (IBAction)twit:(id)sender 
{
	[self extendControlsHidingTimer];
	if ([TWTweetComposeViewController canSendTweet]) 
	{
		TWTweetComposeViewController *twtCntrlr = [[TWTweetComposeViewController alloc] init];
		[twtCntrlr setInitialText:[NSString stringWithFormat:@"%@ - %@ #nowplaying #HellowMusicPicutures",titleLabel.text,artistLabel.text]];
		[self presentViewController:twtCntrlr animated:YES completion:^{ 
		}]; 
	}
	else
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
	}
}

#pragma mark - keyword

// 키워드에 불필요한 문자 제거
- (NSString *)removeSpecialCharacter:(NSString *)str
{
	NSString *result = nil;
	
	result = [[[[[str 
				  stringByReplacingOccurrencesOfString:@"(" withString:@" "] 
				 stringByReplacingOccurrencesOfString:@")" withString:@" "] 
				stringByReplacingOccurrencesOfString:@"  " withString:@" "] 
			   stringByReplacingOccurrencesOfString:@"'" withString:@""] 
			  stringByReplacingOccurrencesOfString:@"-" withString:@" "];
	
	return result;
}

// 키워드 뽑아내기
- (NSString *)makeKeywordWithItem:(MPMediaItem *)currentItem
{
	return [self makeKeywordWithTitle:[currentItem valueForProperty:MPMediaItemPropertyTitle]
							   artist:[currentItem valueForProperty:MPMediaItemPropertyArtist]
								//album:[currentItem valueForProperty:MPMediaItemPropertyAlbumTitle]
								album:@""]; // 앨범명 검색어에서 제외
}

// 키워드 뽑아내기
- (NSString *)makeKeywordWithTitle:(NSString*)title artist:(NSString *)artist album:(NSString*)album
{
	NSMutableArray *keywordList = [[NSMutableArray alloc] init];
	
	NSString *keyword = artist;
	
	keyword = [self removeSpecialCharacter:keyword];
	NSArray *keywordTmp = [keyword componentsSeparatedByString:@" "];
	
	for (int i = 0; i < keywordTmp.count; i++) {
		if ([[keywordTmp objectAtIndex:i] length] > 2) {
			[keywordList addObject:[keywordTmp objectAtIndex:i]];
		}
	}
	
	
	keyword = [self removeSpecialCharacter:title];
	keywordTmp = [keyword componentsSeparatedByString:@" "];
	
	for (int i = 0; i < keywordTmp.count; i++) {
		if ([[keywordTmp objectAtIndex:i] length] > 2) {
			[keywordList addObject:[keywordTmp objectAtIndex:i]];
		}
	}
	
	
	
	keyword = [self removeSpecialCharacter:album];
	keywordTmp = [keyword componentsSeparatedByString:@" "];
	
	for (int i = 0; i < keywordTmp.count; i++) {
		if ([[keywordTmp objectAtIndex:i] length] > 2) {
			[keywordList addObject:[keywordTmp objectAtIndex:i]];
		}
	}
	
	NSString *filteredKeyword = nil;
	
	// 쓸만한 키워드가 없으면 기본 검색어로
	if (keywordList.count < 1) {
		filteredKeyword = @"music";
	} else {
		
		// 검색어가 6개 이상이면 글자수가 많은 것만 취한다
		if (keywordList.count > 5 /* keyword limit */) { 
			NSLog(@"검색어가 %d개나 되어 짤라냅니다.", keywordList.count);
			NSLog(@"before: %@", [keywordList componentsJoinedByString:@", "]);
			NSSortDescriptor *sortDescriptor;
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
														 ascending:NO];
			NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			[keywordList sortUsingDescriptors:sortDescriptors];
			
			for (int i = keywordList.count - 1; i > 4/* keyword limit index */; i--) {
				[keywordList removeObjectAtIndex:i];
			}
			
			NSLog(@"after : %@", [keywordList componentsJoinedByString:@", "]);
			
			
		}
		
		
		NSLog(@"keword : %@", [keywordList componentsJoinedByString:@", "]);
		
		filteredKeyword = [keywordList componentsJoinedByString:@", "];
	}
	
	return filteredKeyword;
	
}




#pragma mark - Picture


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
	[self extendControlsHidingTimer];
	UIImageWriteToSavedPhotosAlbum([aniView showingPicImageView], self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
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


@end