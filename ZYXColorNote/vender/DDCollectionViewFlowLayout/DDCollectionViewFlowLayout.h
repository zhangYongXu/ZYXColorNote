//
//  TabOneViewController.h
//  TEST
//
//  Created by 极客天地 on 16/2/24.
//  Copyright © 2016年 极客天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DDCollectionViewFlowLayout;

@protocol DDCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@required
/**
 *  获取瀑布流列数
 *
 *  @param collectionView
 *  @param layout
 *  @param section
 *
 *  @return The number of columns in each section.
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(DDCollectionViewFlowLayout *)layout
   numberOfColumnsInSection:(NSInteger)section;

@end


@interface DDCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<DDCollectionViewDelegateFlowLayout> delegate;
/**
 *  头视图是否滞留在顶部，默认为false.
 */
@property (nonatomic) BOOL enableStickyHeaders;

@end
