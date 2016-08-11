//
//  MapViewController.m
//  MapAndLocation
//
//  Created by dingjing on 16/8/11.
//  Copyright © 2016年 dingjing. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"

@interface MapViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKAnnotationView *annotationView;


@end
CLLocationCoordinate2D userActionArray[1000];
NSInteger userActionCount = 0;
@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userActionCount = 0;
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    MapAnnotation *annotation = [[MapAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(40.0147940000,116.4902270000)];
    [self.mapView addAnnotation:annotation];
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.annotationView = [[MKAnnotationView alloc] init];
    self.annotationView.canShowCallout = YES;
    self.annotationView.image = [UIImage imageNamed:@"annomation"];
    
//    self.annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"newImage.jpeg"]];
//    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    [control setBackgroundColor:[UIColor redColor]];
    self.annotationView.detailCalloutAccessoryView = control;
    [self.view setUserInteractionEnabled:YES];
    [control setUserInteractionEnabled:YES];
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance([self.manager location].coordinate, 200, 200)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered //每次渲染完都会回调
{
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation 	//用户位置发生改变时触发（第一次定位到用户位置也会触发该方法）
{
    if(userActionCount >= 1000) {
        return;
    }
    CLLocationCoordinate2D coordinate = userLocation.coordinate;
    userActionArray[userActionCount] = coordinate;
    
    userActionCount ++;
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:userActionArray count:userActionCount];
    [self.mapView addOverlay:polyline];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView	//地图加载完成后触发
{
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation	//显示大头针时触发，返回大头针视图，通常自定义大头针可以通过此方法进行
{
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        return self.annotationView;
    } else {
        return nil;
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view	//点击选中某个大头针时触发
{
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view	//取消选中大头针时触发 //其实是点地图中非大头针部分会触发
{
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    render.fillColor = [UIColor redColor];
    render.lineWidth = 1.0f;
    render.strokeColor = [UIColor redColor];
    return render;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
