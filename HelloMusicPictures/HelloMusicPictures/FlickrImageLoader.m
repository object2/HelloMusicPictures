//
//  FlickrImageLoader.m
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 17..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "FlickrImageLoader.h"
#import "FlickrAPIKey.h"

@implementation FlickrImageLoader

@synthesize flickrContext, flickrRequest ,responseDict;

- (id)init
{
	self = [super init];
	if (self) {
		
		self.flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
		self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		[flickrRequest setDelegate:self];
	}
	return self;
}

#pragma mark - Flickr
- (void)loadImages:(NSString *)keyword 
{
//	NSLog(@"Searching photo with '%@'", keyword);
	// License
	// id 4 : Attribution  : 상업적 사용 O, 수정 O, 공유 O
	// id 6 : A.. NoDerivs : 상업적 사용 O, 수정 X, 공유 O
	// id 3 : A.. NonComm, NoDrivs : 상업적 사용 X, 수정 X, 공유 O
	// id 2 : A.. NonComm : 상업적 사용 X, 수정 O, 공유 O
	// id 1 : A.. NonComm Share : 상업적 사용 X, 수정 O, 공유 O (수정 시 동일 라이선스 유지)
	// id 5 : A.. Share : 상업적 사용 O, 수정 O, 공유 O (수정 시 동일 라이선스 유지)
	// id 7 : 라이선스 정보 없음 : public domain?
	
	if (![flickrRequest isRunning]) {
		[flickrRequest callAPIMethodWithGET:@"flickr.photos.search" 
								  arguments:[NSDictionary dictionaryWithObjectsAndKeys:keyword, @"text", keyword, @"tags",
											 [NSString stringWithFormat:@"%d",ImageCacheCount], @"per_page", @"4, 6, 5, 7", @"license", nil]];
	} else {
		NSLog(@"flickrRequest is running");
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	self.responseDict = inResponseDictionary;
//	NSLog(@"response %@", inResponseDictionary.textContent);
	numOfPictures = [[responseDict valueForKeyPath:@"photos.photo"] count];
	
	for (NSDictionary *photoDict in [responseDict valueForKeyPath:@"photos.photo"]) {
		NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:@""];
		[self loadImageWithUrl:photoURL];
	}
	
	
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	NSLog(@"Error! %@ , %@", inRequest.description, inError.description);
	
}


@end
