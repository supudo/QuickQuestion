//
//  WebService.m
//  QuickQuestion
//
//  Created by supudo on 8/30/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "WebService.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "CJSONScanner.h"
#include "NSDictionary_JSONExtensions.h"

@implementation WebService

@synthesize urlReader;

#pragma mark -
#pragma mark Sites

- (NSDictionary *)getSitesDictionary:(int)page pageSize:(int)pSize {
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];

	[[QQSettings sharedQQSettings] LogThis:@"URL : %@sites?page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, page, pSize];
	NSString *urlResponse;
	if (page == 0 || pSize == 0)
		urlResponse = [urlReader getFromURL:[NSString stringWithFormat:@"%@sites", [QQSettings sharedQQSettings].apiURLAuth] postData:@"" postMethod:@"GET"];
	else
		urlResponse = [urlReader getFromURL:[NSString stringWithFormat:@"%@sites?page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, page, pSize] postData:@"" postMethod:@"GET"];
	
	if (![urlResponse isEqualToString:@""]) {
		NSError *theError = NULL;
		NSDictionary *dict = [NSDictionary dictionaryWithJSONString:urlResponse error:&theError];
		if (theError == NULL)
			return dict;
	}
	return nil;
}

- (NSString *)getSites:(int)page pageSize:(int)pSize {
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];

	[[QQSettings sharedQQSettings] LogThis:@"URL : %@sites?page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, page, pSize];
	NSString *urlResponse;
	if (page == 0 || pSize == 0)
		urlResponse = [urlReader getFromURL:[NSString stringWithFormat:@"%@sites", [QQSettings sharedQQSettings].apiURLAuth] postData:@"" postMethod:@"GET"];
	else
		urlResponse = [urlReader getFromURL:[NSString stringWithFormat:@"%@sites?page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, page, pSize] postData:@"" postMethod:@"GET"];
	
	NSData *rawData = [urlResponse dataUsingEncoding:NSUTF8StringEncoding];
	if (rawData != NULL) {
		NSError *theError = nil;
		id json = [[CJSONDeserializer deserializer] deserialize:rawData error:&theError];
		NSData *jsonData = [[CJSONSerializer serializer] serializeObject:json error:&theError];
		if (jsonData != NULL)
			return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
	}
	return @"";
}

#pragma mark -

@end
