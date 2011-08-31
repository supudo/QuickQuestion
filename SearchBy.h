//
//  SearchBy.h
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/31/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBy : UITableViewController {
    NSMutableArray *choices;
    UIView *viewHeader;
    UISearchBar *searchBar;
}

@property (nonatomic, retain) NSMutableArray *choices;
@property (nonatomic, retain) UIView *viewHeader;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
