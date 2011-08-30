//
//  Search.m
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "Search.h"

static NSString *kCellIdentifier = @"identifSites";

@implementation Search

@synthesize webService, seSites, loadMetaSites;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Sites", @"Sites");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	loadMetaSites = YES;
	[self loadSites];
}

#pragma mark -
#pragma mark Workers

- (void)loadSites {
	if (webService == nil)
		webService = [[WebService alloc] init];
	if (seSites == nil)
		seSites = [[NSMutableArray alloc] init];

	[seSites removeAllObjects];
	NSDictionary *sites = [webService getSitesDictionary:0 pageSize:0];
	for (int i=0; i<[[sites valueForKey:@"items"] count]; i++) {
		if (loadMetaSites)
			[seSites addObject:[[[sites valueForKey:@"items"] objectAtIndex:i] valueForKey:@"main_site"]];
		else if ([[[[[sites valueForKey:@"items"] objectAtIndex:i] valueForKey:@"main_site"] valueForKey:@"state"] isEqualToString:@"normal"])
			[seSites addObject:[[[sites valueForKey:@"items"] objectAtIndex:i] valueForKey:@"main_site"]];
	}
	loadMetaSites = !loadMetaSites;
	
	[self.tableView reloadData];
    [self stopLoading];
}

#pragma mark -
#pragma mark Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [seSites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
	}
	NSDictionary *ent = [seSites objectAtIndex:indexPath.row];
	//cell.imageView.image = [ent valueForKey:@"name"];
	cell.textLabel.text = [ent valueForKey:@"name"];
	[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
	//cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ // %@", (([ento.HumanYn boolValue]) ? NSLocalizedString(@"Offer_IShort_Human", @"Offer_IShort_Human") : NSLocalizedString(@"Offer_IShort_Company", @"Offer_IShort_Company")), [[bSettings sharedbSettings] getOfferDate:ento.PublishDate]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)refresh {
	[self performSelector:@selector(loadSites) withObject:nil afterDelay:2.0];
}

- (void)contentRefreshed {
	[self.tableView reloadData];
    [self stopLoading];
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	webService = nil;
	[webService release];
	seSites = nil;
	[seSites release];
    [super viewDidUnload];
}

- (void)dealloc {
	[webService release];
	[seSites release];
    [super dealloc];
}

@end
