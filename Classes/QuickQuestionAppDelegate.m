//
//  QuickQuestionAppDelegate.m
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuickQuestionAppDelegate.h"
#import "Loading.h"

QuickQuestionAppDelegate *appDelegate;

@implementation QuickQuestionAppDelegate

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	appDelegate = self;
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    Loading *lvc = [[Loading alloc] initWithNibName:@"Loading" bundle:nil];
    [tabBarController presentModalViewController:lvc animated:NO];
    [lvc release];

    return YES;
}

- (void)loadingFinished {
    [tabBarController dismissModalViewControllerAnimated:YES];
	tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[tabBarController.moreNavigationController setDelegate:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

