//
//  Search.h
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "LoadingTableView.h"

@interface Search : LoadingTableView {
	WebService *webService;
	NSMutableArray *seSites;
	BOOL loadMetaSites;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSMutableArray *seSites;
@property BOOL loadMetaSites;

- (void)loadSites;

@end
