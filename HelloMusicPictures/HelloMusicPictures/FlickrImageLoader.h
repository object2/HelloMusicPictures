//
//  FlickrImageLoader.h
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 17..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoader.h"
#import "ObjectiveFlickr.h"

@interface FlickrImageLoader : ImageLoader <OFFlickrAPIRequestDelegate>
{
	// for Flickr
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
	
}
@property (nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, strong) OFFlickrAPIContext *flickrContext;
@property (nonatomic, strong) NSDictionary *responseDict;
- (void)loadImages:(NSString *)keyword;

@end
