//
//  CellSite.m
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/31/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "CellSite.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation CellSite

@synthesize lbl, img;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setContent:(NSString *)title withLogo:(NSString *)logo {
    self.lbl.text = title;
    [self.lbl setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];

    __block ASIHTTPRequest *imgreq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:logo]];
    [imgreq setDownloadCache:[ASIDownloadCache sharedCache]];
    [imgreq setCompletionBlock:^{
        UIImage *logoImage = [UIImage imageWithData:[imgreq responseData]];
        img.image = logoImage;
    }];
    [imgreq startAsynchronous];
}

- (void)dealloc {
    [lbl release];
    [img release];
    [super dealloc];
}

@end
