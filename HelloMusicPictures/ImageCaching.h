//
//  ImageCaching.h
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 16..
//  Copyright 2011년 TEAMBLACKCAT. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>

#define ImageCacheCount 20

@interface ImageCaching : NSObject {
	NSUserDefaults *defaluts;
	NSMutableDictionary *imageDatas;
}

+ (ImageCaching*) sharedInstance;

@property (nonatomic,retain) NSMutableDictionary *imageDatas;

- (NSData*)LoadImageDataCacheWithUrl:(NSString*)aUrl;
- (void)addImageData:(NSData*)data Url:(NSString*)aUrl;
- (void)save;
@end
