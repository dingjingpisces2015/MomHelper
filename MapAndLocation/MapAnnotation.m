//
//  MapAnnotation.m
//  MapAndLocation
//
//  Created by dingjing on 16/8/11.
//  Copyright © 2016年 dingjing. All rights reserved.
//

#import "MapAnnotation.h"
@interface MapAnnotation()
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;


// Title and subtitle for use by selection UI.
@property (nonatomic, readwrite, copy, nullable) NSString *title;
@property (nonatomic, readwrite, copy, nullable) NSString *subtitle;
@end

@implementation MapAnnotation
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"title";
        self.subtitle = @"subTitle";
    }
    return self;
}
@end
