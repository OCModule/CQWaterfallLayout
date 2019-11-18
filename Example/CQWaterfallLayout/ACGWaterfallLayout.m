//
//  ACGWaterfallLayout.m
//  CQWaterfallLayout_Example
//
//  Created by Steve on 2019/11/13.
//  Copyright © 2019 王承权. All rights reserved.
//

#import "ACGWaterfallLayout.h"

NSString *const ACGWaterfallElementKindSectionHeader = @"ACGWaterfallElementKindSectionHeader";
NSString *const ACGWaterfallElementKindSectionFooter = @"ACGWaterfallElementKindSectionFooter";

@interface ACGWaterfallLayout()

@property (nonatomic, weak) id <ACGWaterfallDelegateFlowLayout> delegate;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
@property (nonatomic, strong) NSMutableDictionary *headerAttributes;
@property (nonatomic, strong) NSMutableDictionary *footerAttributes;
@property (nonatomic, strong) NSMutableArray *unionRects;

@end

@implementation ACGWaterfallLayout

static const NSInteger unionSize = NSIntegerMax;

static CGFloat WFLFloorCGFloat(CGFloat value) {
    CGFloat scale = [UIScreen mainScreen].scale;
    return floor(value * scale) / scale;
}

#pragma mark - Public Accessors
- (void)setColumnCount:(NSInteger)columnCount {
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setMinimumColumnSpacing:(CGFloat)minimumColumnSpacing {
    if (_minimumColumnSpacing != minimumColumnSpacing) {
        _minimumColumnSpacing = minimumColumnSpacing;
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    if (_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setHeaderHeight:(CGFloat)headerHeight {
    if (_headerHeight != headerHeight) {
        _headerHeight = headerHeight;
        [self invalidateLayout];
    }
}

- (void)setFooterHeight:(CGFloat)footerHeight {
    if (_footerHeight != footerHeight) {
        _footerHeight = footerHeight;
        [self invalidateLayout];
    }
}

- (void)setHeaderInset:(UIEdgeInsets)headerInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_headerInset, headerInset)) {
        _headerInset = headerInset;
        [self invalidateLayout];
    }
}

- (void)setFooterInset:(UIEdgeInsets)footerInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_footerInset, footerInset)) {
        _footerInset = footerInset;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (NSInteger)columnCountForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self columnCountForSection:section];
    } else {
        return self.columnCount;
    }
}

- (CGFloat)minimumInteritemSpacingForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (CGFloat)minimumColumnSpacingForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumColumnSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumColumnSpacingForSectionAtIndex:section];
    } else {
        return self.minimumColumnSpacing;
    }
}

- (UIEdgeInsets)sectionInsetForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    } else {
        return self.sectionInset;
    }
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
       return [self.delegate collectionView:self.collectionView layout:self heightForHeaderInSection:section];
    } else {
       return self.headerHeight;
    }
}

- (UIEdgeInsets)insetForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForHeaderInSection:)]) {
       return [self.delegate collectionView:self.collectionView layout:self insetForHeaderInSection:section];
    } else {
       return self.headerInset;
    }
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)]) {
       return [self.delegate collectionView:self.collectionView layout:self heightForFooterInSection:section];
    } else {
       return self.footerHeight;
    }
}

- (UIEdgeInsets)insetForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForFooterInSection:)]) {
       return [self.delegate collectionView:self.collectionView layout:self insetForFooterInSection:section];
    } else {
       return self.footerInset;
    }
}

#pragma mark - Private Accessors

- (NSMutableDictionary *)headerAttributes {
    if (!_headerAttributes) {
        _headerAttributes = [NSMutableDictionary dictionary];
    }
    return _headerAttributes;
}

- (NSMutableDictionary *)footerAttributes {
    if (!_footerAttributes) {
        _footerAttributes = [NSMutableDictionary dictionary];
    }
    return _footerAttributes;
}

- (NSMutableArray *)unionRects {
  if (!_unionRects) {
    _unionRects = [NSMutableArray array];
  }
  return _unionRects;
}

- (NSMutableArray *)columnHeights {
  if (!_columnHeights) {
    _columnHeights = [NSMutableArray array];
  }
  return _columnHeights;
}

- (NSMutableArray *)allItemAttributes {
  if (!_allItemAttributes) {
    _allItemAttributes = [NSMutableArray array];
  }
  return _allItemAttributes;
}

- (NSUInteger)shortestColumnIndexInSection:(NSInteger)section {
  __block NSUInteger index = 0;
  __block CGFloat shortestHeight = MAXFLOAT;

  [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CGFloat height = [obj floatValue];
    if (height < shortestHeight) {
      shortestHeight = height;
      index = idx;
    }
  }];
  return index;
}

- (NSUInteger)longestColumnIndexInSection:(NSInteger)section {
  __block NSUInteger index = 0;
  __block CGFloat longestHeight = 0;

  [self.columnHeights[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    CGFloat height = [obj floatValue];
    if (height > longestHeight) {
      longestHeight = height;
      index = idx;
    }
  }];
  return index;
}

- (id<ACGWaterfallDelegateFlowLayout>)delegate {
    return (id<ACGWaterfallDelegateFlowLayout>)self.collectionView.delegate;
}

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self defaultInit];
  }
  return self;
}

- (void)defaultInit {
    _columnCount = 2;
    _minimumColumnSpacing = 10;
    _minimumInteritemSpacing = 10;
    _headerHeight = 0;
    _footerHeight = 0;
    _sectionInset = UIEdgeInsetsZero;
    _headerInset  = UIEdgeInsetsZero;
    _footerInset  = UIEdgeInsetsZero;
}

#pragma mark - Methods to Override

- (void)prepareLayout {
    [super prepareLayout];
    [self.allItemAttributes removeAllObjects];
    [self.headerAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    [self.footerAttributes removeAllObjects];
    [self.columnHeights removeAllObjects];
    if (![self.collectionView.delegate conformsToProtocol:@protocol(ACGWaterfallDelegateFlowLayout)]) {
        return;
    }
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return;
    }
    NSInteger column = 0;
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger columnCount = [self columnCountForSection:section];
        NSMutableArray *sectionColumnHeights = [NSMutableArray arrayWithCapacity:columnCount];
        for (column = 0; column < columnCount; column++) {
            [sectionColumnHeights addObject:@(0)];
        }
        [self.columnHeights addObject:sectionColumnHeights];
    }
    [self prepareLayoutForsSection];
    NSInteger item = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (item < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[item]).frame;
        NSInteger rectEndIndex = MIN(item + unionSize, itemCounts);
        for (NSInteger i = item + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }
        item = rectEndIndex;
        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

- (void)prepareLayoutForsSection {
    CGFloat top = 0;
    UICollectionViewLayoutAttributes *attributes;
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++) {
        /*
        * 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
        */
        CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingForSection:section];
        CGFloat minimumColumnSpacing = [self minimumColumnSpacingForSection:section];
        UIEdgeInsets sectionInset = [self sectionInsetForSection:section];
        CGFloat width = self.collectionView.bounds.size.width - sectionInset.left - sectionInset.right;
        NSInteger columnCount = [self columnCountForSection:section];
        CGFloat itemWidth = WFLFloorCGFloat((width - (columnCount - 1) * minimumColumnSpacing) / columnCount);

        /*
        * 2. Section header
        */
        CGFloat headerHeight = [self heightForHeaderInSection:section];
        UIEdgeInsets headerInset = [self insetForFooterInSection:section];
        top += headerInset.top;
        if (headerHeight > 0) {
             attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:ACGWaterfallElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
             attributes.frame = CGRectMake(headerInset.left,
                                           top,
                                           self.collectionView.bounds.size.width - (headerInset.left + headerInset.right),
                                           headerHeight);

             self.headerAttributes[@(section)] = attributes;
             [self.allItemAttributes addObject:attributes];
             top = CGRectGetMaxY(attributes.frame) + headerInset.bottom;
        }
        top += sectionInset.top;
        for (NSInteger column = 0; column < columnCount; column++) {
             self.columnHeights[section][column] = @(top);
        }

        /*
        * 3. Section items
        */
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];

        // Item will be put into shortest column.
        for (NSInteger item = 0; item < itemCount; item++) {
             NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
             NSUInteger columnIndex = [self shortestColumnIndexInSection:section];
             CGFloat xOffset = sectionInset.left + (itemWidth + minimumColumnSpacing) * columnIndex;
             CGFloat yOffset = [self.columnHeights[section][columnIndex] floatValue];
             CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
             CGFloat itemHeight = 0;
             if (itemSize.height > 0 && itemSize.width > 0) {
               itemHeight = WFLFloorCGFloat(itemSize.height * itemWidth / itemSize.width);
             }
             attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
             attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
             [itemAttributes addObject:attributes];
             [self.allItemAttributes addObject:attributes];
             self.columnHeights[section][columnIndex] = @(CGRectGetMaxY(attributes.frame) + minimumInteritemSpacing);
        }
        [self.sectionItemAttributes addObject:itemAttributes];

        /*
        * 4. Section footer
        */
        CGFloat footerHeight = [self heightForFooterInSection:section];
        NSUInteger columnIndex = [self longestColumnIndexInSection:section];
        if (((NSArray *)self.columnHeights[section]).count > 0) {
            top = [self.columnHeights[section][columnIndex] floatValue] - minimumInteritemSpacing + sectionInset.bottom;
        } else {
            top = 0;
        }
        UIEdgeInsets footerInset = [self insetForFooterInSection:section];
        top += footerInset.top;
        if (footerHeight > 0) {
             attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:ACGWaterfallElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
             attributes.frame = CGRectMake(footerInset.left,
                                           top,
                                           self.collectionView.bounds.size.width - (footerInset.left + footerInset.right),
                                           footerHeight);

             self.footerAttributes[@(section)] = attributes;
             [self.allItemAttributes addObject:attributes];
             top = CGRectGetMaxY(attributes.frame) + footerInset.bottom;
        }
        for (NSInteger column = 0; column < columnCount; column++) {
            self.columnHeights[section][column] = @(top);
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([kind isEqualToString:ACGWaterfallElementKindSectionHeader]) {
        attribute = self.headerAttributes[@(indexPath.section)];
    } else if ([kind isEqualToString:ACGWaterfallElementKindSectionFooter]) {
        attribute = self.footerAttributes[@(indexPath.section)];
    }
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableDictionary *cellAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerAttrDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *decorAttrDict = [NSMutableDictionary dictionary];
    for (i = 0; i < self.unionRects.count; i++) {
      if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
        begin = i * unionSize;
        break;
      }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
      if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
        end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
        break;
      }
    }
    for (i = begin; i < end; i++) {
      UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
      if (CGRectIntersectsRect(rect, attr.frame)) {
        switch (attr.representedElementCategory) {
        case UICollectionElementCategoryCell:
            cellAttrDict[attr.indexPath] = attr;
            break;
        case UICollectionElementCategorySupplementaryView:
            if ([attr.representedElementKind isEqualToString:ACGWaterfallElementKindSectionHeader]) {
                headerAttrDict[attr.indexPath] = attr;
            } else if ([attr.representedElementKind isEqualToString:ACGWaterfallElementKindSectionFooter]) {
                footerAttrDict[attr.indexPath] = attr;
            }
            break;
        case UICollectionElementCategoryDecorationView:
            decorAttrDict[attr.indexPath] = attr;
            break;
          default:
            break;
        }
      }
    }
    NSArray *result = [cellAttrDict.allValues arrayByAddingObjectsFromArray:headerAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:footerAttrDict.allValues];
    result = [result arrayByAddingObjectsFromArray:decorAttrDict.allValues];
    return result;
}

- (CGSize)collectionViewContentSize {
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
      return CGSizeZero;
    }
    CGSize contentSize = self.collectionView.bounds.size;
    contentSize.height = [[[self.columnHeights lastObject] firstObject] floatValue];
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
      return YES;
    }
    return NO;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    if (path.section >= [self.sectionItemAttributes count]) {
      return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count]) {
      return nil;
    }
    return (self.sectionItemAttributes[path.section])[path.item];
}

@end

