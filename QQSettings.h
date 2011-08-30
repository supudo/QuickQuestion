//
//  QQSettings.h
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

@interface QQSettings : NSObject {
	BOOL inDebugMode;
	NSString *consumeKey, *apiURL, *apiURLAuth;
}

@property BOOL inDebugMode;
@property (nonatomic, retain) NSString *consumeKey, *apiURL, *apiURLAuth;

- (void)LogThis:(NSString *)log, ...;
- (BOOL)connectedToInternet;

+ (QQSettings *)sharedQQSettings;

@end
