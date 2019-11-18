//
//  CQWCardCell.m
//  CQWaterfallLayout_Example
//
//  Created by Steve on 2019/11/13.
//  Copyright © 2019 王承权. All rights reserved.
//

#import "CQWCardCell.h"

@implementation CQWCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 4;
    self.contentView.clipsToBounds = YES;
    self.titleLabel.numberOfLines = 0;
    self.descLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor blackColor];
    self.descLabel.textColor = [UIColor lightGrayColor];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    return attributes;
}

- (void)configWith: (CQWCardModel *)card {
    self.titleLabel.text = card.title;
    self.descLabel.text = card.desc;
    self.imgView.image = [UIImage imageNamed:card.imgName];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
