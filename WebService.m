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

- (NSDictionary *)getSites:(int)page pageSize:(int)pSize {
    if (![[QQSettings sharedQQSettings].lastRequestMethod isEqualToString:@"sites"] || [QQSettings sharedQQSettings].lastAPIRequest == nil || ([[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow] * -1) > 60) {
        [QQSettings sharedQQSettings].lastRequestMethod = @"sites";
        [[QQSettings sharedQQSettings] LogThis:@"URL : %@sites?page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, page, pSize];
        [QQSettings sharedQQSettings].lastAPIRequest = [NSDate date];
        if (urlReader == nil)
            urlReader = [[URLReader alloc] init];
        [urlReader setDelegate:self];

        NSString *urlResponse;
        if (page == 0 || pSize == 0)
            urlResponse = [urlReader getFromURL:[NSString stringWithFormat:@"%@sites?key=%@", [QQSettings sharedQQSettings].apiURLAuth, [QQSettings sharedQQSettings].consumeKey] postData:@"" postMethod:@"GET"];
        else
            urlResponse = [urlReader getFromURL:[NSString stringWithFormat:@"%@sites?key=%@&page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, [QQSettings sharedQQSettings].consumeKey, page, pSize] postData:@"" postMethod:@"GET"];
        
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
        [[QQSettings sharedQQSettings] LogThis:@"Cached : %@sites?page=%i&pagesize=%i", [QQSettings sharedQQSettings].apiURLAuth, page, pSize];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RequestMethod = %@ AND RequestParams = %@", @"sites", [NSString stringWithFormat:@"page=%i&pagesize=%i", page, pSize]];
        dbJSON *dbobj = (dbJSON *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JSON" predicate:predicate];
        NSError *theError = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:dbobj.JSONData error:&theError];
        if (theError == NULL)
            return dict;
    }
    return nil;
}

- (NSDictionary *)getTags:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl {
    NSMutableString *requestURL = [[NSMutableString alloc] init];
    [requestURL setString:@""];
    [requestURL appendFormat:@"%@/%@/tags", apiurl, [QQSettings sharedQQSettings].apiVersion];
    [requestURL appendFormat:@"?key=%@", [QQSettings sharedQQSettings].consumeKey];
    if (page != 0 && pSize != 0)
        [requestURL appendFormat:@"&page=%i&pagesize=%i", page, pSize];
    if ([QQSettings sharedQQSettings].searchQuery != nil && ![[QQSettings sharedQQSettings].searchQuery isEqualToString:@""])
        [requestURL appendFormat:@"&filter=%@", [QQSettings sharedQQSettings].searchQuery];

    if (![[QQSettings sharedQQSettings].lastRequestMethod isEqualToString:@"tags"] || [QQSettings sharedQQSettings].lastAPIRequest == nil || ([[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow] * -1) > 60) {
        [QQSettings sharedQQSettings].lastRequestMethod = @"tags";

        [[QQSettings sharedQQSettings] LogThis:@"URL : %@", requestURL];

        [QQSettings sharedQQSettings].lastAPIRequest = [NSDate date];
        if (urlReader == nil)
            urlReader = [[URLReader alloc] init];
        [urlReader setDelegate:self];
        
        NSString *urlResponse;
        if (page == 0 || pSize == 0)
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        else
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        NSLog(@"%@", urlResponse);
        if (![urlResponse isEqualToString:@""]) {
            dbJSON *dbobj = (dbJSON *)[NSEntityDescription insertNewObjectForEntityForName:@"JSON" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
            [dbobj setRequestMethod:@"tags"];
            [dbobj setRequestParams:requestURL];
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
        [[QQSettings sharedQQSettings] LogThis:@"Cached : %@", requestURL];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RequestMethod = %@ AND RequestParams = %@", @"tags", requestURL];
        dbJSON *dbobj = (dbJSON *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JSON" predicate:predicate];
        NSError *theError = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:dbobj.JSONData error:&theError];
        if (theError == NULL)
            return dict;
    }
    return nil;
}

- (NSDictionary *)getQuestions:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl {
    NSMutableString *requestURL = [[NSMutableString alloc] init];
    [requestURL setString:@""];
    [requestURL appendFormat:@"%@/%@/questions", apiurl, [QQSettings sharedQQSettings].apiVersion];
    [requestURL appendFormat:@"?key=%@", [QQSettings sharedQQSettings].consumeKey];
    [requestURL appendFormat:@"&answers=false"];
    [requestURL appendFormat:@"&body=false"];
    [requestURL appendFormat:@"&comments=false"];
    if (page != 0 && pSize != 0)
        [requestURL appendFormat:@"&page=%i&pagesize=%i", page, pSize];
    if ([QQSettings sharedQQSettings].searchQuery != nil && ![[QQSettings sharedQQSettings].searchQuery isEqualToString:@""])
        [requestURL appendFormat:@"&filter=%@", [QQSettings sharedQQSettings].searchQuery];
    
    if (![[QQSettings sharedQQSettings].lastRequestMethod isEqualToString:@"questions"] || [QQSettings sharedQQSettings].lastAPIRequest == nil || ([[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow] * -1) > 60) {
        [QQSettings sharedQQSettings].lastRequestMethod = @"questions";
        
        [[QQSettings sharedQQSettings] LogThis:@"URL : %@", requestURL];
        
        [QQSettings sharedQQSettings].lastAPIRequest = [NSDate date];
        if (urlReader == nil)
            urlReader = [[URLReader alloc] init];
        [urlReader setDelegate:self];
        
        NSString *urlResponse;
        if (page == 0 || pSize == 0)
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        else
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        
        if (![urlResponse isEqualToString:@""]) {
            dbJSON *dbobj = (dbJSON *)[NSEntityDescription insertNewObjectForEntityForName:@"JSON" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
            [dbobj setRequestMethod:@"questions"];
            [dbobj setRequestParams:requestURL];
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
        [[QQSettings sharedQQSettings] LogThis:@"Cached : %@", requestURL];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RequestMethod = %@ AND RequestParams = %@", @"questions", requestURL];
        dbJSON *dbobj = (dbJSON *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JSON" predicate:predicate];
        NSError *theError = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:dbobj.JSONData error:&theError];
        if (theError == NULL)
            return dict;
    }
    return nil;
}

- (NSDictionary *)getAnswers:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl {
    NSMutableString *requestURL = [[NSMutableString alloc] init];
    [requestURL setString:@""];
    [requestURL appendFormat:@"%@/%@/answers", apiurl, [QQSettings sharedQQSettings].apiVersion];
    [requestURL appendFormat:@"?key=%@", [QQSettings sharedQQSettings].consumeKey];
    [requestURL appendFormat:@"&body=false"];
    [requestURL appendFormat:@"&comments=false"];
    if (page != 0 && pSize != 0)
        [requestURL appendFormat:@"&page=%i&pagesize=%i", page, pSize];
    if ([QQSettings sharedQQSettings].searchQuery != nil && ![[QQSettings sharedQQSettings].searchQuery isEqualToString:@""])
        [requestURL appendFormat:@"&filter=%@", [QQSettings sharedQQSettings].searchQuery];
    
    if (![[QQSettings sharedQQSettings].lastRequestMethod isEqualToString:@"answers"] || [QQSettings sharedQQSettings].lastAPIRequest == nil || ([[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow] * -1) > 60) {
        [QQSettings sharedQQSettings].lastRequestMethod = @"answers";
        
        [[QQSettings sharedQQSettings] LogThis:@"URL : %@", requestURL];
        
        [QQSettings sharedQQSettings].lastAPIRequest = [NSDate date];
        if (urlReader == nil)
            urlReader = [[URLReader alloc] init];
        [urlReader setDelegate:self];
        
        NSString *urlResponse;
        if (page == 0 || pSize == 0)
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        else
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        
        if (![urlResponse isEqualToString:@""]) {
            dbJSON *dbobj = (dbJSON *)[NSEntityDescription insertNewObjectForEntityForName:@"JSON" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
            [dbobj setRequestMethod:@"answers"];
            [dbobj setRequestParams:requestURL];
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
        [[QQSettings sharedQQSettings] LogThis:@"Cached : %@", requestURL];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RequestMethod = %@ AND RequestParams = %@", @"answers", requestURL];
        dbJSON *dbobj = (dbJSON *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JSON" predicate:predicate];
        NSError *theError = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:dbobj.JSONData error:&theError];
        if (theError == NULL)
            return dict;
    }
    return nil;
}

- (NSDictionary *)getComments:(int)page pageSize:(int)pSize apiURL:(NSString *)apiurl {
    NSMutableString *requestURL = [[NSMutableString alloc] init];
    [requestURL setString:@""];
    [requestURL appendFormat:@"%@/%@/comments", apiurl, [QQSettings sharedQQSettings].apiVersion];
    [requestURL appendFormat:@"?key=%@", [QQSettings sharedQQSettings].consumeKey];
    [requestURL appendFormat:@"&answers=false"];
    [requestURL appendFormat:@"&body=false"];
    [requestURL appendFormat:@"&comments=false"];
    if (page != 0 && pSize != 0)
        [requestURL appendFormat:@"&page=%i&pagesize=%i", page, pSize];
    if ([QQSettings sharedQQSettings].searchQuery != nil && ![[QQSettings sharedQQSettings].searchQuery isEqualToString:@""])
        [requestURL appendFormat:@"&filter=%@", [QQSettings sharedQQSettings].searchQuery];
    
    if (![[QQSettings sharedQQSettings].lastRequestMethod isEqualToString:@"comments"] || [QQSettings sharedQQSettings].lastAPIRequest == nil || ([[QQSettings sharedQQSettings].lastAPIRequest timeIntervalSinceNow] * -1) > 60) {
        [QQSettings sharedQQSettings].lastRequestMethod = @"comments";
        
        [[QQSettings sharedQQSettings] LogThis:@"URL : %@", requestURL];
        
        [QQSettings sharedQQSettings].lastAPIRequest = [NSDate date];
        if (urlReader == nil)
            urlReader = [[URLReader alloc] init];
        [urlReader setDelegate:self];
        
        NSString *urlResponse;
        if (page == 0 || pSize == 0)
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        else
            urlResponse = [urlReader getFromURL:requestURL postData:@"" postMethod:@"GET"];
        
        if (![urlResponse isEqualToString:@""]) {
            dbJSON *dbobj = (dbJSON *)[NSEntityDescription insertNewObjectForEntityForName:@"JSON" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
            [dbobj setRequestMethod:@"comments"];
            [dbobj setRequestParams:requestURL];
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
        [[QQSettings sharedQQSettings] LogThis:@"Cached : %@", requestURL];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RequestMethod = %@ AND RequestParams = %@", @"comments", requestURL];
        dbJSON *dbobj = (dbJSON *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JSON" predicate:predicate];
        NSError *theError = NULL;
        NSDictionary *dict = [NSDictionary dictionaryWithJSONString:dbobj.JSONData error:&theError];
        if (theError == NULL)
            return dict;
    }
    return nil;
}

@end
