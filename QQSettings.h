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
	NSString *consumeKey, *apiURL, *apiURLAuth, *lastRequestMethod, *searchQuery, *apiVersion;
    NSDate *lastAPIRequest;
    int searchBy;
    NSDictionary *selectedSite;
}

typedef enum QQSearchBy {
	QQSearchByTags = 0,
	QQSearchByQuestions,
    QQSearchByAnswers,
	QQSearchByComments
} QQSearchBy;

@property BOOL inDebugMode;
@property (nonatomic, retain) NSString *consumeKey, *apiURL, *apiURLAuth, *lastRequestMethod, *searchQuery, *apiVersion;
@property (nonatomic, retain) NSDate *lastAPIRequest;
@property int searchBy;
@property (nonatomic, retain) NSDictionary *selectedSite;

- (void)LogThis:(NSString *)log, ...;
- (BOOL)connectedToInternet;

+ (QQSettings *)sharedQQSettings;

@end
