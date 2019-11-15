//
//  CQWCardModel.m
//  CQWaterfallLayout_Example
//
//  Created by Steve on 2019/11/13.
//  Copyright © 2019 王承权. All rights reserved.
//

#import "CQWCardModel.h"

@interface CQWCardModel()

@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, copy) NSArray<NSString *> *descs;

@end

@implementation CQWCardModel

- (NSString *)title {
    if (!_title) {
        NSInteger idx = arc4random_uniform(self.titles.count);
        _title = [self.titles objectAtIndex:idx];
    }
    return _title;
}

- (NSString *)desc {
    if (!_desc) {
        NSInteger idx = arc4random_uniform(self.descs.count);
        _desc = [self.descs objectAtIndex:idx];
    }
    return _desc;
}

- (NSString *)imgName {
    if (!_imgName) {
        _imgName = [NSString stringWithFormat:@"image%d", arc4random_uniform(22)];
    }
    return _imgName;
}

- (NSArray<NSString *> *)titles {
    return @[
                @"Lorem ipsum dolor sit amet",
                @"consectetur adipiscing elit",
                @"sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
            ];
}

- (NSArray<NSString *> *)descs {
    return @[
                @"Cras semper auctor neque vitae.",
                @"Pharetra diam sit amet nisl suscipit.",
                @"Sodales neque sodales ut etiam.",
                @"Mattis enim ut tellus elementum sagittis.",
                @"Sed elementum tempus egestas sed sed risus pretium.",
                @"Ut eu sem integer vitae justo eget.",
                @"Aenean vel elit scelerisque mauris pellentesque pulvinar pellentesque habitant morbi.",
                @"Sit amet facilisis magna etiam tempor orci eu lobortis elementum.",
                @"Nisl pretium fusce id velit ut tortor pretium viverra suspendisse.",
                @"Viverra nam libero justo laoreet sit amet cursus sit."
            ];
}


@end
