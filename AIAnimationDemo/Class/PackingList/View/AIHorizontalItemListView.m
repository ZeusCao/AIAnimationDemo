//
//  AIHorizontalItemListView.m
//  AIAnimationDemo
//
//  Created by 艾泽鑫 on 2017/1/20.
//  Copyright © 2017年 艾泽鑫. All rights reserved.
//

#import "AIHorizontalItemListView.h"
#import "AIPackingCollectionViewCell.h"
@interface AIHorizontalItemListView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)UICollectionView *collectionView;
/** 数据源*/
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

static NSString *identifier = @"cell";
@implementation AIHorizontalItemListView

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSArray *titleArray = @[@"Icecream money", @"Great weather", @"Beach ball", @"Swim suit for him", @"Swim suit for her", @"Beach games", @"Ironing board", @"Cocktail mood", @"Sunglasses", @"Flip flops"];
        for (int i = 0; i < 8; i++) {
            AIPackingModel *model = [[AIPackingModel alloc]init];
            NSString *imageString = [NSString stringWithFormat:@"summericons_100px_0%d",i];
            model.image           = imageString;
            model.title           = titleArray[i];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout *flowLaout = [[UICollectionViewFlowLayout alloc]init];
        flowLaout.itemSize                    = CGSizeMake(60, 60);
        flowLaout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView      = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KWidth, 60) collectionViewLayout:flowLaout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate               = self;
        collectionView.dataSource             = self;
        collectionView.backgroundColor        = [UIColor clearColor];
        [collectionView registerClass:[AIPackingCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        self.collectionView                   = collectionView;
        [self addSubview:collectionView];
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AIPackingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    AIPackingModel *model = self.dataSource[indexPath.item];
    cell.imageString      = model.image;
    return cell;
}
#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AILog(@"---%ld",indexPath.row);
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalItemListView:didSelectedModel:)]) {
        [self.delegate horizontalItemListView:self didSelectedModel:self.dataSource[indexPath.item]];
    }
}


@end
