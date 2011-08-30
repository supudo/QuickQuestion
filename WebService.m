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
#import "DBManagedObjectContext.h"
#import "dbJSON.h"

@implementation WebService

@synthesize urlReader;

#pragma mark -
#pragma mark Sites

- (NSDictionary *)getSitesDictionary:(int)page pageSize:(int)pSize {
    if ([QQSettings sharedQQSettings].lastAPIRequest == nil || ([[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow] * -1) > 60) {
        [QQSettings sharedQQSettings].lastAPIRequest = [NSDate date];
        NSLog(@"LAST REQUEST = %f", [[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow]);
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
            dbJSON *dbobj = (dbJSON *)[NSEntityDescription insertNewObjectForEntityForName:@"JSON" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
            [dbobj setRequestMethod:@"sites"];
            [dbobj setRequestParams:[NSString stringWithFormat:@"page=%i&pagesize=%i", page, pSize]];
            [dbobj setTimestamp:[QQSettings sharedQQSettings].lastAPIRequest];
            [dbobj setJSONData:urlResponse];
            
            NSError *error = nil;
            if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error])
                abort();

            NSError *theError = NULL;
            NSDictionary *dict = [NSDictionary dictionaryWithJSONString:urlResponse error:&theError];
            if (theError == NULL)
                return dict;
        }
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RequestMethod = %@ AND RequestParams = %@", @"sites", [NSString stringWithFormat:@"page=%i&pagesize=%i", page, pSize]];
        dbJSON *dbobj = (dbJSON *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JSON" predicate:predicate];
        NSError *theError = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:dbobj.JSONData error:&theError];
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
