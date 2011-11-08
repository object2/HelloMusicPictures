//
//  ImageLoader.h
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 8..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"
typedef void (^CompleteWithResponse)();
@interface ImageLoader : NSObject <OFFlickrAPIRequestDelegate>
{
	NSMutableArray *images;
	
	// for Flickr
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
	NSInteger curPictureIdx;
	NSInteger numOfPictures;
}

@property (nonatomic, copy) CompleteWithResponse completeWithResponse;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;
@property (nonatomic, strong) NSDictionary *responseDict;

- (void)loadImages:(NSString *)keyword completion:(CompleteWithResponse)completion;
- (UIImage*)nextImage;
@end
