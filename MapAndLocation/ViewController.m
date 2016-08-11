//
//  ViewController.m
//  MapAndLocation
//
//  Created by dingjing on 16/8/10.
//  Copyright © 2016年 dingjing. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLCircularRegion *workRegion;
@property (nonatomic, strong) CLCircularRegion *homeRegion;
@property (nonatomic, strong) CLCircularRegion *wangjingxi;
@property (nonatomic, strong) CLCircularRegion *huoying;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",[CLLocationManager locationServicesEnabled]);
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    self.manager = [[CLLocationManager alloc] init];
    [self.manager requestAlwaysAuthorization];
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.manager startUpdatingLocation];
    }
    self.manager.delegate = self;
    status = [CLLocationManager authorizationStatus];
    self.manager.allowsBackgroundLocationUpdates = YES;
    
    self.geocoder = [[CLGeocoder alloc] init];
    self.homeRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(40.0222540000,116.5003590000) radius:500.0f identifier:@"家"];
    self.workRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(40.0167560000,116.5035210000) radius:500.0f identifier:@"公司"];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = self.view.center;
    [button setTitle:@"跳转到地图" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor orangeColor]];
    [button addTarget:self action:@selector(jumpToMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)jumpToMap
{
    MapViewController *vc = [[MapViewController alloc] init];
    vc.manager = self.manager;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.manager startUpdatingLocation];
        [self.manager startMonitoringForRegion:self.homeRegion];
        [self.manager startMonitoringForRegion:self.workRegion];
        self.homeRegion.notifyOnExit = YES;
        self.workRegion.notifyOnEntry = YES;
        self.homeRegion.notifyOnEntry = YES;
        self.workRegion.notifyOnExit = YES;
    }
}
- (void)dealloc
{
}
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.manager requestStateForRegion:self.homeRegion];
    [self.manager requestStateForRegion:self.workRegion];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:@"家"]) {
        NSLog(@"宝宝去上班了");
    } else if ([region.identifier isEqualToString:@"公司"]) {
        NSLog(@"宝宝要回家了");
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位改变" message:@"out" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:@"家"]) {
        NSLog(@"宝宝到家了");
    } else if ([region.identifier isEqualToString:@"公司"]) {
        NSLog(@"宝宝到公司了");
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位改变" message:@"out" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"in" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{

    CLLocation *location = [locations lastObject];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        NSLog(@"名称：%@,街道：%@，子街道：%@，城市：%@，邮编：%@，国家：%@，海洋：%@，兴趣点：%@", placemark.name,
              placemark.thoroughfare,
              placemark.subThoroughfare,
              placemark.locality,
              placemark.postalCode,
              placemark.country,
              placemark.ocean,
              placemark.areasOfInterest);
    }];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定位改变" message:[NSString stringWithFormat:@"纬度：%f,经度：%f", location.coordinate.latitude, location.coordinate.longitude] preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
