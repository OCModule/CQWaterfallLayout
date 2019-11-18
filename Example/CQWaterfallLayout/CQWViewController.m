//
//  CQWViewController.m
//  CQWaterfallLayout
//
//  Created by 王承权 on 11/13/2019.
//  Copyright (c) 2019 王承权. All rights reserved.
//

#import "CQWViewController.h"
#import "ACGWaterfallLayout.h"
#import "CQWCardCell.h"
#import "CQWCardHeader.h"
#import "CQWCardFooter.h"
#import "CQWCardModel.h"
#import "UIColor+CQExt.h"

@interface CQWViewController ()<UICollectionViewDataSource, ACGWaterfallDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSArray<CQWCardModel *>*> *datas;

@end

@implementation CQWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CQWCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CQWCardCell reuseIdentifier] forIndexPath:indexPath];
    CQWCardModel *card = self.datas[indexPath.section][indexPath.item];
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor yellowColor];
    } else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor brownColor];
    } else if (indexPath.section == 2) {
        cell.backgroundColor = [UIColor greenColor];
    }
    [cell configWith:card];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:ACGWaterfallElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                      withReuseIdentifier:[CQWCardHeader reuseIdentifier]
                                                             forIndexPath:indexPath];
    } else if ([kind isEqualToString:ACGWaterfallElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                      withReuseIdentifier:[CQWCardFooter reuseIdentifier]
                                                             forIndexPath:indexPath];
    }
    reusableView.backgroundColor = [UIColor randomColor];
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tap %ld", indexPath.item);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ITEM_WIDTH / 9 * 16;
    if (indexPath.item % 2 == 0) {
        height = ITEM_WIDTH / 3 * 4;
        
    }
    return CGSizeMake(ITEM_WIDTH, height);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
//    return 10;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumColumnSpacingForSectionAtIndex:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return CGFLOAT_MIN;
//}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ACGWaterfallLayout *layout = [[ACGWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        layout.headerHeight = 60;
        layout.footerHeight = 80;
        layout.minimumColumnSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.columnCount = 2;
        CGRect bounds = self.view.bounds;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, bounds.size.width, bounds.size.height - 100) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:[CQWCardCell reuseIdentifier] bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[CQWCardCell reuseIdentifier]];
        [_collectionView registerNib:[UINib nibWithNibName:[CQWCardHeader reuseIdentifier] bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:ACGWaterfallElementKindSectionHeader withReuseIdentifier:[CQWCardHeader reuseIdentifier]];
        [_collectionView registerNib:[UINib nibWithNibName:[CQWCardFooter reuseIdentifier] bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:ACGWaterfallElementKindSectionFooter withReuseIdentifier:[CQWCardFooter reuseIdentifier]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor redColor];
    }
    return _collectionView;
}

- (NSArray<NSArray<CQWCardModel *>*> *)datas {
    if (!_datas) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            NSMutableArray *data = [NSMutableArray array];
            for (NSInteger i=0; i < 5; i ++) {
                CQWCardModel *card = [[CQWCardModel alloc] init];
                [data addObject:card];
            }
            [tmp addObject:data];
        }
        _datas = [tmp copy];
    }
    return _datas;
}

@end
