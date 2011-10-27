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

@synthesize picWebView, flickrContext, flickrRequest;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
	self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
//	[flickrContext set
	
	[flickrRequest setDelegate:self];
	
//	[self nextRandomPhotoAction:self];
	
//	[[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(nextRandomPhotoAction:) userInfo:nil repeats:YES] fire];
	
//	[webView setDrawsBackground:NO];
	
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
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	NSLog(@"음악선택 포기");
}

#pragma mark - Flickr
- (void)showPictureWithKeyword:(NSString *)keyword
{
	if (![flickrRequest isRunning]) {
		[flickrRequest callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"per_page", nil]];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:0];
	
	NSString *title = [photoDict objectForKey:@"title"];
	if (![title length]) {
		title = @"No title";
	}
	
//	NSURL *photoSourcePage = [flickrContext photoWebPageURLFromDictionary:photoDict];
//	NSDictionary *linkAttr = [NSDictionary dictionaryWithObjectsAndKeys:photoSourcePage, NSLinkAttributeName, nil];
//	NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:title attributes:linkAttr] autorelease];	
//	[[textView textStorage] setAttributedString:attrString];
	
	NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
	NSString *htmlSource = [NSString stringWithFormat:
							@"<html>"
							@"<head>"
							@"  <style>body { margin: 0; padding: 0; } </style>"
							@"</head>"
							@"<body>"
							@"  <table border=\"0\" align=\"center\" valign=\"center\" cellspacing=\"0\" cellpadding=\"0\" height=\"240\">"
							@"    <tr><td><img src=\"%@\" /></td></tr>"
							@"  </table>"
							@"</body>"
							@"</html>"
							, photoURL];
	
	[picWebView loadHTMLString:htmlSource baseURL:nil];
	

}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
}

@end