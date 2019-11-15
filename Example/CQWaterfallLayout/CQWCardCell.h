//
//  CQWCardCell.h
//  CQWaterfallLayout_Example
//
//  Created by Steve on 2019/11/13.
//  Copyright © 2019 王承权. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQWCardModel.h"

NS_ASSUME_NONNULL_BEGIN

#define ITEM_WIDTH ([UIApplication sharedApplication].keyWindow.bounds.size.width - 10) / 2.0

@interface CQWCardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)configWith: (CQWCardModel *)card;

@end

NS_ASSUME_NONNULL_END
