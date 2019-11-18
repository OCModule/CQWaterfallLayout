//
//  CQWCardFooter.m
//  CQWaterfallLayout_Example
//
//  Created by Steve on 2019/11/18.
//  Copyright © 2019 王承权. All rights reserved.
//

#import "CQWCardFooter.h"

@implementation CQWCardFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor yellowColor];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
