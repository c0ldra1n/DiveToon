//
//  Comic.m
//  DiveToon
//
//  Created by c0ldra1n on 2/19/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import "Comic.h"
#import "Episode.h"

@implementation Comic

-(instancetype)initWithContentsOfFile:(NSString *)path{
    self = [self init];
    if (self) {
        
        BOOL isdir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir] && isdir) {
            self.title = [path lastPathComponent];
            NSString *metapath = [path stringByAppendingPathComponent:@"webtoon.json"];
            NSDictionary *metadata = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:metapath] options:kNilOptions error:nil];
            self.author = [metadata objectForKey:@"author"];
            NSMutableArray *episodes = [[NSMutableArray alloc] init];
            for (NSString *key in [metadata objectForKey:@"episodes"]) {
                Episode *e = [[Episode alloc] init];
                e.title = [metadata objectForKey:@"episodes"][key];
                e.sourcePath = [path stringByAppendingPathComponent:e.title];
                e.index = [key integerValue];
                e.numberOfCuts = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:e.sourcePath error:nil].count;
                [episodes addObject:e];
            }
            
            [episodes sortUsingComparator:^NSComparisonResult(id a, id b){
                BOOL descending = false;
                Episode *e1 = (Episode *)a;
                Episode *e2 = (Episode *)b;
                if (e1.index > e2.index) {
                    return (NSComparisonResult)(descending ? NSOrderedAscending : NSOrderedDescending);
                }
                if (e1.index < e2.index) {
                    return (NSComparisonResult)(descending ? NSOrderedDescending : NSOrderedAscending);
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            self.episodes = episodes;

        }else{
            return nil;
        }
    }
    return self;
}

@end
