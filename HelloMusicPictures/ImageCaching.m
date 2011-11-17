//
//  ImageCaching.m
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 11. 16..
//  Copyright 2011년 TEAMBLACKCAT. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "ImageCaching.h"

static ImageCaching *_instance;
@implementation ImageCaching

@synthesize imageDatas;

#pragma mark -
#pragma mark Singleton Methods

+ (ImageCaching*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            // Allocate/initialize any member variables of the singleton class here
            // example
			//_instance.member = @"";
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here

- (id)init
{
	self = [super init];
	
	if (self) 
	{
		defaluts = [NSUserDefaults standardUserDefaults];
		NSDictionary *imageCacheDatas = [defaluts objectForKey:@"imageCacheDatas"];
		if (imageCacheDatas) {
			self.imageDatas = [NSMutableDictionary dictionaryWithDictionary:imageCacheDatas];
		}
		else
			self.imageDatas = [NSMutableDictionary dictionary];
		
	}
	return self;
}

- (NSData*)LoadImageDataCacheWithUrl:(NSString*)aUrl
{
	return [imageDatas objectForKey:aUrl];
}

- (void)addImageData:(NSData*)data Url:(NSString*)aUrl
{
	int imageDatasCount = [imageDatas count];
	if ( imageDatasCount > ImageCacheCount*2-1) {
		
		int removekeyscount = imageDatasCount - (ImageCacheCount-1);
		NSMutableArray * removekeys = [NSMutableArray array];
		for (int i = 0; i<removekeyscount; i++) 
		{
			[removekeys addObject:[[imageDatas allKeys] objectAtIndex:i]];
		}
		
		[imageDatas removeObjectsForKeys:removekeys];
	}
	[imageDatas setObject:data forKey:aUrl];
	NSLog(@"%d",[imageDatas count]);
}

- (void)save
{
	[defaluts setObject:imageDatas forKey:@"imageCacheDatas"];
	[defaluts synchronize];
}

@end