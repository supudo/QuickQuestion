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

- (NSString *)getSites:(int)page pageSize:(int)pSize;
- (NSDictionary *)getSitesDictionary:(int)page pageSize:(int)pSize;

@end
