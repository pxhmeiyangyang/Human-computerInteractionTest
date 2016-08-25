//
//  ListenTestVC.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/24.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "ListenTestVC.h"
#import "ReadingAloudVC.h"
#import "ListenTestCollectionCell.h"
static NSString* identifer = @"collectionCell";

@interface ListenTestVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@end

@implementation ListenTestVC

-(NSString *)VCTitle{
    return @"Modul1";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetData];
    [self VCTitle];
}
-(void)resetData{
    _collectionView.delegate                       = self;
    _collectionView.dataSource                     = self;
    _collectionView.scrollEnabled                  = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView setBackgroundColor:YZH_BG_COLOR];
    [_collectionView registerNib:[UINib nibWithNibName:@"ListenTestCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    _collectionLayout.itemSize                     = CGSizeMake(kScreenWidth, kScreenHeight - 44);
}
#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ListenTestCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
//            cell.backgroundColor = [UIColor orangeColor];
        }
            break;
        case 1:
            cell.backgroundColor = YZH_BG_COLOR;
            break;
        case 2:
            cell.backgroundColor = YZH_BLUE;
            break;
        case 3:
            cell.backgroundColor = YZH_GREEN;
            break;
        default:
            break;
    }
    cell.nextItemBlock = ^(){
        NSIndexPath* currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
        NSInteger nextItem = currentIndexPath.item + 1;
        NSInteger nextSection = currentIndexPath.section;
        NSIndexPath* nextIndexpath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
        [self.collectionView scrollToItemAtIndexPath:nextIndexpath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    };
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
