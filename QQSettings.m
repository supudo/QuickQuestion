//
//  QQSettings.m
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "QQSettings.h"
#import "Reachability.h"

@implementation QQSettings

SYNTHESIZE_SINGLETON_FOR_CLASS(QQSettings);

@synthesize inDebugMode, consumeKey, apiURL, apiURLAuth, selectedSite, lastRequestMethod, searchQuery, lastAPIRequest, searchBy, apiVersion;

- (void)LogThis:(NSString *)log, ... {
	if (self.inDebugMode) {
		NSString *output;
		va_list ap;
		va_start(ap, log);
		output = [[NSString alloc] initWithFormat:log arguments:ap];
		va_end(ap);
		NSLog(@"[_____QQ-DEBUG] : %@", output);
		[output release];
	}
}

- (BOOL)connectedToInternet {
	Reachability *r = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL result = FALSE;
	if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN)
	    result = TRUE;
	return result;
}

- (id) init {
	if (self = [super init]) {
		self.inDebugMode = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"QQInDebugMode"] boolValue];
		self.consumeKey = @"pBjnkNsSR02fnbPARTwOlg";
		self.apiURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"QQAPIURL"];
		self.apiURLAuth = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"QQAPIURLAuth"];
        self.selectedSite = nil;
        self.searchBy = QQSearchByTags;
        self.lastRequestMethod = @"";
        self.searchQuery = @"";
        self.apiVersion = @"1.1";

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.lastAPIRequest = [prefs objectForKey:@"lastAPIRequest"];
        if (self.lastAPIRequest == nil) {
            self.lastAPIRequest = nil;
            [prefs setObject:[NSDate date] forKey:@"lastAPIRequest"];
        }
        [prefs synchronize];
	}
	return self;
}

@end
