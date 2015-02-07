//
//  ParkingSpaceInf.h
//  LocationManagerExample
//
//  Created by gfxcc on 1/19/15.
//  Copyright (c) 2015 Intuit Inc. All rights reserved.
//

#import "Inf.h"
#import "MapLocation.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface ParkingSpaceInf : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *parkInf;

//@property (nonatomic, strong) CLLocation *currLocation;

@end


