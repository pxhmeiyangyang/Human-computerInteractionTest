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
#import "UIViewController+BackButtonHandler.h"
static NSString* identifer = @"collectionCell";

@interface ListenTestVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property(nonatomic,assign)BOOL isFinished;

@end

@implementation ListenTestVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(NSString *)VCTitle{
    return @"Modul1";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetData];
    [self VCTitle];
    [self setNavigation];
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

-(void)setNavigation{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationItem setTitle:[self VCTitle]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(naviBackAction)];
}
-(void)naviBackAction{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"课程没有结束确定退出吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}
//-(BOOL)navigationShouldPopOnBackButton{
//    NSLog(@"返回触发事件");
////    if (_isFinished) {
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"课程没有结束确定退出吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.delegate = self;
//        [alert show];
////    }
//    return YES;
//}
#pragma mark - UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        //确定
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //取消
    }
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
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //移除所有界面元素
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    _collectionLayout = nil;
}
-(void)dealloc{
    NSLog(@"dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
