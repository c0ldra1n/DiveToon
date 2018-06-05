//
//  ComicScrollViewController.h
//  DiveToon
//
//  Created by c0ldra1n on 2/19/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"
#import "Comic.h"
@interface ComicScrollViewController : UIViewController <UIScrollViewDelegate>

@property Comic *comic;
@property Episode *episode;
@property NSMutableArray<NSDictionary<NSNumber *, UIImage *> *> *images;
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UIToolbar *toolbar;
@property IBOutlet NSLayoutConstraint *toolbarBottomConstraint;

@end
