//
//  ImageLoader.h
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 8..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCaching.h"

typedef void (^CompleteWithResponse)();
@interface ImageLoader : NSObject 
{
	NSMutableArray *images;
	NSInteger curPictureIdx;
	NSInteger numOfPictures;
}

@property (nonatomic, copy) CompleteWithResponse completeWithResponse;
@property (nonatomic, retain) NSMutableArray *images;

- (void)loadImageWithUrl:(NSURL *)imageUrl;
- (void)loadImages:(NSString *)keyword;
- (void)loadImages:(NSString *)keyword completion:(CompleteWithResponse)completion;
- (UIImage*)nextImage;
- (NSInteger)numOfPictures;
@end
