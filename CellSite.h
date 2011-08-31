//
//  CellSite.h
//  QuickQuestion
//
//  Created by Sergey Petrov on 8/31/11.
//  Copyright 2011 supudo.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellSite : UITableViewCell {
    UIImageView *img;
    UILabel *lbl;
}

@property (nonatomic, retain) IBOutlet UIImageView *img;
@property (nonatomic, retain) IBOutlet UILabel *lbl;

- (void)setContent:(NSString *)title withLogo:(NSString *)logo;

@end
