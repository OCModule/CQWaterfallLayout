//
//  ACGWaterfallLayout.h
//  CQWaterfallLayout_Example
//
//  Created by Steve on 2019/11/13.
//  Copyright © 2019 王承权. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const ACGWaterfallElementKindSectionHeader;
extern NSString *const ACGWaterfallElementKindSectionFooter;

@protocol ACGWaterfallDelegateFlowLayout <UICollectionViewDelegate>

@required

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForHeaderInSection:(NSInteger)section;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForFooterInSection:(NSInteger)section;

@end

@interface ACGWaterfallLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat minimumColumnSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) UIEdgeInsets headerInset;
@property (nonatomic, assign) UIEdgeInsets footerInset;

@end

NS_ASSUME_NONNULL_END
