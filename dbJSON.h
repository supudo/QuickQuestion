//
//  dbJSON.h
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/30/11.
//  Copyright (c) 2011 supudo.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface dbJSON : NSManagedObject {
    @private
}

@property (nonatomic, retain) NSDate * Timestamp;
@property (nonatomic, retain) NSString * RequestMethod;
@property (nonatomic, retain) NSString * RequestParams;
@property (nonatomic, retain) NSString * JSONData;

@end
