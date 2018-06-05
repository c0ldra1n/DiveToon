//
//  ComicScrollViewController.m
//  DiveToon
//
//  Created by c0ldra1n on 2/19/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import "ComicScrollViewController.h"

@interface ComicScrollViewController (){
    BOOL componentsHidden;
}

@end

@implementation ComicScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  assume episode is set.
    [self refresh];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [tap setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)refresh{
    self.navigationItem.title = [NSString stringWithFormat:@"(%ld) %@", self.episode.index, self.episode.title];
    
    [self loadImages];
    [self reload];
}

-(void)loadImages{
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.episode.numberOfCuts; i++) {
        UIImage *image = [self.episode cutAtIndex:i];
        [images addObject:@{@(i):image}];
    }
    
    [images sortUsingComparator:^NSComparisonResult(id a, id b){
        NSDictionary *d1 = (NSDictionary *)a;
        NSDictionary *d2 = (NSDictionary *)b;
        if ([[d1 allKeys].firstObject integerValue] > [[d2 allKeys].firstObject integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([[d1 allKeys].firstObject integerValue] < [[d2 allKeys].firstObject integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    self.images = images;
}

-(void)reload{
    
    NSUInteger offset = 0;
    
    for (NSDictionary *dict in self.images) {
        UIImage *image = dict[dict.allKeys[0]];
        CGFloat scale = self.view.frame.size.width/image.size.width;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, image.size.height * scale)];
        [imageView setImage:image];
        offset += image.size.height * scale;
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, offset);
    self.scrollView.contentOffset = CGPointZero;
    [self.view bringSubviewToFront:self.toolbar];
}

-(IBAction)prev:(id)sender{
    self.episode = self.comic.episodes[self.episode.index-1-1];
    [self refresh];
}

-(IBAction)next:(id)sender{
    self.episode = self.comic.episodes[self.episode.index+1-1];
    [self refresh];
}

-(void)tap{
    if (componentsHidden) {
        //  show
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        self.toolbarBottomConstraint.constant = 0;
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];

    }else{
        //  hide
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        self.toolbarBottomConstraint.constant = self.toolbar.frame.size.height;
        [UIView animateWithDuration:0.25
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];

    }
    componentsHidden = !componentsHidden;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    componentsHidden = false;
//    self.navigationController.hidesBarsOnTap = true;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.navigationController.hidesBarsOnTap = false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
