//
//  Loading.m
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "Loading.h"

@implementation Loading

@synthesize lblLoading;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"MainNavTitle", @"MainNavTitle");
	[self.lblLoading setFont:[UIFont fontWithName:@"Ubuntu" size:30]];
	[self.lblLoading setText:NSLocalizedString(@"Loading", @"Loading")];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self performSelector:@selector(loadingFinished:) withObject:nil afterDelay:2.0];
}

- (void)loadingFinished:(id)sender {
	[appDelegate loadingFinished];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	lblLoading = nil;
	[lblLoading release];
    [super viewDidUnload];
}

- (void)dealloc {
	[lblLoading release];
    [super dealloc];
}

@end
