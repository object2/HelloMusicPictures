//
//  Keyword.m
//  HelloMusicPictures
//
//  Created by hongjun kim on 11. 12. 12..
//  Copyright (c) 2011년 TEAMBLACKCAT. All rights reserved.
//

#import "Keyword.h"

@implementation Keyword

#pragma mark - keyword

// 키워드에 불필요한 문자 제거
+ (NSString *)removeSpecialCharacter:(NSString *)str
{
	NSString *result = nil;
	
	result = [[[[[str 
				  stringByReplacingOccurrencesOfString:@"(" withString:@" "] 
				 stringByReplacingOccurrencesOfString:@")" withString:@" "] 
				stringByReplacingOccurrencesOfString:@"  " withString:@" "] 
			   stringByReplacingOccurrencesOfString:@"'" withString:@""] 
			  stringByReplacingOccurrencesOfString:@"-" withString:@" "];
	
	return result;
}


// 키워드 뽑아내기
+ (NSString *)makeKeywordWithTitle:(NSString*)title artist:(NSString *)artist album:(NSString*)album
{
	NSMutableArray *keywordList = [[NSMutableArray alloc] init];
	
	NSString *keyword = artist;
	
	keyword = [self removeSpecialCharacter:keyword];
	NSArray *keywordTmp = [keyword componentsSeparatedByString:@" "];
	
	for (int i = 0; i < keywordTmp.count; i++) {
		if ([[keywordTmp objectAtIndex:i] length] > 2) {
			[keywordList addObject:[keywordTmp objectAtIndex:i]];
		}
	}
	
	
	keyword = [self removeSpecialCharacter:title];
	keywordTmp = [keyword componentsSeparatedByString:@" "];
	
	for (int i = 0; i < keywordTmp.count; i++) {
		if ([[keywordTmp objectAtIndex:i] length] > 2) {
			[keywordList addObject:[keywordTmp objectAtIndex:i]];
		}
	}
	
	
	
	keyword = [self removeSpecialCharacter:album];
	keywordTmp = [keyword componentsSeparatedByString:@" "];
	
	for (int i = 0; i < keywordTmp.count; i++) {
		if ([[keywordTmp objectAtIndex:i] length] > 2) {
			[keywordList addObject:[keywordTmp objectAtIndex:i]];
		}
	}
	
	NSString *filteredKeyword = nil;
	
	// 쓸만한 키워드가 없으면 기본 검색어로
	if (keywordList.count < 1) {
		filteredKeyword = @"music";
	} else {
		
		// 검색어가 6개 이상이면 글자수가 많은 것만 취한다
		if (keywordList.count > 5 /* keyword limit */) { 
			NSLog(@"검색어가 %d개나 되어 짤라냅니다.", keywordList.count);
			NSLog(@"before: %@", [keywordList componentsJoinedByString:@", "]);
			NSSortDescriptor *sortDescriptor;
			sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
														 ascending:NO];
			NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
			[keywordList sortUsingDescriptors:sortDescriptors];
			
			for (int i = keywordList.count - 1; i > 4/* keyword limit index */; i--) {
				[keywordList removeObjectAtIndex:i];
			}
			
			NSLog(@"after : %@", [keywordList componentsJoinedByString:@", "]);
			
			
		}
		
		
		NSLog(@"keword : %@", [keywordList componentsJoinedByString:@", "]);
		
		filteredKeyword = [keywordList componentsJoinedByString:@", "];
	}
	
	return filteredKeyword;
	
}

// 키워드 뽑아내기
+ (NSString *)makeKeywordWithItem:(MPMediaItem *)currentItem
{
	return [Keyword makeKeywordWithTitle:[currentItem valueForProperty:MPMediaItemPropertyTitle]
								  artist:[currentItem valueForProperty:MPMediaItemPropertyArtist]
			//album:[currentItem valueForProperty:MPMediaItemPropertyAlbumTitle]
								   album:@""]; // 앨범명 검색어에서 제외
}


@end
