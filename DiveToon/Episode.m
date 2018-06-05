//
//  Episode.m
//  DiveToon
//
//  Created by c0ldra1n on 2/19/18.
//  Copyright © 2018 c0ldra1n. All rights reserved.
//

#import "Episode.h"

@implementation Episode

-(instancetype)initWithContentsOfFile:(NSString *)path{
    self = [self init];
    if (self) {
        BOOL isdir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir] && isdir) {
            self.sourcePath = path;
            self.title = [path lastPathComponent];
            self.numberOfCuts = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil].count;
            NSString *metapath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"webtoon.json"];
            NSDictionary *metadata = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:metapath] options:kNilOptions error:nil];
            for (NSString *key in [[metadata objectForKey:@"episodes"] allKeys]) {
                if ([[metadata objectForKey:key] isEqualToString:self.title]) {
                    self.index = [key integerValue];
                }
            }
        }else{
            return nil;
        }
    }
    return self;
}

-(UIImage *)cutAtIndex:(NSUInteger)index{
    NSString *imagePath = [self.sourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.jpg", index]];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
