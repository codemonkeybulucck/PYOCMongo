//
//  ViewController.m
//  Meizi
//
//  Created by lemon on 2016/12/16.
//  Copyright © 2016年 lemon. All rights reserved.
//

#import "ViewController.h"
#import "BeautyCell.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *beautyArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGRect originImageFrame;
@property (nonatomic,weak) UIView *bgBlackView;
@property (nonatomic,weak) UIImageView *bigImageView;
@property (nonatomic,weak) UIView *whiteView;
@property (nonatomic,assign) BOOL isScale;
@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 懒加载数据
-(NSMutableArray *)beautyArray{
    if (!_beautyArray)
    {
        _beautyArray = [NSMutableArray array];
    }
    return  _beautyArray;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return  _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self prepareUI];
    [self loadData];
}

#pragma mark - 设置UI
- (void)prepareUI{
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置下拉刷新控件
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }

    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // Set the ordinary state of animated images
    [header setImages:idleImages forState:MJRefreshStateIdle];
    // Set the pulling state of animated images（Enter the status of refreshing as soon as loosen）
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    // Set the refreshing state of animated images
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;
    //header.stateLabel.hidden = YES;
    [header setTitle:@"Beautiful girls 下来吧" forState:MJRefreshStateIdle];
    [header setTitle:@"放开那堆Beautiful girls" forState:MJRefreshStatePulling];
    [header setTitle:@"一大波Beautiful girl正在袭来" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];

    
    // Set textColor
    header.stateLabel.textColor = [UIColor brownColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor yellowColor];
    // Set header
    self.tableView.mj_header = header;
    
}

#pragma mark - 加载数据
- (void)loadData{
    [BeautyModel beautyArrayWithOffset:0 limit:10 complection:^(NSArray *array,NSError *error) {
        NSLog(@"array = %@",array);
        NSLog(@"error = %@",error);
        if (error != nil)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"加载错误,请重新刷新";
            if (error.code == -1004)
            {
                hud.label.text = @"服务器未开启，请先开启服务器";
            }
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1.5];
        }
        if (array!=nil)
        {
            self.beautyArray = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadNewData{
    NSLog(@"加载新数据");
    [BeautyModel beautyArrayWithOffset:(int)self.beautyArray.count limit:10 complection:^(NSArray *array, NSError *error) {
        if (error != nil) {
            NSLog(@"error = %@",error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"加载错误,请重新刷新";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1.5];
        }
        if (array.count != 0)
        {
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)];
            [self.beautyArray insertObjects:array atIndexes:set];
            [self.tableView reloadData];
        }
    }];
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.beautyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BeautyModel *model = self.beautyArray[indexPath.row];
    BeautyCell *cell = [BeautyCell cellWithTableView:tableView];
    cell.isLast = indexPath.row == (self.beautyArray.count - 1) ? YES:NO ;
    cell.model = model;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //出现一个单独的view来显示图片
    [self showBigImageWithIndexPath:indexPath];
}


- (void)showBigImageWithIndexPath:(NSIndexPath*)indexPath{
    //计算当前cell的imageView在self.view的位置
    BeautyCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.originImageFrame = [cell convertRect:cell.beautyView.frame toView:self.view];
    
    //添加白色view盖住cell的imageview
    UIView *whiteView = [[UIView alloc] initWithFrame:self.originImageFrame];
    whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView = whiteView;
    [self.view addSubview:whiteView];
    
    //首先添加最底层的黑色backgroundView
    UIView *bgView  = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor blackColor];
    self.bgBlackView = bgView;
    [self.view addSubview:bgView];
    
    //获得原始图片的大小
    CGSize size = cell.beautyView.image.size;
    //计算适配屏幕的大小
    //如果大于屏幕尺寸
    if (size.width > ScreenWidth)
    {
        CGFloat height = (ScreenWidth * size.height) / size.width;
        size = CGSizeMake(ScreenWidth, height);
    }
    //如果小于屏幕尺寸
    if (size.width < ScreenWidth)
    {
        CGFloat height = (ScreenHeight * size.height)/size.width;
        size = CGSizeMake(ScreenWidth, height);
    }
    
    //创建新的imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.originImageFrame];
    imageView.userInteractionEnabled = YES;
    self.bigImageView = imageView;
    imageView.image = cell.beautyView.image;
    [self.view addSubview:imageView];
    [UIView animateWithDuration:1 animations:^{
        imageView.center = self.view.center;
        imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    }completion:^(BOOL finished) {
        //添加手势
        //添加单击返回手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigImageView)];
        singleTap.numberOfTapsRequired = 1; //点击次数
        singleTap.numberOfTouchesRequired = 1;
        
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigImageView)];
        singleTap.numberOfTapsRequired = 1; //点击次数
        singleTap.numberOfTouchesRequired = 1;
        
        //添加双击放大缩小手势
        UITapGestureRecognizer *doubelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
        doubelTap.numberOfTapsRequired = 2;
        doubelTap.numberOfTouchesRequired = 1;
        UITapGestureRecognizer *doubelTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageView:)];
        doubelTap1.numberOfTapsRequired = 2;
        doubelTap1.numberOfTouchesRequired = 1;
        
        //拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.bigImageView addGestureRecognizer:pan];
        
        //让双击手势识别失败之后才去识别单击手势
        [singleTap requireGestureRecognizerToFail:doubelTap];
        [singleTap1 requireGestureRecognizerToFail:doubelTap1];
        
        [self.bgBlackView addGestureRecognizer:singleTap1];
        [self.bigImageView addGestureRecognizer:singleTap];
        [self.bgBlackView addGestureRecognizer:doubelTap1];
        [self.bigImageView addGestureRecognizer:doubelTap];

    }];
}

#pragma  mark - 手势方法
//单指点击
- (void)dismissBigImageView{
    NSLog(@"取消大图");
    [self.bgBlackView removeFromSuperview];
    self.bgBlackView = nil;
    
    [UIView animateWithDuration:0.8 animations:^{
        self.bigImageView.frame = self.originImageFrame;
    } completion:^(BOOL finished) {
        [self.whiteView removeFromSuperview];
        self.whiteView = nil;
        [self.bigImageView removeFromSuperview];
        self.bigImageView = nil;
    }];
}

//单指双击
- (void)scaleImageView:(UITapGestureRecognizer*)tap{
    NSLog(@"放大缩小图片");
    CGFloat scale = 1.0 / 1.5;
    //如果此时图片没有放大那么就是要放大
    BOOL isScale =CGAffineTransformIsIdentity(self.bigImageView.transform);
    if (isScale)
    {
        scale = 1.5;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bigImageView.transform  = CGAffineTransformScale(self.bigImageView.transform,scale, scale);
        self.bigImageView.center = self.view.center;
    }];
}

//双指拖拽
- (void)handlePan:(UIPanGestureRecognizer*)pan{
    //获得拖拽的位置
    CGPoint point = [pan translationInView:self.view];
    //改变imageview的坐标
    CGPoint center = self.bigImageView.center;
    CGFloat centerX = center.x + point.x;
    CGFloat centerY = center.y + point.y;
    
    self.bigImageView.center = CGPointMake(centerX, centerY);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];


    //不让图片跑出屏幕外面
    CGSize size = self.bigImageView.bounds.size;
    //如果图片的宽度小于屏幕的宽度，那么让图片回到中心点
    if (CGAffineTransformIsIdentity(self.bigImageView.transform))
    {
        if (size.width < ScreenWidth || size.height < ScreenHeight)
        {
            [UIView animateWithDuration:0.4 animations:^{
                self.bigImageView.center = self.view.center;
            }];
        }
    }else{
        CGRect originF = self.bigImageView.frame;
        //判断图片不要超出边界
        if (originF.origin.x > 0)
        {
            originF.origin.x = 0;
            [UIView animateWithDuration:0.4 animations:^{
                self.bigImageView.frame = originF;
            }];
        }
        if (originF.origin.y > 0)
        {
            originF.origin.y = 0;
            [UIView animateWithDuration:0.4 animations:^{
                self.bigImageView.frame = originF;
            }];
        }
        CGFloat maxX = CGRectGetMaxX(originF);
        CGFloat maxY = CGRectGetMaxY(originF);
        if (maxX < ScreenWidth)
        {
            originF.origin.x = - (originF.size.width - ScreenWidth);
            [UIView animateWithDuration:0.4 animations:^{
                self.bigImageView.frame = originF;
            }];
        }
        if (maxY < ScreenHeight)
        {
            originF.origin.y = - (originF.size.height - ScreenHeight);
            [UIView animateWithDuration:0.4 animations:^{
                self.bigImageView.frame = originF;
            }];
        }
    }
}









@end
