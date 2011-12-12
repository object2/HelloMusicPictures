//
//  Keyword.h
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 12. 12..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Keyword : NSObject
+ (NSString *)makeKeywordWithItem:(MPMediaItem *)currentItem;
@end
