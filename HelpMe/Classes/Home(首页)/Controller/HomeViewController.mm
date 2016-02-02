//
//  HomeViewController.m
//  HelpMe
//
//  Created by 刘伟龙 on 16/2/2.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController()

@property (nonatomic, strong) BMKMapView            *mapView;
@property (nonatomic, strong) BMKLocationService    *locationService;
@property (nonatomic, strong) BMKPointAnnotation    *annotation;

@property (nonatomic, strong) MainMenuPopVC *popMenu;
@end

@implementation HomeViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBgColor;
    
    [self setSubNavgationView];
    [self setMapView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    // 删除标注
//    if (annotation != nil) {
//        [_mapView removeAnnotation:annotation];
//    }
}

-(void)addAnnotationWithCoor:(CLLocationCoordinate2D)coor{
    // 添加标注
    if (_annotation != nil) {
        [_mapView removeAnnotation:_annotation];
    }else{
        _annotation = [[BMKPointAnnotation alloc]init];
    }
    _annotation.coordinate = coor;
    _annotation.title = @"您在这儿";
    [_mapView addAnnotation:_annotation];
}

#pragma mark 设置主页面相关内容
// 设置主页面内容
-(void)setSubNavgationView{
    self.navigationItem.title = @"帮我";
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myself_normal"] style:UIBarButtonItemStyleDone target:self action:@selector(popMyMenu)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

/**
 *  显示主菜单
 */
-(void)popMyMenu{
    DBLog(@"显示菜单");
    
    if (_popMenu == nil) {
        MainMenuPopVC *popMenu = [[MainMenuPopVC alloc] init];
        popMenu.view.frame = CGRectMake(-kMenuTableViewVCWidth, 0, kScreenWidth * 2/ 3, kScreenHeight);
        popMenu.delegate = self;
        _popMenu = popMenu;
        [self addChildViewController:popMenu];
        [self.view addSubview:popMenu.view];
    }
    if (self.popMenu.view.x != 0) {
        [self popMenuViewShow:YES];
    }else{
        [self popMenuViewShow:NO];
    }
}

/**
 *  设置地图内容
 */
-(void)setMapView{
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [mapView setZoomEnabled:YES];
    [mapView setZoomEnabledWithTap:YES];
     mapView.showMapScaleBar = YES;
    [mapView setMapScaleBarPosition:CGPointMake(kScreenWidth - 100, kScreenHeight - 30)];
    [mapView setZoomLevel:17];
    [mapView setLogoPosition:BMKLogoPositionRightBottom];
    [self.view addSubview: mapView];
    _mapView = mapView;
    
    [self addSwipeRecognizer];
    
    // 定位服务
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
}

-(void)popMenuViewShow:(BOOL)bShow{
    [UIView animateWithDuration:0.1 animations:^{
        if (!bShow){
            self.popMenu.view.x = -kMenuTableViewVCWidth;
        }else{
            self.popMenu.view.x = 0;
        }
    }];
}

-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self popMenuViewShow:NO];
}

#pragma mark BMKMapViewDelegate
// 标注修改
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        //newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark BMKLocationServiceDelegate
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    DBLog(@"heading is %@",userLocation.heading);
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    static BOOL bFirstTime = YES;
    
    DBLog(@"location is %@",userLocation.location);
    CLLocation *location = (CLLocation *)userLocation.location;
    
    CLLocationCoordinate2D coor = location.coordinate;
    [self addAnnotationWithCoor:coor];
    
    // 定位位置显示在屏幕中央
    if (bFirstTime) {
        [_mapView setCenterCoordinate:coor];
        bFirstTime = !bFirstTime;
    }
}

-(void)addSwipeRecognizer{
    [self addSwipeRecognizerLeft];
    [self addSwipeRecognizerRight];
}

// 添加左滑手势
- (void)addSwipeRecognizerLeft
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopMenu:)];
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    // 添加手势
    [self.mapView addGestureRecognizer:swipeRecognizer];
}

// 添加右滑手势
- (void)addSwipeRecognizerRight
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPopMenu:)];
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    // 添加手势
    [self.mapView addGestureRecognizer:swipeRecognizer];
}

-(void)showPopMenu:(UISwipeGestureRecognizer *)swipeRecognizer{
    if (_popMenu == nil) {
        MainMenuPopVC *popMenu = [[MainMenuPopVC alloc] init];
        popMenu.view.frame = CGRectMake(-kMenuTableViewVCWidth, 0, kScreenWidth * 2/ 3, kScreenHeight);
        popMenu.delegate = self;
        _popMenu = popMenu;
        [self addChildViewController:popMenu];
        [self.view addSubview:popMenu.view];
    }
    
    CGPoint point = [swipeRecognizer locationInView:self.mapView];
    if (point.x <= 15) {
        [UIView animateWithDuration:0.1 animations:^{
            self.popMenu.view.x = 0;
        }];
    }
}

-(void)hidePopMenu:(UISwipeGestureRecognizer *)swipeRecognizer{
    [UIView animateWithDuration:0.1 animations:^{
        self.popMenu.view.x = -kMenuTableViewVCWidth;
    }];
}

#pragma mark MainPopMenuDelegate
-(void)popMenuDidSelected:(NSIndexPath *)indexPath{
    DBLog(@"section %ld, row: %ld", indexPath.section, indexPath.row);
}
@end
