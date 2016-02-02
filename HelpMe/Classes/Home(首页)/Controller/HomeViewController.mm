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
    
    // 添加标注
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    
//    // 删除标注
//    if (annotation != nil) {
//        [_mapView removeAnnotation:annotation];
//    }
}

#pragma mark 设置主页面相关内容
// 设置主页面内容
-(void)setSubNavgationView{
    self.navigationItem.title = @"帮我";
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myself_normal"] style:UIBarButtonItemStyleDone target:self action:@selector(showMyMenu)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

/**
 *  显示主菜单
 */
-(void)showMyMenu{
    DBLog(@"显示菜单");
}

/**
 *  设置地图内容
 */
-(void)setMapView{
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _mapView = mapView;
    [self.view addSubview: mapView];
    
    // 定位服务
    _locationService = [[BMKLocationService alloc] init];
    _locationService.delegate = self;
    [_locationService startUserLocationService];
}

#pragma mark BMKMapViewDelegate

// 标注修改
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

#pragma mark BMKLocationServiceDelegate
-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    DBLog(@"heading is %@",userLocation.heading);
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    DBLog(@"location is %@",userLocation.location);
}
@end
