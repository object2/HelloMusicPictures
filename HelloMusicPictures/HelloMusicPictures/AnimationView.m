//
//  AnimationView.m
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 12. 12..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "AnimationView.h"
#import "ImageLoader.h"
#import <QuartzCore/QuartzCore.h>

#define L_WIDTH 1024
#define L_HEIGHT 748
#define P_WIDTH 768
#define P_HEIGHT 1004


#pragma mark - PlayImageView

@implementation PlayImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	imageEffectFlag = 1.0;
	return self;
}

- (CGAffineTransform)getBeforeTransformWithWidth:(CGFloat)width height:(CGFloat)height
{
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
		if(width / height > 1.6) {
			//float aspectRatio = L_HEIGHT / height;
			int dx = (width * L_HEIGHT / height - L_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * imageEffectFlag, 0);
			NSLog(@"Moving hor");
			
		} else if(width / height < 0.8) {
			int dy = (height * L_WIDTH / width - L_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * imageEffectFlag); // 임시
			NSLog(@"Moving ver %d", dy);
		} else {
			transform = CGAffineTransformMakeScale(1.4, 1.4);	
		}
		
	} else {
		if(width / height > 1.2) {
			//float aspectRatio = P_HEIGHT / height;
			int dx = (width * P_HEIGHT / height - P_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * imageEffectFlag, 0);
			
		} else if(width / height < 0.6) {
			int dy = (height * P_WIDTH / width - P_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * imageEffectFlag); // 임시
			
		} else {
			transform = CGAffineTransformMakeScale(1.4, 1.4);	
		}
		
	}
	
	return transform;
}

- (CGAffineTransform)getAfterTransformWithWidth:(CGFloat)width height:(CGFloat)height
{
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ) {
		if(width / height > 1.6) {
			//float aspectRatio = L_HEIGHT / height;
			imageEffectFlag = imageEffectFlag * -1;
			int dx = (width * L_HEIGHT / height - L_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * imageEffectFlag, 0);
			
		} else if(width / height < 0.8) {
			imageEffectFlag = imageEffectFlag * -1;
			int dy = (height * L_WIDTH / width - L_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * imageEffectFlag);
			
		} else {
			transform = CGAffineTransformIdentity;
			
		}
		
	} else {
		if(width / height > 1.2) {
			//float aspectRatio = P_HEIGHT / height;
			imageEffectFlag = imageEffectFlag * -1;
			int dx = (width * P_HEIGHT / height - P_WIDTH) / 2.0;
			transform = CGAffineTransformMakeTranslation(dx * imageEffectFlag, 0);
			
		} else if(width / height < 0.6) {
			imageEffectFlag = imageEffectFlag * -1;
			int dy = (height * P_WIDTH / width - P_HEIGHT) / 2.0;
			transform = CGAffineTransformMakeTranslation(0, dy * imageEffectFlag); 
			
		} else {
			transform = CGAffineTransformIdentity;
		}
		
	}
	
	return transform;
	
	
}

-(void) setAfterTransformWithViewController
{
	self.transform = [self getAfterTransformWithWidth:self.image.size.width height:self.image.size.height];
}

-(void) loadNextImageWithImageLoader:(ImageLoader*)anImageLoader
{
	self.image = [anImageLoader nextImage];
	self.transform = [self getBeforeTransformWithWidth:self.image.size.width height:self.image.size.height];
}

-(void) stopAllAnimation
{
	[self.layer removeAllAnimations];
	self.transform = CGAffineTransformIdentity;	
}

@end


@implementation AnimationView

@synthesize picImageView1, picImageView2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		NSLog(@"test");
		imageEffectFlag = 1.0;
		picImageView1 = [[PlayImageView alloc] initWithFrame:self.frame];
		[picImageView1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
		[picImageView1 setContentMode:UIViewContentModeScaleAspectFill];
		picImageView2 = [[PlayImageView alloc] initWithFrame:self.frame];
		[picImageView2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
		[picImageView2 setContentMode:UIViewContentModeScaleAspectFill];
		[self addSubview:picImageView1];
		[self addSubview:picImageView2];
		
	}
	return self;
}

- (BOOL) hasImage
{
	return (BOOL)picImageView1.image;
}

- (void)toggleAlpha
{
	if (picImageView1.alpha == 1.0) {
		picImageView1.alpha = 0.0;
		picImageView2.alpha = 1.0;
	} else {
		picImageView1.alpha = 1.0;
		picImageView2.alpha = 0.0;
	}
}

- (void)toggleShowing
{
	imageShowing = (imageShowing == 1) ? 2: 1;
}

- (void)startSlideshow:(NSTimer*)aTimer
{
	// beforeAnimation
	[[self notShowingPicImageView] loadNextImageWithImageLoader:[aTimer userInfo]];
	
	[self toggleShowing];
	
	
	
	// Animation
	[UIView 
	 animateWithDuration:2.0 
	 //  delay:1.0
	 //options:UIViewAnimationCurveLinear
	 animations:^{ /* fade animations */ 
		 [self toggleAlpha];
	 } 
	 completion:^(BOOL finished){
		 // beforeAnimation
		 
		 // Animation
		 [UIView 
		  animateWithDuration:6.0
		  delay:0.0
		  options:UIViewAnimationCurveEaseInOut
		  animations:^{ /* ken animations */
			  [[self showingPicImageView] setAfterTransformWithViewController];
		  }
		  completion:^(BOOL finished){
			  
		  }];
	 }
	 ];
	
}

-(PlayImageView*) showingPicImageView
{
	if (imageShowing == 1) {
		return picImageView1;
	}
	return picImageView2;
}

-(PlayImageView*) notShowingPicImageView
{
	if (imageShowing == 1) {
		return picImageView2;
	}
	return picImageView1;
}

- (void)setAnimationImage:(UIImage*)aImage
{
	imageShowing = 1;
	picImageView1.alpha = 1.0;
	picImageView2.alpha = 0.0;
	
	
	picImageView1.image = aImage;

}


@end
