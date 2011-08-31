//
//  Sites.h
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "LoadingTableView.h"
#import "CellSite.h"

@class CellSite;

@interface Sites : LoadingTableView {
	WebService *webService;
	NSMutableArray *seSites;
	BOOL loadMetaSites;
    CellSite *cellSite;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSMutableArray *seSites;
@property BOOL loadMetaSites;
@property (nonatomic, retain) IBOutlet CellSite *cellSite;

- (void)loadSites;

@end
