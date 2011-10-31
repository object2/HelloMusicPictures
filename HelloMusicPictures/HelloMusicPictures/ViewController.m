//
//  ViewController.m
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import "ViewController.h"
#import "FlickrAPIKey.h"


@implementation ViewController

@synthesize picImageView, flickrContext, flickrRequest;
@synthesize nextPicTimer, responseDict;
@synthesize musicPlayer;
@synthesize pauseStart, previousFireDate;

NSInteger numOfPictures = 0;
NSInteger curPictureIdx = 0;


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
	} else {
		
		[playPauseButton setTitle:@"재생" forState:UIControlStateNormal];
	}

	
	
	[self registerMediaPlayerNotifications];
	
	self.flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
	self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
	
	[flickrRequest setDelegate:self];
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
        titleLabel.text = [NSString stringWithFormat:@"Title: %@",titleString];
    } else {
        titleLabel.text = @"Title: Unknown title";
    }
	
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        artistLabel.text = [NSString stringWithFormat:@"Artist: %@",artistString];
    } else {
        artistLabel.text = @"Artist: Unknown artist";
    }
	
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        albumLabel.text = [NSString stringWithFormat:@"Album: %@",albumString];
    } else {
        albumLabel.text = @"Album: Unknown album";
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
	
	[self showPictureWithKeyword:keyword];


	
	
	

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
	MPMediaPickerController *picker =
			[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
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


#pragma mark - Flickr
- (void)showPictureWithKeyword:(NSString *)keyword
{

	NSLog(@"Searching photo with '%@'", keyword);
	
	if (![flickrRequest isRunning]) {
		[flickrRequest callAPIMethodWithGET:@"flickr.photos.search" 
								  arguments:[NSDictionary dictionaryWithObjectsAndKeys:keyword, @"text", keyword, @"tags", @"20", @"per_page", nil]];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	
	self.responseDict = inResponseDictionary;
	NSLog(@"response %@", inResponseDictionary.textContent);
	numOfPictures = [[responseDict valueForKeyPath:@"photos.photo"] count];
	//NSLog(@"numOfPictures = %d", numOfPictures);
	//numOfPictures = 10;
	
	
	NSLog(@"count is %d", [[responseDict valueForKeyPath:@"photos.photo"] count]);
	if (numOfPictures > 0) {
		
		curPictureIdx = 0;
		

		[self showNextPicture];
		self.nextPicTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(showNextPicture) userInfo:nil repeats:YES];
		[nextPicTimer fire];
		
	}

}

- (void)showNextPicture
{
	if (responseDict == Nil) {
		NSLog(@"responseDict is nil");
	}
	NSDictionary *photoDict = [[responseDict valueForKeyPath:@"photos.photo"] objectAtIndex:curPictureIdx];
	NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:@""];
	
	NSLog(@"showing %@", photoURL);
	[self loadImageWithUrl:photoURL];
	
	curPictureIdx++;
	if (curPictureIdx >= numOfPictures) {
		curPictureIdx = 0;
	}

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



- (void)restartShowPicture
{
	NSLog(@"restart pic");
	float pauseTime = -1 * [pauseStart timeIntervalSinceNow];
	
	[nextPicTimer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];

}
	
// 네트워크를 통해 이미지를 매번 불러옴
// 개선방향 : 목록에 있는 이미지를 순차적으로 로딩하여 캐싱한 후 불러오도록 수정
- (void)loadImageWithUrl:(NSURL *)imageUrl {
	NSData* imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}


- (void)displayImage:(UIImage *)image {
	[picImageView setImage:image]; //UIImageView
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
}

@end