//
//  MapViewController.h
//  MapAndLocation
//
//  Created by dingjing on 16/8/11.
//  Copyright © 2016年 dingjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@end
