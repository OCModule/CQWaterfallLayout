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
#import "CQWCardModel.h"

@interface CQWViewController ()<UICollectionViewDataSource, ACGWaterfallDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<CQWCardModel *> *datas;

@end

@implementation CQWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CQWCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CQWCardCell" forIndexPath:indexPath];
    CQWCardModel *card = self.datas[indexPath.item];
    [cell configWith:card];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tap %ld", indexPath.item);
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ITEM_WIDTH / 9 * 16;
    if (indexPath.item % 2 == 0) {
        height = ITEM_WIDTH / 3 * 4;
        
    }
    return CGSizeMake(ITEM_WIDTH, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ACGWaterfallLayout *layout = [[ACGWaterfallLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"CQWCardCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CQWCardCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSArray<CQWCardModel *> *)datas {
    if (!_datas) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSInteger i=0; i < 50; i ++) {
            CQWCardModel *card = [[CQWCardModel alloc] init];
            [temp addObject:card];
        }
        _datas = [temp copy];
    }
    return _datas;
}

@end
