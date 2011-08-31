//
//  WebService.h
//  QuickQuestion
//
//  Created by supudo on 8/30/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLReader.h"

@interface WebService : NSObject <NSXMLParserDelegate, URLReaderDelegate> {
	URLReader *urlReader;
}

@property (nonatomic, retain) URLReader *urlReader;

- (NSDictionary *)getSites:(int)page pageSize:(int)pSize;
- (NSDictionary *)getTags:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl;
- (NSDictionary *)getQuestions:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl;
- (NSDictionary *)getAnswers:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl;
- (NSDictionary *)getComments:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl;

@end
