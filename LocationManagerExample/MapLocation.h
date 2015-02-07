//
//  MapLocation.h
//  LocationManagerExample
//
//  Created by gfxcc on 1/19/15.
//  Copyright (c) 2015 Intuit Inc. All rights reserved.
//


#import <MapKit/MapKit.h>

@interface MapLocation : NSObject<MKAnnotation>

//街道信息属性
@property (nonatomic, copy) NSString *streetAddress;
//城市信息属性
@property (nonatomic, copy) NSString *city;
//州、省、市信息
@property (nonatomic, copy) NSString *state;
//邮编
@property (nonatomic, copy) NSString *zip;
//地理坐标
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end
