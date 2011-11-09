//
//  ImageLoader.m
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 8..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "ImageLoader.h"
#import "FlickrAPIKey.h"

@implementation ImageLoader
@synthesize flickrContext, flickrRequest, responseDict, completeWithResponse, images;
- (id)init
{
	self = [super init];
	if (self) {
		
		curPictureIdx = -1;
		numOfPictures = 0;
		
		self.flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
		self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
		[flickrRequest setDelegate:self];
	}
	return self;
}



- (UIImage*)nextImage
{
	if ([images count] == 0)
		return nil;
	curPictureIdx = (curPictureIdx+1)%[images count];
	NSLog(@"nextImage..  idx is %d", curPictureIdx);
	return [images objectAtIndex:curPictureIdx];
}


- (void)loadImageWithUrl:(NSURL *)imageUrl
{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
		NSData* imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
		UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [images addObject:image]; //UIImageView
			if ([images count] == 1) {
				NSLog(@"Noti 보내염");
				[[NSNotificationCenter defaultCenter] postNotificationName:@"imageReadyNotification" object:nil];
			}
			NSLog(@"addObject:image %@", imageUrl.absoluteString);
        });
    });
}

#pragma mark - Flickr
- (void)loadImages:(NSString *)keyword completion:(CompleteWithResponse)completion
{
	
	self.completeWithResponse = completion;
	NSLog(@"Searching photo with '%@'", keyword);
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
											 @"20", @"per_page", @"4, 6, 5, 7", @"license", nil]];
	} else {
		NSLog(@"flickrRequest is running");
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
	self.images = [[NSMutableArray alloc] init];
	self.responseDict = inResponseDictionary;
	NSLog(@"response %@", inResponseDictionary.textContent);
	numOfPictures = [[responseDict valueForKeyPath:@"photos.photo"] count];
	
	for (NSDictionary *photoDict in [responseDict valueForKeyPath:@"photos.photo"]) {
		NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:@""];
		[self loadImageWithUrl:photoURL];
	}
	
	curPictureIdx = -1;
	completeWithResponse();
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	NSLog(@"Error! %@ , %@", inRequest.description, inError.description);
	
}

- (NSInteger)numOfPictures
{
	return numOfPictures;
}




@end
