//
//  Sites.m
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "Sites.h"
#import "SearchBy.h"

static NSString *kCellIdentifier = @"identifSites";

@implementation Sites

@synthesize webService, seSites, loadMetaSites, cellSite;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Sites", @"Sites");
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(loadSites)] autorelease];
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
	NSDictionary *sites = [webService getSites:0 pageSize:0];
	for (int i=0; i<[[sites valueForKey:@"items"] count]; i++) {
		if (loadMetaSites)
			[seSites addObject:[[[sites valueForKey:@"items"] objectAtIndex:i] valueForKey:@"main_site"]];
		else if ([[[[[sites valueForKey:@"items"] objectAtIndex:i] valueForKey:@"main_site"] valueForKey:@"state"] isEqualToString:@"normal"])
			[seSites addObject:[[[sites valueForKey:@"items"] objectAtIndex:i] valueForKey:@"main_site"]];
	}
    NSLog(@"%@", seSites);
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
	NSDictionary *ent = [seSites objectAtIndex:indexPath.row];
    CellSite *cell = (CellSite *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellSite" owner:self options:nil];
        cellSite = (CellSite *)[nib objectAtIndex:0];
        cell = [[cellSite retain] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cellSite = nil;
    }
    [cell setContent:[ent valueForKey:@"name"] withLogo:[ent valueForKey:@"favicon_url"]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [QQSettings sharedQQSettings].selectedSite = [seSites objectAtIndex:indexPath.row];
	SearchBy *tvc = [[SearchBy alloc] initWithNibName:@"SearchBy" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
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
    cellSite = nil;
    [cellSite release];
    [super viewDidUnload];
}

- (void)dealloc {
	[webService release];
	[seSites release];
    [cellSite release];
    [super dealloc];
}

@end
