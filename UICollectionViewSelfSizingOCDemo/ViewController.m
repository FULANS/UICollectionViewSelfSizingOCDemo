//
//  ViewController.m
//  UICollectionViewSelfSizingOCDemo
//
//  Created by wangzheng on 16/11/30.
//  Copyright © 2016年 WZheng. All rights reserved.
//

#import "ViewController.h"
#import "SelfSizingCollectCell.h"
#import "NSObject+IndexPath.h"
@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collection;

@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *editArr;

@end

@implementation ViewController

#pragma mark --- lazyinit
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)editArr{
    if (!_editArr) {
        _editArr = [NSMutableArray array];
    }
    return _editArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString  *text = @"The UICollectionViewFlowLayout class is a concrete layout object that organizes items into a grid with optional header and footer views for each section. The items in the collection view flow from one row or column (depending on the scrolling direction) to the next, with each row comprising as many cells as will fit. Cells can be the same sizes or different sizesThe UICollectionViewFlowLayout class is a concrete layout object that organizes items into a grid with optional header and footer views for each section. The items in the collection view flow from one row or column (depending on the scrolling direction) to the next, with each row comprising as many cells as will fit. Cells can be the same sizes or different sizesThe UICollectionViewFlowLayout class is a concrete layout object that organizes items into a grid with optional header and footer views for each section. The items in the collection view flow from one row or column (depending on the scrolling direction) to the next, with each row comprising as many cells as will fit. Cells can be the same sizes or different sizesThe UICollectionViewFlowLayout class is a concrete layout object that organizes items into a grid with optional header and footer views for each section. The items in the collection view flow from one row or column (depending on the scrolling direction) to the next, with each row comprising as many cells as will fit. Cells can be the same sizes or different sizes.";
    self.dataArr = [[text componentsSeparatedByString:@" "] mutableCopy];
    
    

    // 创建一个网状结构
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置网状结构的具体属性
    // 1.设置 最小行间距
    layout.minimumLineSpacing = 20;
    // 2.设置 最小列间距
    layout. minimumInteritemSpacing  = 10;
    // 3.设置item块的大小 (可以用于自适应)
    layout.estimatedItemSize = CGSizeMake(20, 60);
    // 设置滑动的方向 (默认是竖着滑动的)
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    // 设置item的内边距  (一般结构体的对象的创建都是...make, 像size,rect,frame都是这样的)  上 左 下 右 (上指的是第一行距表头下边的距离,左指距离左侧边缘的距离,下指的是:最下面一行距离表尾的上部的距离,右指的是距离右侧边缘的距离)
    layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.view addSubview:self.collection];
    [self.collection registerClass:[SelfSizingCollectCell class] forCellWithReuseIdentifier:@"SelfSizingCollectCell"];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItems = @[edit];
    
  
    
}

#pragma mark --- Action
- (void)editAction:(UIBarButtonItem *)sender{
    
    if ([sender.title isEqualToString:@"编辑"]) {
        // 说明点击时是编辑: -> 操作开启编辑
        [self.collection setAllowsMultipleSelection:YES];
        sender.title = @"取消编辑";
    }else{
        
        // 说明此时是取消编辑:
        [self.collection setAllowsMultipleSelection:NO];
        sender.title = @"编辑";
    }
    
    [self.collection reloadData];
    
}



- (void)deleteItemsFromDataSourceAtIndexPaths:(NSArray *)itemPaths{
    
    
    [itemPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *idex = obj;
        [self.dataArr removeObjectAtIndex:idex.row];
    }];
    
   
    
}


#pragma MARK --- UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelfSizingCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelfSizingCollectCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];

    UIBarButtonItem *edit = self.navigationItem.rightBarButtonItem;
    
    if ([edit.title isEqualToString:@"取消编辑"]) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        // 添加到数组里 (变值 为角度)
        animation.values = @[@(-M_PI_4 /90.0 * 10),@(M_PI_4 /90.0 * 10),@(-M_PI_4 /90.0 * 10)];
        animation.duration = 0.2;
        animation.repeatCount = CGFLOAT_MAX;
        // 把动画添加到处layer蹭上
        [cell.layer addAnimation:animation forKey:@"transform.rotation"];
    }
    
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.navigationItem.rightBarButtonItem title] isEqualToString:@"取消编辑"]) {
        [self.collection performBatchUpdates:^{
            // 从数据源中清除:
            [self.dataArr removeObjectAtIndex:indexPath.row];
            // 从collectionview上移除item
            [self.collection deleteItemsAtIndexPaths:@[indexPath]];
            
        } completion:^(BOOL finished) {
        }];
    }else{
        UIAlertController *notice = [UIAlertController alertControllerWithTitle:@"标签" message:self.dataArr[indexPath.row] preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:notice animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [notice dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
