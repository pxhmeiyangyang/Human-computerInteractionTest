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
#import "MJExtension.h"
#define cellCount 4

@interface ListenTestVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic,strong) NSMutableDictionary* cellDic;

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
    [self getMyPaperModel];
}
-(void)resetData{
    _collectionView.delegate                       = self;
    _collectionView.dataSource                     = self;
    _collectionView.scrollEnabled                  = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView setBackgroundColor:YZH_BG_COLOR];
//    [_collectionView registerNib:[UINib nibWithNibName:@"ListenTestCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    _collectionLayout.itemSize                     = CGSizeMake(kScreenWidth, kScreenHeight - 44);
    _cellDic                                       = [NSMutableDictionary dictionary];
}

-(void)getMyPaperModel{
    NSString* jsonPath = [[NSBundle mainBundle]pathForResource:@"paper" ofType:@"json"];
    NSData* jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    PaperModel* model = [PaperModel mj_objectWithKeyValues:dict];
    self.paperModel = model;
    NSLog(@"json dict:%@",dict);
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
    return cellCount;
}
-(UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString* identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
    if (!identifier) {
        identifier = [NSString stringWithFormat:@"collectioncell%@",indexPath];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@",indexPath]];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ListenTestCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    ListenTestCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.nextItemBlock = ^(){
        NSIndexPath* currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
        NSInteger nextItem = currentIndexPath.item + 1;
        if (nextItem > cellCount) {
         //跳转到下一个页面
        }else{
            NSInteger nextSection = currentIndexPath.section;
            NSIndexPath* nextIndexpath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
            [self.collectionView scrollToItemAtIndexPath:nextIndexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除所有界面元素
    [_collectionView removeFromSuperview];
    _collectionView = nil;
    _collectionLayout = nil;
}

-(void)dealloc{
    NSLog(@"ListenVC dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
