//
//  Items.h
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/31/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingTableView.h"
#import "WebService.h"

@interface Items : LoadingTableView {
    UIView *viewHeader;
	WebService *webService;
    NSMutableArray *contentItems;
}

@property (nonatomic, retain) UIView *viewHeader;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSMutableArray *contentItems;

- (void)loadContent;

@end
