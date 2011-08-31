//
//  SearchBy.m
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/31/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import "SearchBy.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "Items.h"

static NSString *kCellIdentifier = @"identifChoices";

@implementation SearchBy

@synthesize choices, viewHeader, searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    searchBar.placeholder = NSLocalizedString(@"SearchFor", @"SearchFor");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationItem.title = [[QQSettings sharedQQSettings].selectedSite valueForKey:@"name"];
    if (choices == nil) {
        choices = [[NSMutableArray alloc] init];
        [choices addObject:[NSArray arrayWithObjects:NSLocalizedString(@"SearchBy.Tags", @"SearchBy.Tags"), nil]];
        [choices addObject:[NSArray arrayWithObjects:NSLocalizedString(@"SearchBy.Questions", @"SearchBy.Questions"), nil]];
        [choices addObject:[NSArray arrayWithObjects:NSLocalizedString(@"SearchBy.Answers", @"SearchBy.Answers"), nil]];
        [choices addObject:[NSArray arrayWithObjects:NSLocalizedString(@"SearchBy.Comments", @"SearchBy.Comments"), nil]];
    }
}

#pragma mark -
#pragma mark Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.text = [[choices objectAtIndex:indexPath.row] objectAtIndex:0];
    [cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [QQSettings sharedQQSettings].searchBy = indexPath.row;
    [QQSettings sharedQQSettings].searchQuery = searchBar.text;
    Items *tvc = [[Items alloc] initWithNibName:@"Items" bundle:nil];
    [[self navigationController] pushViewController:tvc animated:YES];
    [tvc release];
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

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    choices = nil;
    [choices release];
    viewHeader = nil;
    [viewHeader release];
    searchBar = nil;
    [searchBar release];
    [super viewDidUnload];
}

- (void)dealloc {
    [choices release];
    [viewHeader release];
    [searchBar release];
    [super dealloc];
}

@end
