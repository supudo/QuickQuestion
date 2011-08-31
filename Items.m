//
//  Items.m
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/31/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "Items.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

static NSString *kCellIdentifier = @"identifItems";

@implementation Items

@synthesize viewHeader, webService, contentItems;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    switch ([QQSettings sharedQQSettings].searchBy) {
        case QQSearchByTags:
            self.navigationItem.title = NSLocalizedString(@"SearchBy.Tags", @"SearchBy.Tags");
            break;
        case QQSearchByQuestions:
            self.navigationItem.title = NSLocalizedString(@"SearchBy.Questions", @"SearchBy.Questions");
            break;
        case QQSearchByAnswers:
            self.navigationItem.title = NSLocalizedString(@"SearchBy.Answers", @"SearchBy.Answers");
            break;
        case QQSearchByComments:
            self.navigationItem.title = NSLocalizedString(@"SearchBy.Comments", @"SearchBy.Comments");
            break;
        default:
            break;
    }
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    [self loadContent];
}

- (void)loadContent {
	if (webService == nil)
		webService = [[WebService alloc] init];
	if (contentItems == nil)
		contentItems = [[NSMutableArray alloc] init];
    
	[contentItems removeAllObjects];
	NSDictionary *items;
    switch ([QQSettings sharedQQSettings].searchBy) {
        case QQSearchByTags: {
            items = [webService getTags:0 pageSize:0 apiURL:[[QQSettings sharedQQSettings].selectedSite valueForKey:@"api_endpoint"]];
            for (int i=0; i<[[items valueForKey:@"tags"] count]; i++)
                [contentItems addObject:[[items valueForKey:@"tags"] objectAtIndex:i]];
            break;
        }
        case QQSearchByQuestions: {
            items = [webService getQuestions:0 pageSize:0 apiURL:[[QQSettings sharedQQSettings].selectedSite valueForKey:@"api_endpoint"]];
            for (int i=0; i<[[items valueForKey:@"questions"] count]; i++)
                [contentItems addObject:[[items valueForKey:@"questions"] objectAtIndex:i]];
            break;
        }
        case QQSearchByAnswers: {
            items = [webService getAnswers:0 pageSize:0 apiURL:[[QQSettings sharedQQSettings].selectedSite valueForKey:@"api_endpoint"]];
            for (int i=0; i<[[items valueForKey:@"answers"] count]; i++)
                [contentItems addObject:[[items valueForKey:@"answers"] objectAtIndex:i]];
            break;
        }
        case QQSearchByComments: {
            items = [webService getComments:0 pageSize:0 apiURL:[[QQSettings sharedQQSettings].selectedSite valueForKey:@"api_endpoint"]];
            for (int i=0; i<[[items valueForKey:@"comments"] count]; i++)
                [contentItems addObject:[[items valueForKey:@"comments"] objectAtIndex:i]];
            break;
        }
        default:
            break;
    }
    NSLog(@"%@", contentItems);
	
	[self.tableView reloadData];
    [self stopLoading];
}

#pragma mark -
#pragma mark Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contentItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.text = [[contentItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (viewHeader == nil) {
        viewHeader = [[UIView alloc] init];
        __block ASIHTTPRequest *imgreq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[[QQSettings sharedQQSettings].selectedSite valueForKey:@"logo_url"]]];
        [imgreq setDownloadCache:[ASIDownloadCache sharedCache]];
        [imgreq setCompletionBlock:^{
            UIImage *logoImage = [UIImage imageWithData:[imgreq responseData]];
            UIImageView *v = [[UIImageView alloc] initWithImage:logoImage];
            v.contentMode = UIViewContentModeScaleAspectFit;
            CGRect ft = v.frame;
            ft.origin.x = 4;
            ft.origin.y = 4;
            ft.size.width = 312;
            v.frame = ft;
            [viewHeader addSubview:v];
            [v release];
            ft = viewHeader.frame;
            ft.size.height = logoImage.size.height + 10;
            viewHeader.frame = ft;
            [tableView reloadData];
        }];
        [imgreq startAsynchronous];
    }
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return viewHeader.frame.size.height;
}

- (void)refresh {
	[self performSelector:@selector(loadContent) withObject:nil afterDelay:2.0];
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
    viewHeader = nil;
    [viewHeader release];
    webService = nil;
    [webService release];
    contentItems = nil;
    [contentItems release];
    [super viewDidUnload];
}

- (void)dealloc {
    [viewHeader release];
    [webService release];
    [contentItems release];
    [super dealloc];
}

@end
