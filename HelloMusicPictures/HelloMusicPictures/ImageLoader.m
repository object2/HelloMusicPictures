//
//  ImageLoader.m
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 8..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "ImageLoader.h"


@implementation ImageLoader
@synthesize completeWithResponse, images;
- (id)init
{
	self = [super init];
	if (self) {
		
		curPictureIdx = -1;
		numOfPictures = 0;
	}
	return self;
}



- (UIImage*)nextImage
{
	if ([images count] == 0)
		return nil;
	curPictureIdx = (curPictureIdx+1)%[images count];
//	NSLog(@"nextImage..  idx is %d", curPictureIdx);
	return [images objectAtIndex:curPictureIdx];
}


- (void)loadImageWithUrl:(NSURL *)imageUrl
{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
		NSData* imageData = [[ImageCaching sharedInstance] LoadImageDataCacheWithUrl:imageUrl.absoluteString];
		if (!imageData) {
			imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
			[[ImageCaching sharedInstance] addImageData:imageData Url:imageUrl.absoluteString];
//			NSLog(@"imageData loading");
		}
		
		UIImage* image = [[UIImage alloc] initWithData:imageData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [images addObject:image]; //UIImageView
			if ([images count] == 1) {
				completeWithResponse();
				
			}
        });
    });
}

- (NSInteger)numOfPictures
{
	return numOfPictures;
}
- (void)loadImages:(NSString *)keyword completion:(CompleteWithResponse)completion
{
	
	self.completeWithResponse = completion;
	self.images = [[NSMutableArray alloc] init];
	curPictureIdx = -1;
	[self loadImages:keyword];
}

- (void)loadImages:(NSString *)keyword
{
	[NSException raise:@"ImageLoader LoadImages" format:nil];
}


@end
