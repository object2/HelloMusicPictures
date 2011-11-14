//
//  UIControl+disappearGUI.m
//  HelloMusicPictures
//
//  Created by 오 화종 on 11. 11. 14.
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "UIControl+disappearGUI.h"

@implementation UIControl (disappearGUI)

-(void) fireNotification:(id)sender
{
	NSLog(@"fireNotification %@", [self class]);
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"helloworld" object:nil userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"helloworld" object:nil];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self){
		[self addTarget:self action:@selector(fireNotification:) forControlEvents:UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(fireNotification:) forControlEvents:UIControlEventTouchCancel];
		[self addTarget:self action:@selector(fireNotification:) forControlEvents:UIControlEventValueChanged];
	}
	return self;
}

@end
