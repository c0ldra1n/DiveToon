//
//  Episode.h
//  DiveToon
//
//  Created by c0ldra1n on 2/19/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Episode : NSObject

@property NSUInteger index;
@property NSUInteger numberOfCuts;
@property NSString *sourcePath;
@property NSString *title;

-(instancetype)initWithContentsOfFile:(NSString *)path;
-(UIImage *)cutAtIndex:(NSUInteger)index;

@end
