//
//  ViewController.m
//  WWCollectionWaterfallLayout
//
//  Created by Tidus on 17/1/13.
//  Copyright © 2017年 Tidus. All rights reserved.
//

#import "ViewController.h"
#import "CollectionWaterfallLayout.h"

#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavigationBarHeight (self.navigationController.navigationBar.frame.size.height)
#define TabBarHeight (self.tabBarController.tabBar.frame.size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

static NSString *kCollectionViewCellReusableID = @"kCollectionViewCellReusableID";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CollectionWaterfallLayoutProtocol>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionWaterfallLayout *waterfallLayout;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupDataList];
    [self setupRightButton];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源
- (void)setupDataList
{
    _dataList = [NSMutableArray array];
    NSInteger dataCount = arc4random()%25+50;
    for(NSInteger i=0; i<dataCount; i++){
        NSInteger rowHeight = arc4random()%100+200;
        [_dataList addObject:@(rowHeight)];
    }
    
}

- (void)setupRightButton
{
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self action:@selector(buttonClick)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, nil];
}

- (void)buttonClick
{
    [self setupDataList];
    [self.collectionView reloadData];
    
}
#pragma mark - getter
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _waterfallLayout = [[CollectionWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = 10;
        _waterfallLayout.insets = UIEdgeInsetsMake(5, 10, 5, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-StatusBarHeight-NavigationBarHeight) collectionViewLayout:_waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellReusableID];
    }
    
    
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return _dataList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellReusableID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UICollectionViewCell alloc] init];
    }
    
    CGFloat red = arc4random()%256/255.0;
    CGFloat green = arc4random()%256/255.0;
    CGFloat blue = arc4random()%256/255.0;
    
    cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return cell;
    
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CollectionWaterfallLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat cellHeight = [_dataList[row] floatValue];
    return cellHeight;
}

@end
