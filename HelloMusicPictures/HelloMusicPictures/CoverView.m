//
//  CoverView.m
//  HelloMusicPictures
//
//  Created by 오 화종 on 11. 11. 14.
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"cover view touch");
	[[self superview] touchesBegan:touches withEvent:event];
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"cover view touch end");
	[[self superview] touchesEnded:touches withEvent:event];	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
