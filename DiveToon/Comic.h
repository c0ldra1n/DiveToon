//
//  Comic.h
//  DiveToon
//
//  Created by c0ldra1n on 2/19/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"

@interface Comic : NSObject

@property NSString *title;
@property NSString *author;
@property NSArray<Episode *> *episodes;

-(instancetype)initWithContentsOfFile:(NSString *)path;

@end
