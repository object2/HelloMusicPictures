//
// SnapAndRunViewController.m
//
// Copyright (c) 2009 Lukhnos D. Liu (http://lukhnos.org)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "SnapAndRunViewController.h"
#import "SnapAndRunAppDelegate.h"

NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
NSString *kShowPictureStep = @"kShowPictureSte";
NSInteger numOfPictures = 0;
NSInteger curPictureIdx = 0;

@interface SnapAndRunViewController (PrivateMethods)
- (void)updateUserInterface:(NSNotification *)notification;
@end


@implementation SnapAndRunViewController

@synthesize nextPicTimer;

- (void)viewDidUnload
{
    self.flickrRequest = nil;
    self.imagePicker = nil;
    
    self.authorizeButton = nil;
    self.authorizeDescriptionLabel = nil;
    self.snapPictureButton = nil;
    self.snapPictureDescriptionLabel = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self viewDidUnload];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Snap and Run";
	
	if ([[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
		authorizeButton.enabled = NO;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUserInterface:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateUserInterface:(NSNotification *)notification
{
	if ([[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]) {		
		[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateNormal];
		[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateHighlighted];
		[authorizeButton setTitle:@"Reauthorize" forState:UIControlStateDisabled];		
		
		if ([[SnapAndRunAppDelegate sharedDelegate].flickrUserName length]) {
			authorizeDescriptionLabel.text = [NSString stringWithFormat:@"You are %@", [SnapAndRunAppDelegate sharedDelegate].flickrUserName];
		}
		else {
			authorizeDescriptionLabel.text = @"You've logged in";
		}
		
		snapPictureButton.enabled = YES;
	}
	else {
		[authorizeButton setTitle:@"Authorize" forState:UIControlStateNormal];
		[authorizeButton setTitle:@"Authorize" forState:UIControlStateHighlighted];
		[authorizeButton setTitle:@"Authorize" forState:UIControlStateDisabled];
		
		authorizeDescriptionLabel.text = @"Login to Flickr";		
		snapPictureButton.enabled = NO;
	}
	
	if ([self.flickrRequest isRunning]) {
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateHighlighted];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateDisabled];
		authorizeButton.enabled = NO;
	}
	else {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateDisabled];
			snapPictureDescriptionLabel.text = @"Use camera";
		}
		else {
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateDisabled];						
			snapPictureDescriptionLabel.text = @"Pick from library";
		}
		
		authorizeButton.enabled = YES;
	}
}

#pragma mark Actions

- (IBAction)showPictureAction
{
	NSString *keyword = [keywordTextField text];
	[keywordTextField resignFirstResponder];
	if ([keyword length] < 1) {
		keyword = @"music";
	}
	self.flickrRequest.sessionInfo = kShowPictureStep;

	// http://www.flickr.com/services/api/flickr.photos.search.html
	
	if (![flickrRequest isRunning]) {
		[flickrRequest callAPIMethodWithGET:@"flickr.photos.search" 
								  arguments:[NSDictionary dictionaryWithObjectsAndKeys:keyword, @"text", keyword, @"tags", @"10", @"per_page", nil]];
	}
}

- (IBAction)snapPictureAction
{
	if ([self.flickrRequest isRunning]) {
		[self.flickrRequest cancel];
		[self updateUserInterface:nil];		
		return;
	}
	
    [self presentModalViewController:self.imagePicker animated:YES];
}

- (IBAction)authorizeAction
{
    // if there's already OAuthToken, we want to reauthorize
    if ([[SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
        [[SnapAndRunAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    }
    
	authorizeButton.enabled = NO;
	authorizeDescriptionLabel.text = @"Authenticating...";    

    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
}

#pragma mark OFFlickrAPIRequest delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    [SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [SnapAndRunAppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;

    NSURL *authURL = [[SnapAndRunAppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
		snapPictureDescriptionLabel.text = @"Setting properties...";

        
        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];

        flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"Snap and Run", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];        		        
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		[self updateUserInterface:nil];		
		snapPictureDescriptionLabel.text = @"Done";
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;		
        
    }
	else if(inRequest.sessionInfo == kShowPictureStep) {
		[responseDict release];
		responseDict = [inResponseDictionary retain];
		NSLog(@"response %@", inResponseDictionary.textContent);
//		numOfPictures = [[responseDict valueForKeyPath:@"photos.photo"] count];
		numOfPictures = 10;
		
		
		NSLog(@"count is %d", [[responseDict valueForKeyPath:@"photos.photo"] count]);
		if (numOfPictures > 0) {

			self.nextPicTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showNextPicture) userInfo:nil repeats:YES];
			[nextPicTimer fire];

		}
		
	}
}

- (void)showNextPicture
{
	if (responseDict == Nil) {
		NSLog(@"responseDict is nil");
	}
	NSDictionary *photoDict = [[responseDict valueForKeyPath:@"photos.photo"] objectAtIndex:curPictureIdx];
	NSURL *photoURL = [[SnapAndRunAppDelegate sharedDelegate].flickrContext
					   photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
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
	
	[webView loadHTMLString:htmlSource baseURL:nil];

	curPictureIdx++;
	if (curPictureIdx >= numOfPictures) {
		curPictureIdx = 0;
	}
	
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
		[self updateUserInterface:nil];
		snapPictureDescriptionLabel.text = @"Failed";		
		[UIApplication sharedApplication].idleTimerDisabled = NO;

		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];

	}
	else {
		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes) {
		snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else {
		snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%lu/%lu (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)_startUpload:(UIImage *)image
{
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
	snapPictureButton.enabled = NO;
	snapPictureDescriptionLabel.text = @"Uploading";
	
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"Snap and Run Demo" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self updateUserInterface:nil];
}

#ifndef __IPHONE_3_0
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//  NSDictionary *editingInfo = info;
#else
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
#endif

    [self dismissModalViewControllerAnimated:YES];
	
	snapPictureDescriptionLabel.text = @"Preparing...";
	
	// we schedule this call in run loop because we want to dismiss the modal view first
	[self performSelector:@selector(_startUpload:) withObject:image afterDelay:0.0];
}

#pragma mark Accesors

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[SnapAndRunAppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (UIImagePickerController *)imagePicker
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
    }
    return imagePicker;
}

#ifndef __IPHONE_3_0
- (void)setView:(UIView *)view
{
	if (view == nil) {
		[self viewDidUnload];
	}
	
	[super setView:view];
}
#endif

@synthesize flickrRequest;
@synthesize imagePicker;

@synthesize authorizeButton;
@synthesize authorizeDescriptionLabel;
@synthesize snapPictureButton;
@synthesize snapPictureDescriptionLabel;
	
@synthesize keywordTextField, showPictureButton, webView, responseDict;	
@end
