//
//  ViewController.h
//  HelloMusicPictures
//
//  Created by 최 민규 on 11. 10. 17..
//  Copyright (c) 2011 TEAMBLACKCAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ObjectiveFlickr.h"


@interface ViewController : UIViewController <MPMediaPickerControllerDelegate, OFFlickrAPIRequestDelegate>
{
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
	IBOutlet UIWebView *webView;
}
- (IBAction)showMediaPlayer:(id)sender;
- (void)showPhotoWithKeyword:(NSString *)keyword;

@property (nonatomic, readonly)OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain)OFFlickrAPIRequest *flickrRequest;

@end
