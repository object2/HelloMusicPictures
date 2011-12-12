//
//  AnimationView.h
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 12. 12..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageLoader;
@class ViewController;

@interface PlayImageView : UIImageView {
	CGFloat imageEffectFlag;
}
-(void) stopAllAnimation;
-(void) setAfterTransformWithViewController;
-(void) loadNextImageWithImageLoader:(ImageLoader*)anImageLoader;
@end


@interface AnimationView : UIView
{
	int imageShowing;
	CGFloat imageEffectFlag; // 화면 애니메이션에서 사용
	PlayImageView *picImageView1;
	PlayImageView *picImageView2;
}

@property (nonatomic, strong) UIImageView *picImageView2;
@property (nonatomic, strong) UIImageView *picImageView1;

- (BOOL)hasImage;
- (void)setAnimationImage:(UIImage*)aImage;
-(PlayImageView*) showingPicImageView;
-(PlayImageView*) notShowingPicImageView;
@end
