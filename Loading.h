//
//  Loading.h
//  QuickQuestion
//
//  Created by supudo on 8/29/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Loading : UIViewController {
	UILabel *lblLoading;
}

@property (nonatomic, retain) IBOutlet UILabel *lblLoading;

- (void)loadingFinished:(id)sender;

@end
